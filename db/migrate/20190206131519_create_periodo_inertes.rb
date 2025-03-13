class CreatePeriodoInertes < ActiveRecord::Migration
  def change
    create_table :periodo_inertes do |t|
      t.references :cliente, index: true, foreign_key: true
      t.references :empresa, index: true, foreign_key: true
      t.date :data
      t.string :feedback
      t.string :avaliacao
      t.string :positivo

      t.timestamps null: false
    end
  end
end
