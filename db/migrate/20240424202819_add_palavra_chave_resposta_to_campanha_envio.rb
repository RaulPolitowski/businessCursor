class AddPalavraChaveRespostaToCampanhaEnvio < ActiveRecord::Migration
  def change
    add_column :campanha_envios, :palavra_chave_resposta, :text
  end
end
