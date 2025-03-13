class AddCampusToservicos < ActiveRecord::Migration
  def change
    add_column :servicos, :ativo, :boolean, Default:false
    add_column :servicos, :ordem, :integer
  end
end
