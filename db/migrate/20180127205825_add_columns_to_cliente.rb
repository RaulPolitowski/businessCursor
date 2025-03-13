class AddColumnsToCliente < ActiveRecord::Migration
  def change
    add_column :clientes, :em_atendimento, :boolean, default: false
    add_column :clientes, :user_atendimento_id, :integer
  end
end
