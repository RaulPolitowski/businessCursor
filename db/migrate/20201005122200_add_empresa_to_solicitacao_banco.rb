class AddEmpresaToSolicitacaoBanco < ActiveRecord::Migration
  def change
    add_reference :solicitacao_bancos, :empresa, index: true, foreign_key: true
  end
end
