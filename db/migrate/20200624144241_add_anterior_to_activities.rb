class AddAnteriorToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :anterior, :boolean, default: false
  end
end
