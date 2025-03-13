class RemoveAbordagemInicialFromCampanhas < ActiveRecord::Migration
  def change
    remove_reference :campanhas, :abordagem_inicial, index: true, foreign_key: true
  end
end
