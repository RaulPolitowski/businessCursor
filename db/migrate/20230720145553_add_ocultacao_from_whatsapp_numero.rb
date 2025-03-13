class AddOcultacaoFromWhatsappNumero < ActiveRecord::Migration
  def change
    add_column :whatsapp_numeros, :is_ocultado, :boolean, default: false
    add_column :whatsapp_numeros, :data_inicio_ocultacao, :datetime
    add_column :whatsapp_numeros, :tempo_ocultacao, :integer
  end
end
