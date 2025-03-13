class CreatePerguntas < ActiveRecord::Migration
  def change
    create_table :perguntas do |t|
      t.text :pergunta
      t.boolean :fechamento
      t.boolean :implantacao
      t.boolean :acompanhamento

      t.timestamps null: false
    end
  end
end
