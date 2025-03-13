class AddTestePeriodoInerte < ActiveRecord::Migration
  def change
    add_column :periodo_inertes, :teste, :boolean
  end
end
