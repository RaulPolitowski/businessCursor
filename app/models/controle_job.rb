class ControleJob < ActiveRecord::Base
  belongs_to :importacao
  belongs_to :empresa

  def self.recriar_controle_job_importacao(clientes, job, empresa_id)
    controle = ControleJob.where(data_controle: Time.now.to_date, job: job, empresa_id: empresa_id).first

    controle = ControleJob.create(quantidade: 0, data_controle: Time.now.to_date, job: job, empresa_id: empresa_id) if controle.nil?

    if controle.present?
      controle.update(quantidade: clientes.count)

      ControleJobCliente.where(controle_job_id: controle.id).destroy_all

      clientes.each do |cliente|
        ControleJobCliente.create(cliente_id: cliente.id, controle_job_id: controle.id)
      end
    end
  end

  def self.atualizar_controle_job_importacao(clientes, job, empresa_id)
    controle = ControleJob.where(data_controle: Time.now.to_date, job: job, empresa_id: empresa_id).first

    controle = ControleJob.create(quantidade: 0, data_controle: Time.now.to_date, job: job, empresa_id: empresa_id) if controle.nil?

    if controle.present?
      controle.update(quantidade: controle.quantidade + clientes.count)

      clientes.each do |cliente|
        ControleJobCliente.create(cliente_id: cliente.id, controle_job_id: controle.id)
      end
    end
  end


  def self.criar_controle_job_inicio(empresa_id, job_id, fila)
    controle = ControleJob.where(data_controle: Time.now.to_date, job: job_id, empresa_id: empresa_id).first

    if controle.nil?
      controle = ControleJob.create(empresa_id: empresa_id, data_controle: Time.now.to_date, job: job_id, quantidade: fila.count)

      fila.each do |fi|
        ControleJobCliente.create(cliente_id: fi.cliente_id, controle_job_id: controle.id)
      end
    end
  end

  def self.registrar_fim_controle
    empresas = Empresa.ativas
    empresas.each do |empresa|
      atualizar_controle_job_fim(empresa.id, 0,  FilaEmpresa.where(empresa_id: empresa.id, numero_fila: 0))
      atualizar_controle_job_fim(empresa.id, 1,  FilaEmpresa.where(empresa_id: empresa.id, numero_fila: 1))
      atualizar_controle_job_fim(empresa.id, 2,  FilaEmpresa.where(empresa_id: empresa.id, numero_fila: 2))
      atualizar_controle_job_fim(empresa.id, 3,  FilaEmpresa.where(empresa_id: empresa.id, numero_fila: 3))
      atualizar_controle_job_fim(empresa.id, 4,  FilaEmpresa.where(empresa_id: empresa.id, numero_fila: 4))
    end
  end

  def self.atualizar_controle_job_fim(empresa_id, job, fila)
    controleJob = ControleJob.where(data_controle: Time.now.to_date, job: job, empresa_id: empresa_id).first
    if controleJob.present?
      controleJob.update(restante: fila.count)

      fila.each do |fi|
        ControleJobClienteRestante.create(cliente_id: fi.cliente_id, controle_job_id: controleJob.id)
      end
    end
  end

  def self.corrigir_controle_jobs(empresa_id, dia)
    clientes = Array.new
    clientes += get_clientes_controle_job(empresa_id, dia, 0)
    clientes += get_clientes_controle_job(empresa_id, dia, 1)
    clientes += get_clientes_controle_job(empresa_id, dia, 2)
    clientes += get_clientes_controle_job(empresa_id, dia, 3)
    FilaEmpresa.reprocessar_fila_empresa(nil, empresa_id, clientes)
  end

  def self.get_clientes_controle_job(empresa_id, dia, job)
    controle = ControleJob.where(data_controle: dia, job: job, empresa_id: empresa_id).first
    controle_clientes = ControleJobCliente.where(controle_job_id: controle.id)

    clientes = Array.new
    controle_clientes.each do |controle|
      cliente = controle.cliente

      next if cliente.nil? || cliente.fila_empresa.present? || cliente.status_empresa > 1 || cliente.status.present? || cliente.ligacoes.first.present? || cliente.campanha_envios.first.present?

      clientes << cliente
    end

    clientes
  end

  def self.recalcular_controle
    empresas = Empresa.ativas
    empresas.each do |empresa|
      recalcular_controle_job(empresa.id, 0,  FilaEmpresa.where(empresa_id: empresa.id, numero_fila: 0))
      recalcular_controle_job(empresa.id, 1,  FilaEmpresa.where(empresa_id: empresa.id, numero_fila: 1))
      recalcular_controle_job(empresa.id, 2,  FilaEmpresa.where(empresa_id: empresa.id, numero_fila: 2))
      recalcular_controle_job(empresa.id, 3,  FilaEmpresa.where(empresa_id: empresa.id, numero_fila: 3))
      recalcular_controle_job(empresa.id, 4,  FilaEmpresa.where(empresa_id: empresa.id, numero_fila: 4))
    end
  end

  def self.recalcular_controle_job(empresa_id, job, fila)
    puts "recalcular controle job #{job} empresa: #{empresa_id}"
    controleJob = ControleJob.where(data_controle: Time.now.to_date, job: job, empresa_id: empresa_id).first
    if controleJob.present?
      controleJob.update(quantidade: fila.count, restante: fila.count)

      fila.each do |fi|
        ControleJobCliente.create(cliente_id: fi.cliente_id, controle_job_id: controleJob.id)
        ControleJobClienteRestante.create(cliente_id: fi.cliente_id, controle_job_id: controleJob.id)
      end
    end
  end

  def self.remover_controle
    empresas = Empresa.ativas
    empresas.each do |empresa|
      remover_controle_job(empresa.id, 0,  FilaEmpresa.where(empresa_id: empresa.id, numero_fila: 0))
      remover_controle_job(empresa.id, 1,  FilaEmpresa.where(empresa_id: empresa.id, numero_fila: 1))
      remover_controle_job(empresa.id, 2,  FilaEmpresa.where(empresa_id: empresa.id, numero_fila: 2))
      remover_controle_job(empresa.id, 3,  FilaEmpresa.where(empresa_id: empresa.id, numero_fila: 3))
      remover_controle_job(empresa.id, 4,  FilaEmpresa.where(empresa_id: empresa.id, numero_fila: 4))
    end
  end

  def self.remover_controle_job(empresa_id, job, fila)
    puts "Remover controle job #{job} empresa: #{empresa_id}"
    controle_jobs = ControleJob.where("created_at > ? AND job = ? AND empresa_id = ?", 1.day.ago, job, empresa_id).first
    if controle_jobs.present?
      controleJob.update!(quantidade: fila.count, restante: fila.count)

      fila.each do |fi|
        controle_job_cliente = ControleJobCliente.where(cliente_id: fi.cliente_id, controle_job_id: controle_jobs.id).destroy_all
        controle_job_cliente_restante = ControleJobClienteRestante.where(cliente_id: fi.cliente_id, controle_job_id: controle_jobs.id).destroy_all
      end
    end
  end
end
