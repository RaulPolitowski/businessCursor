class RemoveIsNotificacaoToWhatsappNumero < ActiveRecord::Migration
  def change
    remove_column :whatsapp_numeros, :is_notificacao, :boolean
  end
end
