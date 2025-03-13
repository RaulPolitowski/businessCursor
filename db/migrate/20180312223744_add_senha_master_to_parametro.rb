class AddSenhaMasterToParametro < ActiveRecord::Migration
  def change
    add_column :parametros, :senha_master, :string
  end
end
