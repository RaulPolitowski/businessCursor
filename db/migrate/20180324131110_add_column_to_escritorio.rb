class AddColumnToEscritorio < ActiveRecord::Migration
  def change
    add_column :escritorios, :passa_contato, :boolean, default: false
  end
end
