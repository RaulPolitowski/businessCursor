class AddTokenChatProFromWhatsappNumero < ActiveRecord::Migration
  def change
    add_column :whatsapp_numeros, :tokenChatPro, :string
  end
end
