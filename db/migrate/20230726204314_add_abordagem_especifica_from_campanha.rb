class AddAbordagemEspecificaFromCampanha < ActiveRecord::Migration
  def change
    add_column :campanhas, :is_abordagem_inicial_especifica, :boolean
    add_column :campanhas, :is_abordagem_resposta_especifica, :boolean
  end
end
