class ChangeColumnSolicitacaoDesistencia < ActiveRecord::Migration
  def change
    change_column(:solicitacao_desistencias, :data_inicio, :timestamp)
    change_column(:solicitacao_desistencias, :data_recuperado, :timestamp)
    change_column(:solicitacao_desistencias, :data_desistencia, :timestamp)
  end
end
