class CreateGruberPesquisas < ActiveRecord::Migration
  def change
    create_table :gruber_pesquisas do |t|
      t.integer :cliente_id
      t.string :cliente_nome
      t.string :cliente_telefone
      t.string :cliente_email

      t.timestamps null: false
    end
  end
end
