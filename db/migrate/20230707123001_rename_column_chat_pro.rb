class RenameColumnChatPro < ActiveRecord::Migration
  def change
    rename_column :whatsapp_numeros, :isChatPro, :chat_pro
    rename_column :whatsapp_numeros, :instanciaId, :instancia_id
    rename_column :whatsapp_numeros, :tokenChatPro, :token_chat_pro
  end
end
