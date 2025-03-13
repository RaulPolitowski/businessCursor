class AddQtdRetryRfFromCliente < ActiveRecord::Migration
  def change
    add_column :clientes, :qtd_reconsultas_rf, :integer, default: 3
  end
end
