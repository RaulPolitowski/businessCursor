class AddNomeFantasiaToCliente < ActiveRecord::Migration
  def change
    add_column :clientes, :nome_fantasia, :string
  end
end
