class AddAtivoToContratos < ActiveRecord::Migration
  def change
    add_column :contratos, :ativo, :boolean, default: true
  end
end
