class AddSolicitacaoDesistenciaToAnexos < ActiveRecord::Migration
  def change
    add_column :anexos, :solicitacao_desistencia_id, :integer
  end
end
