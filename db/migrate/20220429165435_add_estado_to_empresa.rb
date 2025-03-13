class AddEstadoToEmpresa < ActiveRecord::Migration
  def change
    add_column :empresas, :estado, :string
  end
end
