class CreateContratos < ActiveRecord::Migration
  def change
    create_table :contratos do |t|
      t.text :nome
      t.text :descricao

      t.timestamps null: false
    end
  end
end
