class AddIntervaloRespostaFromAbordagemInicial < ActiveRecord::Migration
  def change
    add_column :abordagem_iniciais, :resposta_automatica, :string
    add_column :abordagem_iniciais, :intervalo_resposta_automatica, :string
  end
end
