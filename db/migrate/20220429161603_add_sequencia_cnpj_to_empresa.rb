class AddSequenciaCnpjToEmpresa < ActiveRecord::Migration
  def change
    add_column :empresas, :sequencia_cnpj, :integer
    add_column :empresas, :ativo, :boolean, default: true
  end
end
