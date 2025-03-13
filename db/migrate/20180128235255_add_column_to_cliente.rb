class AddColumnToCliente < ActiveRecord::Migration
  def change
    add_column :clientes, :user_retorno_id, :integer
  end
end
