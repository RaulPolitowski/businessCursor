class AddRejeitadoRfToClientes < ActiveRecord::Migration
  def change
    add_column :clientes, :rejeitado_rf, :boolean, default: false
  end
end
