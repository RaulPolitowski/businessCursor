class CreatePesquisas < ActiveRecord::Migration
  def change
    create_table :pesquisas do |t|
      t.date :data
      t.references :cliente, index: true, foreign_key: true
      t.references :empresa, index: true, foreign_key: true
      t.string :avaliacao
      t.boolean :positivo
      t.integer :user_avaliacao_id
      t.timestamp :data_avaliacao
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
