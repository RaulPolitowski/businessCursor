class CreateImportacoes < ActiveRecord::Migration
  def change
    create_table :importacoes do |t|
      t.date :data_importacao
      t.integer :total
      t.integer :importado
      t.integer :nao_importado
      t.integer :ja_existente
      t.references :user, index: true, foreign_key: true
      t.references :estado, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
