class AddStatusEmpresaToCliente < ActiveRecord::Migration
  def change
    add_column :clientes, :status_empresa, :integer
  end
end
