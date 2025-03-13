class AddBloqueadoToInertes < ActiveRecord::Migration
  def change
    add_column :periodo_inertes, :bloqueado, :boolean, default: false
  end
end
