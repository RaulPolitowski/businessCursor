class AddAtivoToGzapUsuario < ActiveRecord::Migration
  def change
    add_column :gzap_usuarios, :ativo, :boolean, default: true
  end
end
