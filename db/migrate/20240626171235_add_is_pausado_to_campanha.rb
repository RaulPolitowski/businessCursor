class AddIsPausadoToCampanha < ActiveRecord::Migration
  def change
    add_column :campanhas, :is_pausada, :boolean, default: false
  end
end
