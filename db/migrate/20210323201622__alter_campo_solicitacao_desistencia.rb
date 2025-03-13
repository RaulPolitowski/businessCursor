class AlterCampoSolicitacaoDesistencia < ActiveRecord::Migration
  def change
    rename_column :solicitacao_desistencias, :motivo_desistencia, :motivo_solicitacao
    add_column :solicitacao_desistencias, :motivo_desistencia, :string
  end
end
