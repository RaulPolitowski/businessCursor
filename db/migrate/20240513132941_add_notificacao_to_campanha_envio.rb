class AddNotificacaoToCampanhaEnvio < ActiveRecord::Migration
  def change
    add_column :campanha_envios, :mensagem_notificacao, :string
    add_column :campanha_envios, :destinatarios_notificacao, :string, array: true, null: true
  end
end
