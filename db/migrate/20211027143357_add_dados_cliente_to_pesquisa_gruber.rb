class AddDadosClienteToPesquisaGruber < ActiveRecord::Migration
  def change
    add_column :gruber_pesquisas, :cliente_razao_social, :string
    add_column :gruber_pesquisas, :cliente_cpf_cnpj, :string
  end
end
