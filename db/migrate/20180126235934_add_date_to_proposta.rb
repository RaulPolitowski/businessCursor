class AddDateToProposta < ActiveRecord::Migration
  def change
    add_column :propostas, :data, :date
  end
end
