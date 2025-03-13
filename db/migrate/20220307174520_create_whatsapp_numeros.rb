class CreateWhatsappNumeros < ActiveRecord::Migration
  def change
    create_table :whatsapp_numeros do |t|
      t.string :numero
      t.string :status
      t.references :campanha, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
