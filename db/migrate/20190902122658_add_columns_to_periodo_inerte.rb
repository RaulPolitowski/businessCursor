class AddColumnsToPeriodoInerte < ActiveRecord::Migration
  def change
    add_column :periodo_inertes, :sistema, :string
    add_column :periodo_inertes, :nova, :boolean
    add_column :periodo_inertes, :versao, :string
  end
end
