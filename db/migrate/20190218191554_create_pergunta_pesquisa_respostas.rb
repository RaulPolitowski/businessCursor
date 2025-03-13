class CreatePerguntaPesquisaRespostas < ActiveRecord::Migration
  def change
    create_table :pergunta_pesquisa_respostas do |t|
      t.references :pergunta, index: true, foreign_key: true
      t.references :pesquisa, index: true, foreign_key: true
      t.text :resposta

      t.timestamps null: false
    end
  end
end
