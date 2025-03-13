class FilaEmpresa < ActiveRecord::Base
  belongs_to :cliente
  belongs_to :empresa
  belongs_to :user_retorno, class_name: 'User'

  scope :contra_turno, -> { joins("inner join clientes on clientes.id = fila_empresas.cliente_id inner join ligacoes on ligacoes.cliente_id = clientes.id and ligacoes.id = (select max(id) from ligacoes where cliente_id = clientes.id)").where("((current_time between '13:00:00'::time and '19:00:00'::time and data_inicio::time between '07:00:00'::time and '12:30:00'::time ) or (current_time between '07:00:00'::time and '12:30:00'::time and data_inicio::time between '13:00:00'::time and '19:00:00'::time ))") }
  scope :not_user_retorno, ->(user) { where('(fila_empresas.user_retorno_id is null or fila_empresas.user_retorno_id != ?) ', user) }
  scope :ordem_cliente, -> { joins(:cliente).order('clientes.data_licenca desc, fila_empresas.id') }
  scope :find_by_cnaes, ->(cnaes_id = Cnae.permitidos.ids) { where('clientes.cnae_id IN (?)', cnaes_id) }
  scope :ordem_cliente_sem_joins, -> { order('clientes.data_importacao desc, fila_empresas.id') }
  scope :saldo_atual, ->(empresa_id, job) { where(empresa_id: empresa_id, numero_fila: job).size }

  def self.reprocessar_todas_filas
    filas = FilaEmpresa.all
    puts "#{filas.count} total na fila para reprocessar"

    filas.each do |fila|
      if !/^\d{2}\.\d{3}\.\d{3}\s+/.match(fila.cliente.razao_social)
        puts "job 0"
        fila.update(numero_fila: 0)
        next
      else
        qtd_vendas_por_cnae = get_qtd_vendas_cnae_ano(cliente.cnae_id)
        case
          when qtd_vendas_por_cnae >= 20
            puts "job 1"
            fila.update(numero_fila: 1)
            next
          when qtd_vendas_por_cnae >= 10 && qtd_vendas_por_cnae <= 19
            puts "job 2"
            fila.update(numero_fila: 2)
            next
          when qtd_vendas_por_cnae >= 1 && qtd_vendas_por_cnae <= 9
            puts "job 3"
            fila.update(numero_fila: 3)
            next
          else
            puts "job 4"
            fila.update(numero_fila: 4)
            next
        end
      end

    end

  end

  def self.reprocessar_fila_empresa(importacao_id, empresa_id, clientesList)
    puts 'Iniciando reprocessamento de fila'
    clientes = Array.new

    cliFila = Cliente.select('distinct clientes.*')
      .joins('inner join fila_empresas on fila_empresas.cliente_id = clientes.id', 'inner join cnaes cnae on cnae.id = clientes.cnae_id')
      .where("fila_empresas.empresa_id = ? and fila_empresas.numero_fila in (0,1,2,3,4)", empresa_id)
      .where("cnae.blacklist = false AND (clientes.data_licenca between current_date - interval '9 months' and current_date)")

    puts "cliFila: #{cliFila.count}"
    clientes.push(*cliFila) if cliFila.count > 0

    if importacao_id.present?
      cliImportacao = Cliente.select("distinct clientes.*")
        .para_ligacao
        .cnae_blacklist
        .completo
        .where(empresa_id: empresa_id, importacao_id: importacao_id)
        .joins('left join fila_empresas on fila_empresas.cliente_id = clientes.id', 'inner join cnaes cnae on cnae.id = clientes.cnae_id')
        .where('fila_empresas.id IS NULL')
        .where("cnae.blacklist = false AND (clientes.data_licenca between current_date - interval '9 months' and current_date)")
        .to_a

      puts "cliImportacao: #{cliImportacao.count}"
      clientes.push(*cliImportacao) if cliImportacao.count > 0
    end

    if clientesList.present?
      puts "clientesList: #{clientesList.count}"
      clientes.push(*clientesList) if clientesList.count > 0
    end
    puts "Clientes final: #{clientes.count}"

    FilaEmpresa.where(empresa_id: empresa_id).where('numero_fila not in (11,12,13,5)').destroy_all
    clientes_filtrados = Array.new
    clientes.each do |cli|
      if cli.present? && !cli.fila_empresa.present? && cli.status.nil? && cli.ligacoes.first.nil? && cli.campanha_envios.first.nil?
        clientes_filtrados << cli
      end
    end
    

    puts "Qtd de Clientes Filtrados: #{clientes_filtrados.count}"
    job0 = Array.new
    job1 = Array.new
    job2 = Array.new
    job3 = Array.new
    job4 = Array.new

    processar_jobs_0_1_2_3_4(clientes_filtrados, job0, job1, job2, job3, job4)
    puts "Criando fila job0: #{job0.count} job1: #{job1.count}, job2: #{job2.count}, job3: #{job3.count} job4: #{job4.count}"

    criar_fila(job0, 0, empresa_id)
    criar_fila(job1, 1, empresa_id)
    criar_fila(job2, 2, empresa_id)
    criar_fila(job3, 3, empresa_id)
    criar_fila(job4, 4, empresa_id)
  end

  def self.criar_fila(lista, numero_fila, empresa_id)
    lista.each do |cliente|
      if cliente.status.nil?
        cliente.update(status_empresa: 1)
      end

      FilaEmpresa.create(cliente_id: cliente.id, empresa_id: empresa_id, numero_fila: numero_fila)
    end
    ControleJob.recriar_controle_job_importacao lista, numero_fila, empresa_id
  end

  def self.starts_with_number?(str)
    # ^ asserts the start of the string
    # 
    # The regex searches for numbers in the "XX.YYY.ZZZ" format, 
    # where X represents 2 digits, Y represents 3 digits, and Z represents another 3 digits.
    # Ex. "54.782.321 abc" will match, "15.452.785aabc" will match, "15abc" will not match, "abasd 21.153.231" will not match
    /^\d{2}\.\d{3}\.\d{3}\s+/.match?(str)
  end

  def self.processar_jobs_0_1_2_3_4(lista, job0, job1, job2, job3, job4)
    lista.each do |cliente|
      qtd_vendas_por_cnae = get_qtd_vendas_cnae_ano(cliente.cnae_id)
      case
        # Se caso não seguir nenhum dos regex, ele não é um MEI
        # Exemplos de Clientes que não entram no job0
        # Primeiro Regex Ex: 50.048.925 NOME DO MEI, 51.443.472 NOME MEI
        # Segundo Regex Ex: NOME DO MEI 01955676445, NOME MEI 07167743488
        when !(/^\d{2}\.\d{3}\.\d{3}\s+/.match(cliente.razao_social)) && !(/\d{10}$/.match(cliente.razao_social))
          job0 << cliente
          next
        when qtd_vendas_por_cnae >= 20
          job1 << cliente
          next
        when qtd_vendas_por_cnae >= 10 && qtd_vendas_por_cnae <= 19
          job2 << cliente
          next
        when qtd_vendas_por_cnae >= 1 && qtd_vendas_por_cnae <= 9
          job3 << cliente
          next
        else
          job4 << cliente
          next
      end
    end
    [job0, job1, job2, job3, job4].each do |job|
      job.sort_by! do |cliente|
        [
          -get_qtd_vendas_cnae_ano(cliente.cnae_id),
          -cliente.data_licenca.to_time.to_i #Convertendo para timestamp
        ]
      end
    end
  end

  def self.get_qtd_vendas_cnae_ano(cnae_id)
    connection = ActiveRecord::Base.connection
    data = connection.select_one FilaEmpresasHelper.get_qtd_vendas_cnae_ano(cnae_id)
    data.present? ? data["qtd_vendas"].to_i : 0
  end

  def self.telefone_is_celular(telefone)
      return false if telefone.nil?
      telefone = telefone.gsub(/\D/, '')
      telefone = telefone[1..-1] if telefone.first(1).eql? '0'
      qtd = telefone.size

      if ((qtd.eql? 11) && ([9,8,7].include? telefone[2].to_i)) ||
          ((qtd.eql? 10) && ([9,8,7].include? telefone[2].to_i)) ||
          ((qtd.eql? 9) && ([9,8,7].include? telefone[0].to_i)) ||
          ((qtd.eql? 8) && ([9,8,7].include? telefone[0].to_i))
        return true
      end

      return false
  end

  def self.reajustar_filas
    empresas = Empresa.ativas
    empresas.each do |empresa|
      reajustar_fila_empresa(empresa.id) #PR
    end
  end

  def self.reajustar_fila_empresa(empresa_id)
    reprocessar_fila_empresa(nil, empresa_id, nil)
  end

  def self.string_is_number? string
    true if Float(string) rescue false
  end

  def self.exportar_lista_job(empresa_id, job, quantidade, abordagem_id, abordagem_texto, abordagem_tipo)
    if quantidade.present?
      filas = FilaEmpresa.where(empresa_id: empresa_id, numero_fila: job).order('id').limit(quantidade)
    else
      filas = FilaEmpresa.where(empresa_id: empresa_id, numero_fila: job).order('id')
    end

    abordagem = AbordagemInicial.where(id: abordagem_id).first
    if abordagem.present? && !(abordagem.texto.eql? abordagem_texto)
      abordagem = AbordagemInicial.create(texto: abordagem_texto,tipo: abordagem_tipo, ativa: true)
      AbordagemInicial.where(' tipo = ? and id <> ?', abordagem_tipo, abordagem.id).update_all(ativa: false)
    elsif abordagem.nil?
      abordagem = AbordagemInicial.create(texto: abordagem_texto,tipo: abordagem_tipo, ativa: true)
      AbordagemInicial.where(' tipo = ? and id <> ?', abordagem_tipo, abordagem.id).update_all(ativa: false)
    end

    attributes = ["Id","Razao Social","CNPJ", "number","body","name"]

    csv = CSV.generate(headers: true) do |csv|
      csv << attributes

      filas.each do |fila|
        cliente = fila.cliente
        telefone = (cliente.telefone.present? ? cliente.telefone : (cliente.telefone2.present? ? cliente.telefone2 : nil))
        if telefone.present?
          telefone = telefone.gsub(/\D/, '')

          if (empresa_id.to_i.eql? 2) && telefone.size < 11
            telefone = telefone[0..1] + "9" + telefone[2..-1]
          end

          telefone = "55" + telefone

          csv << [cliente.id, cliente.razao_social, cliente.cnpj,  telefone, abordagem.present? ? abordagem.texto : nil, nil]
        end
      end
    end

    filas.destroy_all

    csv
  end

  def self.contar_empresas_centro_distribuicao(estado, empresa_cnae, empresa_id)
    cliFila = Cliente.select('distinct clientes.*')
      .joins('left join cidades on clientes.cidade_id = cidades.id')
      .joins('left join estados on estados.id = cidades.estado_id')
      .cnae_blacklist
      .para_ligacao
      .completo
      .where("(clientes.data_licenca between current_date - interval '9 months' and current_date) and estados.sigla = ? and clientes.empresa_id = ? and clientes.status_empresa = 0 ", estado, empresa_id)
      .where('c.blacklist = false')
      .to_a

    job0 = Array.new
    job1 = Array.new
    job2 = Array.new
    job3 = Array.new
    job4 = Array.new

    clientes_filtrados = Array.new
    cliFila.each do |cli|
      if cli.present? && !cli.fila_empresa.present? && cli.status.nil? && cli.ligacoes.first.nil? && cli.campanha_envios.first.nil?
        clientes_filtrados << cli
      end
    end

    processar_jobs_0_1_2_3_4(clientes_filtrados, job0, job1, job2, job3, job4)

    {'estado': estado, 'total': job0.count + job1.count + job2.count + job3.count + job4.count,'job0': job0.count, 'job1': job1.count, 'job2': job2.count, 'job3': job3.count, 'job4': job4.count}
  end

end
