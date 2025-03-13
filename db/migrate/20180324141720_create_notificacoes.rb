class CreateNotificacoes < ActiveRecord::Migration
  def change
    create_table :notificacoes do |t|
      t.references :user, index: true, foreign_key: true
      t.integer :user_registro_id
      t.datetime :data_hora
      t.references :empresa, index: true, foreign_key: true
      t.string :observacao
      t.string :tipo
      t.boolean :lido

      t.timestamps null: false
    end
  end
end
