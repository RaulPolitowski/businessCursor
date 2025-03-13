class AddChatProFromWhatsappNumero < ActiveRecord::Migration
  def change
    add_column :whatsapp_numeros, :isChatPro, :boolean
    add_column :whatsapp_numeros, :instanciaId, :string
  end
end
