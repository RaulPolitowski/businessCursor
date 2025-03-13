class AddContribuinteAndInscricaoToSolicitacaoBanco < ActiveRecord::Migration
  def change
    add_column :solicitacao_bancos, :contribuinte_icms, :integer
    add_column :solicitacao_bancos, :inscricao_estadual, :string
  end
end
