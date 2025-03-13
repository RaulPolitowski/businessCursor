class AddMessageFromCampanhaEnvios < ActiveRecord::Migration
  def change
    add_column :campanha_envios, :message, :string
  end
end
