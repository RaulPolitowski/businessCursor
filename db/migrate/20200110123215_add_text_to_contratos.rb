class AddTextToContratos < ActiveRecord::Migration
  def change
    add_column :contratos, :texto, :text
  end
end
