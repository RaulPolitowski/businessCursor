class CreateFormasPagamento < ActiveRecord::Migration
  def change
    create_table :formas_pagamento do |t|
      t.string :descricao
      t.boolean :parcelado

      t.timestamps null: false
    end
  end
end
