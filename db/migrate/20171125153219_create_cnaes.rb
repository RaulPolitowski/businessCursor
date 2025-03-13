class CreateCnaes < ActiveRecord::Migration
  def change
    create_table :cnaes do |t|
      t.string :codigo
      t.string :descricao

      t.timestamps null: false
    end
  end
end
