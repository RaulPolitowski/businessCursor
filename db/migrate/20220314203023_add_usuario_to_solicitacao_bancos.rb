class AddUsuarioToSolicitacaoBancos < ActiveRecord::Migration
  def change
    add_column :solicitacao_bancos, :username, :string
    add_column :solicitacao_bancos, :password, :string
    add_column :solicitacao_bancos, :nome_usuario, :string
  end
end
