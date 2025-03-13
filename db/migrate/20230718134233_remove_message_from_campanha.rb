class RemoveMessageFromCampanha < ActiveRecord::Migration
  def change
    remove_column :campanhas, :message, :string
  end
end
