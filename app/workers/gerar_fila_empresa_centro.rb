class GerarFilaEmpresaCentro
  include Sidekiq::Worker
  sidekiq_options queue: 'critical', retry: false

  def perform(estado_id, empresa_id)
    ActiveRecord::Base.transaction do
      begin
        estado = Estado.find estado_id
        empresa = Empresa.find empresa_id if empresa_id.present?

        @estados_ignoraveis = [7, 9, 11, 8, 10, 13, 15, 17, 19, 20]

        empresa ||= Empresa.find_by_estado(@estados_ignoraveis.include?(estado_id) ? 'CD' : estado.sigla)
        puts "Empresa: #{empresa.id} | Estado: #{empresa.estado}"
        return if empresa.nil?

        clientes_novos = cliente_apto_ligacao_estado(estado.sigla)
        clientes_novos = clientes_novos.joins('left join cnaes on clientes.cnae_id = cnaes.id').where("cnaes.blacklist = false and clientes.data_licenca between CURRENT_DATE - interval '9 months' AND CURRENT_DATE")
        return if clientes_novos.size == 0

        cliente_fila = fila_empresa(empresa.id)
        puts "Total clientes fila #{cliente_fila.size} / novos #{clientes_novos.size}"

        importacao =  nova_importacao(empresa.id, estado)
        importacao.update(total: clientes_novos.size, importado: clientes_novos.size, nao_importado: 0, ja_existente: 0, finalizada: true);

        clientes_novos.update_all(importacao_id: importacao.id, empresa_id: empresa.id)
        clientes_importacao = Cliente.where(importacao_id: importacao.id)
        puts "Clientes Importação: #{clientes_importacao&.size}"

        clientes = Array.new
        clientes.push(*clientes_importacao.to_a) if clientes_importacao.size > 0
        clientes.push(*cliente_fila.to_a) if cliente_fila.size > 0
        puts "Total clientes geral #{clientes.size}"

        return if clientes.size < 1

        drop_all_filas(empresa.id)
        puts "Filas dropadas"

        clientesFiltrados = Array.new
        clientes.each do |cli|
          if cli.present? && !cli.fila_empresa.present? && cli.status.nil? && cli.ligacoes.first.nil? && cli.campanha_envios.first.nil?
            clientesFiltrados << cli
          end
        end
        puts "clientes filtrados"

        job0 = Array.new
        job1 = Array.new
        job2 = Array.new
        job3 = Array.new
        job4 = Array.new

        FilaEmpresa.processar_jobs_0_1_2_3_4(clientesFiltrados, job0, job1, job2, job3, job4)
        puts "Jobs processados job0 #{job0.size} / job1 #{job1.size} / job2 #{job2.size} / job3 #{job3.size} / job4 #{job4.size}"

        FilaEmpresa.criar_fila(job0, 0, empresa.id)
        FilaEmpresa.criar_fila(job1, 1, empresa.id)
        FilaEmpresa.criar_fila(job2, 2, empresa.id)
        FilaEmpresa.criar_fila(job3, 3, empresa.id)
        FilaEmpresa.criar_fila(job4, 4, empresa.id)

        reprocessar_controle_job_cd() if empresa.id = 20
        puts "Processo finalizado"

      rescue => exception
        puts exception
        raise ActiveRecord::Rollback
      end
    end
  end

  private

  def reprocessar_controle_job_cd
    count_jobs_cd = Array.new
    sleep rand(135)

    queues_in_process = Sidekiq::Workers.new
    queues_in_process.each do |process_id, thread_id, work|
      job = work['payload']['args'][0]
      puts job
      count_jobs_cd.push(job) if(@estados_ignoraveis.include? job)
    end

    intersecao_estados = count_jobs_cd & @estados_ignoraveis.last(7)
    puts "count_jobs_cd: #{count_jobs_cd}"
    puts "@estados_ignoraveis.last(7): #{@estados_ignoraveis.last(7)}"
    puts "intersecao_estados: #{intersecao_estados}"
    if(count_jobs_cd.length == 1 && intersecao_estados.length > 0)
      puts "Reprocessando todos os jobs do CD"
      (0..4).each { |numero_fila|
        clientes_empresa_cd = Cliente.joins(:fila_empresa)
          .where('fila_empresas.empresa_id = 20 AND fila_empresas.numero_fila = ?', numero_fila)

        puts "Recriando CD #{numero_fila}"
        ControleJob.recriar_controle_job_importacao clientes_empresa_cd, numero_fila, 20
      }
    end
  end

  def top_cnaes
    connection = ActiveRecord::Base.connection
    topCnaes = connection.select_all FilaEmpresasHelper.get_top_15_cnaes(1)
    topCnaes.to_a
  end

  def fila_empresa(empresa_id)
    Cliente.fila_principal_empresa(empresa_id)
    .joins('left join cnaes on clientes.cnae_id = cnaes.id')
    .where("cnaes.blacklist = false and clientes.data_licenca between CURRENT_DATE - interval '9 months' AND CURRENT_DATE")
  end

  def cliente_apto_ligacao_estado(estado)
    Cliente.joins(:cidade => :estado)
    .cnae_blacklist
    .para_ligacao
    .completo
    .where("(clientes.data_licenca between current_date - interval '9 months' and current_date)
      and estados.sigla = ? and clientes.empresa_id = ? and clientes.status_empresa = 0 ", estado, 20)
    .distinct
  end

  def nova_importacao(empresa_id, estado)
    Importacao.nova_importacao_sefaz(1, empresa_id, estado.sigla)
  end

  def drop_all_filas(empresa_id)
    filas = FilaEmpresa.where(empresa_id: empresa_id).where('numero_fila not in (11,12,13,5)')
    filas.destroy_all
  end

end