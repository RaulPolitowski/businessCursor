class RemoveBrindeDiasTesteToProposta < ActiveRecord::Migration
  def change
    remove_column :propostas, :dias_teste, :integer
    remove_column :propostas, :com_brinde, :boolean
    remove_column :propostas, :descricao_brinde, :string
  end
end
