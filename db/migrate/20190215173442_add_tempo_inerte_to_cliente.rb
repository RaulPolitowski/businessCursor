class AddTempoInerteToCliente < ActiveRecord::Migration
  def change
    add_column :clientes, :tempo_inerte, :integer
  end
end
