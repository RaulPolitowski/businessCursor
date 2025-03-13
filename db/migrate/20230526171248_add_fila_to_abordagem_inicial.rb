class AddFilaToAbordagemInicial < ActiveRecord::Migration
  def change
    add_column :abordagem_iniciais, :fila, :integer
  end
end
