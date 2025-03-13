class AddSistemaToContratos < ActiveRecord::Migration
  def change
    add_column :contratos, :sistema_id, :integer
  end
end
