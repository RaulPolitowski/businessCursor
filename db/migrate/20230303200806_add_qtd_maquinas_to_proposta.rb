class AddQtdMaquinasToProposta < ActiveRecord::Migration
  def change
    add_column :propostas, :qtd_maquinas, :integer
  end
end
