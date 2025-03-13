class AddColunsToCidade < ActiveRecord::Migration
  def change
    add_column :cidades, :blacklist, :boolean
    add_column :cidades, :preferencial, :boolean
  end
end
