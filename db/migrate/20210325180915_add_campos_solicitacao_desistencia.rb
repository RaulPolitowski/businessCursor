class AddCamposSolicitacaoDesistencia < ActiveRecord::Migration
  def change
    add_column :solicitacao_desistencias, :data_inicio, :date
    add_column :solicitacao_desistencias, :data_recuperado, :date
    add_column :solicitacao_desistencias, :data_desistencia, :date
  end
end
