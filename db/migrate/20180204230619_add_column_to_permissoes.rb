class AddColumnToPermissoes < ActiveRecord::Migration
  def change
    add_column :permissoes, :agenda, :boolean, default: true
  end
end
