class CreateContatos < ActiveRecord::Migration
  def change
    create_table :contatos do |t|
      t.string :nome
      t.string :telefone
      t.string :email
      t.string :funcao
      t.references :cliente, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
