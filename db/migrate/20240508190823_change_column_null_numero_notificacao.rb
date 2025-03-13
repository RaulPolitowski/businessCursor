class ChangeColumnNullNumeroNotificacao < ActiveRecord::Migration
  def change
    change_column_null :mensagem_notificacoes, :numero_notificacao_id, true
  end
end
