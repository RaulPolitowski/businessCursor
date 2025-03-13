class AddColumnsToNotificacao < ActiveRecord::Migration
  def change
    add_column :notificacoes, :visualizada, :boolean
    add_column :notificacoes, :modelo_id, :integer
  end
end
