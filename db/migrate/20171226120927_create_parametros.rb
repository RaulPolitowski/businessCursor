class CreateParametros < ActiveRecord::Migration
  def change
    create_table :parametros do |t|
      t.string :tipo_telefone_preferencial
      t.boolean :cidades_preferenciais
      t.boolean :cnaes_preferenciais
      t.boolean :data_habilitacao_preferencial
      t.boolean :telefone_preferencial

      t.timestamps null: false
    end
  end
end
