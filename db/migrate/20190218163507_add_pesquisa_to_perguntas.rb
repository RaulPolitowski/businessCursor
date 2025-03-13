class AddPesquisaToPerguntas < ActiveRecord::Migration
  def change
    add_column :perguntas, :pesquisa, :boolean
  end
end
