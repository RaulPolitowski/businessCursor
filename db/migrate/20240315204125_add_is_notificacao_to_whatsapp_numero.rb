class AddIsNotificacaoToWhatsappNumero < ActiveRecord::Migration
  def change
    add_column :whatsapp_numeros, :is_notificacao, :boolean, default: false
  end
end
