class CreatePerguntaRespostaClienteTags < ActiveRecord::Migration
  def change
    create_table :pergunta_cliente_resposta_tags do |t|
      t.references :pergunta_cliente_resposta, foreign_key: true
      t.string :tag

      t.timestamps null: false
    end
  end
end
