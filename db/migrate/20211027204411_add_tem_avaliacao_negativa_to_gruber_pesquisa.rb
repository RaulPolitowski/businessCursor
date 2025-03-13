class AddTemAvaliacaoNegativaToGruberPesquisa < ActiveRecord::Migration
  def change
    add_column :gruber_pesquisas, :tem_avaliacao_negativa, :boolean, default: false
  end
end
