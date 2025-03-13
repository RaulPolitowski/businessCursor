class AddColunsToPerguntas < ActiveRecord::Migration
  def change
    add_column :perguntas, :confirmacao, :boolean
    add_column :perguntas, :pergunta_gatilho_id, :int
  end
end
