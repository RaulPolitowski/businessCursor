class AddRespostaAutomaticaFromCampanhaEnvio < ActiveRecord::Migration
  def change
    add_column :campanha_envios, :resposta_automatica_message, :string
    add_column :campanha_envios, :intervalo_resposta_automatica, :integer
  end
end
