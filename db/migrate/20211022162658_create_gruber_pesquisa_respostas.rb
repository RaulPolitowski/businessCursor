class CreateGruberPesquisaRespostas < ActiveRecord::Migration
  def change
    create_table :gruber_pesquisa_respostas do |t|
      t.references :servico, index: true, foreign_key: true
      t.references :setor, index: true, foreign_key: true
      t.references :gruber_pesquisa, index: true, foreign_key: true
      t.integer :nota
      t.string :motivo

      t.timestamps null: false
    end
  end
end
