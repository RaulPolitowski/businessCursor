class AddColumntoAbordagemInicial < ActiveRecord::Migration
  def change
    add_column :abordagem_iniciais, :tipo, :string
  end
end
