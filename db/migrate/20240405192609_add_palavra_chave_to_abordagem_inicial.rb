class AddPalavraChaveToAbordagemInicial < ActiveRecord::Migration
  def change
    add_column :abordagem_iniciais, :palavra_chave_validacao, :text
  end
end
