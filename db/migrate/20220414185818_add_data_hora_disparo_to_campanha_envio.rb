class AddDataHoraDisparoToCampanhaEnvio < ActiveRecord::Migration
  def change
    add_column :campanha_envios, :data_hora_disparo, :timestamp
  end
end
