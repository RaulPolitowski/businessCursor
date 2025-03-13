class AddTitleToNotificacoes < ActiveRecord::Migration
  def change
    add_column :notificacoes, :title, :string
    add_column :notificacoes, :path, :string
  end
end
