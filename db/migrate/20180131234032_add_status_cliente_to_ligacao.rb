class AddStatusClienteToLigacao < ActiveRecord::Migration
  def change
    add_column :ligacoes, :status_cliente_id, :integer
  end
end
