class AddUserToWhatsappNumero < ActiveRecord::Migration
  def change
    add_reference :whatsapp_numeros, :user, index: true, foreign_key: true
  end
end
