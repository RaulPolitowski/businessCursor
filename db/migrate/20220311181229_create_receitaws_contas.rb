class CreateReceitawsContas < ActiveRecord::Migration
  def change
    create_table :receitaws_contas do |t|
      t.string :nome
      t.string :chave
      t.integer :qtd_disponivel
      t.integer :qtd_usada
      t.date :dia_renovacao

      t.timestamps null: false
    end
  end
end
