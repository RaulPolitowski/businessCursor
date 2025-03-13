class AddTipoFechamentoToCliente < ActiveRecord::Migration
  def change
    add_reference :clientes, :tipo_fechamento, index: true, foreign_key: true
  end
end
