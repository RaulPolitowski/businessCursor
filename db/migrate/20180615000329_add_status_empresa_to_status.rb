class AddStatusEmpresaToStatus < ActiveRecord::Migration
  def change
    add_column :status, :status_empresa, :integer
  end
end
