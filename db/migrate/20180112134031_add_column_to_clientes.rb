class AddColumnToClientes < ActiveRecord::Migration
  def change
    add_column :clientes, :ativo, :boolean, default: true
  end
end
