class AddEmpresaToStatus < ActiveRecord::Migration
  def change
    add_reference :status, :empresa, index: true, foreign_key: true
  end
end
