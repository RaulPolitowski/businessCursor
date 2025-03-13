class AddColumnsToEscritorios < ActiveRecord::Migration
  def change
    add_column :escritorios, :motivo_sem_interesse, :string
    add_column :escritorios, :parceria_obs, :string
  end
end
