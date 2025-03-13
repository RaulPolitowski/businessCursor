class AddConferidoToAcompanhamentos < ActiveRecord::Migration
  def change
    add_column :acompanhamentos, :conferido, :boolean, default: false
    add_column :acompanhamentos, :baixado, :boolean, default: false
  end
end
