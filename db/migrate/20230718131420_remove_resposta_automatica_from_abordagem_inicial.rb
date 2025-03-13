class RemoveRespostaAutomaticaFromAbordagemInicial < ActiveRecord::Migration
  def change
    remove_column :abordagem_iniciais, :resposta_automatica, :string
  end
end
