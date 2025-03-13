class AddBanidoToWhatsappNumeros < ActiveRecord::Migration
  def change
    add_column :whatsapp_numeros, :banido, :boolean, default: false
  end
end
