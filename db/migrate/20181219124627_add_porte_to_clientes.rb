class AddPorteToClientes < ActiveRecord::Migration
  def change
    add_column :clientes, :porte, :varchar
  end
end
