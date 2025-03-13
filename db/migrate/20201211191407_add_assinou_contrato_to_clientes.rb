class AddAssinouContratoToClientes < ActiveRecord::Migration
  def change
    add_column :clientes, :assinou_contrato, :boolean, default: false
  end
end
