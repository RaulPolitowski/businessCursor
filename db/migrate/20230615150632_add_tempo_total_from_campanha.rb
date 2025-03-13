class AddTempoTotalFromCampanha < ActiveRecord::Migration
  def change
    add_column :campanhas, :tempo_total, :integer
    add_column :campanhas, :tipo_disparo, :integer
  end
end
