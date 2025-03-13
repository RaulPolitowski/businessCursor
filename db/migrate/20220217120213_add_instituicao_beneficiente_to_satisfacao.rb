class AddInstituicaoBeneficienteToSatisfacao < ActiveRecord::Migration
  def change
    add_column :gruber_pesquisas, :instituicao_beneficiente, :string
  end
end
