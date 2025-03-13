class AddEmpresaToProposta < ActiveRecord::Migration
  def change
    add_reference :propostas, :empresa, index: true, foreign_key: true
    add_reference :propostas, :user, index: true, foreign_key: true
  end
end
