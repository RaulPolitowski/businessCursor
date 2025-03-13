class CreatePerguntaClienteRespostas < ActiveRecord::Migration
  def change
    create_table :pergunta_cliente_respostas do |t|
      t.references :pergunta, index: true, foreign_key: true
      t.references :cliente, index: true, foreign_key: true
      t.text :resposta
      t.integer :tipo

      t.timestamps null: false
    end
  end
end
