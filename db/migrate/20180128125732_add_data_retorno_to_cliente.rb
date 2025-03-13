class AddDataRetornoToCliente < ActiveRecord::Migration
  def change
    add_column :clientes, :data_retorno, :date
  end
end
