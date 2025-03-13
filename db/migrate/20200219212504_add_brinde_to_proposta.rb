class AddBrindeToProposta < ActiveRecord::Migration
  def change
    add_column :propostas, :com_brinde, :boolean, default: false
    add_column :propostas, :descricao_brinde, :string
  end
end
