class AddNumeroNotificacaoToMensagemNotificacao < ActiveRecord::Migration
  def change
    add_reference :mensagem_notificacoes, :numero_notificacao, index: true, foreign_key: true
  end
end
