class CreateEscritorios < ActiveRecord::Migration
  def change
    create_table :escritorios do |t|
      t.string :razao_social
      t.string :nome_fantasia
      t.string :telefone
      t.string :responsavel
      t.boolean :possui_parceria
      t.string :empresa_parceria
      t.string :observacao

      t.timestamps null: false
    end
  end
end
