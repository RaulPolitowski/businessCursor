class DistribuirFilaCentroDistribuicao

  attr_reader :empresa_id, :estado_id

  def initialize(empresa_id: nil, estado_id: nil)
    @empresa_id = empresa_id
    @estado_id = estado_id
  end

  def call
    if empresa_id.present?
      estados = Estado.where(id: estado_id)
      return gerar(estados, empresa_id)
    end
    estados = Estado.estados_demais_e_preferidos
    gerar(estados, nil)
  end

  def self.contar_qtd_clientes_novos(job)
    fila_atual = ControleJob.where(job: job).where("DATE(data_controle) = ?", DateTime.now.to_date).sum(:quantidade)
    fila_dia_anterior = ControleJob.where(job: job).where("DATE(data_controle) = ?", 1.day.ago).sum(:restante)
    fila_atual - fila_dia_anterior
  end

  def self.criar_notificacao_centro_distribuicao
    jobs = (0..2).map { |job| contar_qtd_clientes_novos(job) }
    total = jobs.sum
    Notificacao.criar_notificacao_centro_distribuicao(*jobs, total)
  end

  def gerar(estados, empresa_id)
    estados.each_with_index do |estado, index|
      GerarFilaEmpresaCentro.perform_async(estado.id, empresa_id)
      sleep 30
    end
    criar_notificacao_centro_distribuicao
  end

end