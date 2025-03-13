class RemoveWhatsappNumeroToMensagemNotificacao < ActiveRecord::Migration
  def change
    remove_reference :mensagem_notificacoes, :whatsapp_numero, index: true, foreign_key: true
  end
end
