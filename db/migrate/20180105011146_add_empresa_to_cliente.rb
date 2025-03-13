class AddEmpresaToCliente < ActiveRecord::Migration
  def change
    add_reference :clientes, :empresa, index: true, foreign_key: true
  end
end
