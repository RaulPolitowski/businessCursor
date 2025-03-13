class AddStatusToCliente < ActiveRecord::Migration
  def change
    add_reference :clientes, :status, index: true, foreign_key: true
  end
end
