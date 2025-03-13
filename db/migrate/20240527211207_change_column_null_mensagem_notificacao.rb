class ChangeColumnNullMensagemNotificacao < ActiveRecord::Migration
  def change
    change_column_null :mensagem_notificacoes, :destinatarios, true
  end
end
