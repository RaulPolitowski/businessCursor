class LigacaoEmMassa::BuscarFilaPrincipal
  attr_reader :empresa_id, :job, :qtd, :cnaes
  def initialize(params)
    @empresa_id = params['empresa']
    @job = params['job']
    @qtd = params['quantidade']
    @cnaes = params['cnae'].any?(&:blank?) && params['cnae'].size == 1 ? Cnae.permitidos.ids : params['cnae']
  end

  def call
    search_main_queue
  end

  private

  def search_main_queue
    queue = FilaEmpresa.ordem_cliente.where(
      empresa_id: empresa_id,
      numero_fila: job
    ).find_by_cnaes(
      cnaes.empty? ? Cnae.permitidos.ids : cnaes
    )
    .order(:numero_fila)
    .limit(qtd)
    queue = queue.first if qtd == 1

    queue
  end
end