class CreateHistoricos < ActiveRecord::Migration
  def change
    create_table :historicos do |t|
      t.date :data
      t.references :user, index: true, foreign_key: true
      t.string :observacao
      t.references :escritorio, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
