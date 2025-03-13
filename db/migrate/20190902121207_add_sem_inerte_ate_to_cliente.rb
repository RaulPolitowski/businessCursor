class AddSemInerteAteToCliente < ActiveRecord::Migration
  def change
    add_column :clientes, :sem_inerte_ate, :date
  end
end
