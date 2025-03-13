class CreateAcompanhamentos < ActiveRecord::Migration
  def change
    create_table :acompanhamentos do |t|
      t.timestamp :data_inicio
      t.timestamp :data_fim
      t.references :cliente, index: true, foreign_key: true
      t.references :empresa, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.integer :status
      t.references :proposta, index: true, foreign_key: true
      t.boolean :pausada
      t.text :observacao

      t.timestamps null: false
    end
  end
end
