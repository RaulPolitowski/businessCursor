class CreateNumeroNotificacoes < ActiveRecord::Migration
  def change
    create_table :numero_notificacoes do |t|
      t.string :numero, null: false
      t.string :nome
      t.boolean :banido, default: false
      t.string :qrcode
      t.string :status, default: 'DESCONECTADO'

      t.timestamps null: false
    end
  end
end
