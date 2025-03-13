class AddNotificacoesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :notificacao_agenda_cancelada, :boolean, default: false
    add_column :users, :notificacao_implantacao, :boolean, default: false
    add_column :users, :notificacao_implantacao_atraso, :boolean, default: false
  end
end
