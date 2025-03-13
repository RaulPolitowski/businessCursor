class AddNumeroFilaToCliente < ActiveRecord::Migration
  def change
    add_column :clientes, :numero_fila, :integer
  end
end
