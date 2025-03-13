class AddFieldTempoEsperaToCampanha < ActiveRecord::Migration
  def change
    add_column :campanhas, :tempo_espera, :integer
  end
end
