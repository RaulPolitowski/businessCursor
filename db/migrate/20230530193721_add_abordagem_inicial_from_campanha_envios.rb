class AddAbordagemInicialFromCampanhaEnvios < ActiveRecord::Migration
  def change
    add_reference :campanha_envios, :abordagem_inicial, index: true, foreign_key: true
  end
end
