class AddClienteToProposta < ActiveRecord::Migration
  def change
    add_reference :propostas, :cliente, index: true, foreign_key: true
  end
end
