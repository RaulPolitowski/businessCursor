class CreateEmpresas < ActiveRecord::Migration
  def change
    create_table :empresas do |t|
      t.string :cnpj
      t.string :razao_social
      t.string :nome_fantasia
      t.references :cidade, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
