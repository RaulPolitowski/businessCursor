class AddTempoInerteToParametros < ActiveRecord::Migration
  def change
    add_column :parametros, :tempo_inerte, :integer
  end
end
