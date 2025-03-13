class AddOcupadoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :ocupado, :boolean, default: false
  end
end
