class AddDiasTesteToProposta < ActiveRecord::Migration
  def change
    add_column :propostas, :dias_teste, :int
  end
end
