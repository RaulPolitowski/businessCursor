class AddTempoInerteToSistemas < ActiveRecord::Migration
  def change
    add_column :sistemas, :tempo_inerte, :integer
  end
end
