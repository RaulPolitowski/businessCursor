class AddTipoStatusToStatus < ActiveRecord::Migration
  def change
    add_column :status, :tipo_status, :integer, default: 1
    add_column :status, :descartada, :boolean
  end
end
