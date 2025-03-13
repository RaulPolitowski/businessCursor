class LigacaoEmMassa::RemoverFilaEmpresa
  attr_reader :cliente_id

  def initialize(cliente_id)
    @cliente_id = cliente_id
  end

  def call
    remover_fila
  end

  def remover_fila
    FilaEmpresa.where(cliente_id: cliente_id).destroy_all
  end
end