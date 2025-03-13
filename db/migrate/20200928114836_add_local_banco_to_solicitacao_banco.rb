class AddLocalBancoToSolicitacaoBanco < ActiveRecord::Migration
  def change
    add_column :solicitacao_bancos, :local_banco, :integer
  end
end
