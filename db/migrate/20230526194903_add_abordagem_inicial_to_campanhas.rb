class AddAbordagemInicialToCampanhas < ActiveRecord::Migration
  def change
    add_reference :campanhas, :abordagem_inicial, index: true, foreign_key: true
  end
end
