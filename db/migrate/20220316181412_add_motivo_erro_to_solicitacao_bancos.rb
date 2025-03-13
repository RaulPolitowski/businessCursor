class AddMotivoErroToSolicitacaoBancos < ActiveRecord::Migration
  def change
    add_column :solicitacao_bancos, :motivo_erro, :string
  end
end
