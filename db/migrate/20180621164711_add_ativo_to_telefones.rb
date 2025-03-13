class AddAtivoToTelefones < ActiveRecord::Migration
  def change
    add_column :telefones, :ativo, :boolean, default: true
  end
end
