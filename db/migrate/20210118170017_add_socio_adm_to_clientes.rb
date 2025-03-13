class AddSocioAdmToClientes < ActiveRecord::Migration
  def change
    add_column :clientes, :socio_admin, :string
  end
end
