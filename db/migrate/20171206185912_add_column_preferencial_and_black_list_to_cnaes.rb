class AddColumnPreferencialAndBlackListToCnaes < ActiveRecord::Migration
  def change
    add_column :cnaes, :preferencial, :boolean, default: false
    add_column :cnaes, :blacklist, :boolean, default: false
  end
end
