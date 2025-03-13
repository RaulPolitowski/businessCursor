class CreateLigacoes < ActiveRecord::Migration
  def change
    create_table :ligacoes do |t|
      t.datetime :data_inicio
      t.datetime :data_fim
      t.references :user, index: true, foreign_key: true
      t.string :observacao

      t.timestamps null: false
    end
  end
end
