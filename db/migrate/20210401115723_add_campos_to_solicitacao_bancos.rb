class AddCamposToSolicitacaoBancos < ActiveRecord::Migration
  def change
    add_column :solicitacao_bancos, :telefone_parceiro, :string
    add_column :solicitacao_bancos, :email_cliente, :string
    add_column :solicitacao_bancos, :data_implantacao, :date
  end
end
