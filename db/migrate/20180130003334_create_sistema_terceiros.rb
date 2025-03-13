class CreateSistemaTerceiros < ActiveRecord::Migration
  def change
    create_table :sistema_terceiros do |t|
      t.string :nome
      t.string :empresa
      t.decimal :mensalidade
      t.string :observacao
      t.references :cliente, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
