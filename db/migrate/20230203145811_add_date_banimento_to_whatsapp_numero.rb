class AddDateBanimentoToWhatsappNumero < ActiveRecord::Migration
  def change
    add_column :whatsapp_numeros, :data_banimento, :datetime
  end
end
