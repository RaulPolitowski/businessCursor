class AddRespostaAutomaticaFromCampanha < ActiveRecord::Migration
  def change
    add_column :campanhas, :is_resposta_automatica, :boolean
  end
end
