class AddReconsultadoToClientes < ActiveRecord::Migration
  def change
    add_column :clientes, :reconsultado, :boolean, default: false
  end
end
