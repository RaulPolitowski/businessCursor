class CreateClientes < ActiveRecord::Migration
  def change
    create_table :clientes do |t|
      t.string :cnpj
      t.string :inscricao_estadual
      t.date :data_importacao
      t.date :data_licenca
      t.string :situacao
      t.string :nire
      t.string :razao_social
      t.string :endereco
      t.string :numero_endereco
      t.string :complemento
      t.string :cep
      t.string :bairro
      t.string :email
      t.string :telefone
      t.string :telefone2
      t.string :observacao
      t.string :contato
      t.string :contato_telefone
      t.string :contato_email
      t.references :cidade, index: true, foreign_key: true
      t.references :cnae, index: true, foreign_key: true
      t.references :importacao, index: true, foreign_key: true
      t.references :escritorio, index: true, foreign_key: true
      
      t.timestamps null: false
    end
  end
  remove_index :cnpj, unique: false
end
