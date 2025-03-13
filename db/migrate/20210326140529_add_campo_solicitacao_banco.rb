class AddCampoSolicitacaoBanco < ActiveRecord::Migration
  def change
    add_column :solicitacao_bancos, :nome_solicitante, :string
    add_column :solicitacao_bancos, :email_solicitante, :string
  end
end
