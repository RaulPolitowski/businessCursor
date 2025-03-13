class CreateNegociacoes < ActiveRecord::Migration
  def change
    create_table :negociacoes do |t|
      t.timestamp :data_inicio
      t.timestamp :data_fim
      t.references :user, index: true, foreign_key: true
      t.references :cliente, index: true, foreign_key: true
      t.text :obs
      t.integer :status

      t.timestamps null: false
    end
  end
end
