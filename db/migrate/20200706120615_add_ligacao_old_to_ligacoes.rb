class AddLigacaoOldToLigacoes < ActiveRecord::Migration
  def change
    add_column :ligacoes, :ligacao_old, :boolean
  end
end
