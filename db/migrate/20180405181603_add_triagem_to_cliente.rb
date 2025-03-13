class AddTriagemToCliente < ActiveRecord::Migration
  def change
    add_column :clientes, :triagem, :boolean, default: false
  end
end
