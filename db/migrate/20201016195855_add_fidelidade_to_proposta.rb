class AddFidelidadeToProposta < ActiveRecord::Migration
  def change
    add_column :propostas, :data_primeira_mensalidade, :date
    add_column :propostas, :fidelidade, :boolean
    add_column :propostas, :meses_fidelidade, :integer
  end
end
