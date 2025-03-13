class AddFieldsToGruberPesquisaRespostas < ActiveRecord::Migration
  def change
    add_column :gruber_pesquisa_respostas, :setor_financeiro_id, :integer
    add_column :gruber_pesquisa_respostas, :setor_financeiro_nome, :string
  end
end
