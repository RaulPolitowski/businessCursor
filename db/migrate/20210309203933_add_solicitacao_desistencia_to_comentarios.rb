class AddSolicitacaoDesistenciaToComentarios < ActiveRecord::Migration
  def change
    add_column :comentarios, :solicitacao_desistencia_id, :integer
    add_column :agendamento_retornos, :solicitacao_desistencia_id, :integer
    add_column :solicitacao_desistencias, :tags, :json
  end
end
