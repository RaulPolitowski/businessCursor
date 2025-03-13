class AddLojaItemToWhatsappNumero < ActiveRecord::Migration
  def change
    add_reference :whatsapp_numeros, :loja_item, index: true, foreign_key: true
  end
end
