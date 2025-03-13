class RemoveFieldsClientes < ActiveRecord::Migration
  def change
    remove_column :clientes, :contato, :string
    remove_column :clientes, :contato_telefone, :string
    remove_column :clientes, :contato_email, :string
  end
end
