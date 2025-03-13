class AddCampoToSolicitacaoBancos < ActiveRecord::Migration
  def change
    add_column :solicitacao_bancos, :cnpj_parceiro, :string
    add_column :solicitacao_bancos, :socio_admin, :string
    add_column :solicitacao_bancos, :telefone1, :string
    add_column :solicitacao_bancos, :telefone2, :string
    add_column :solicitacao_bancos, :regime, :string
    add_column :solicitacao_bancos, :sistema, :string
    add_column :solicitacao_bancos, :valor_mensalidade, :decimal
    add_column :solicitacao_bancos, :data_vencimento, :date
    add_column :solicitacao_bancos, :valor_implantacao, :decimal
  end
end
