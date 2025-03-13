class AddDataFechamentoAndUserNegociacaoToClientes < ActiveRecord::Migration
  def change
    add_column :clientes, :data_fechamento, :timestamp
    add_column :clientes, :user_negociacao_id, :integer
  end
end
