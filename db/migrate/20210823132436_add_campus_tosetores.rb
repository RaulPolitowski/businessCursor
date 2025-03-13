class AddCampusTosetores < ActiveRecord::Migration
  def change
    add_column :setores, :ativo, :boolean, Default:false
    add_column :setores, :ordem, :integer
  end
end
