class CreateMensagemNotificacoes < ActiveRecord::Migration
  def change
    create_table :mensagem_notificacoes do |t|
      t.string :destinatarios, array: true, null: false
      t.references :whatsapp_numero, index: true, foreign_key: true
      t.string :mensagem, null: false
      t.string :tipo

      t.timestamps null: false
    end
  end
end
