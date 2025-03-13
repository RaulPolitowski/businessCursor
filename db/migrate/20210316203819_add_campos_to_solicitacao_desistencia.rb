class AddCamposToSolicitacaoDesistencia < ActiveRecord::Migration
  def change
    add_column :solicitacao_desistencias, :cnpj, :string
    add_column :solicitacao_desistencias, :nome_solicitante, :string
    add_column :solicitacao_desistencias, :email_solicitante, :string   
  end
end
