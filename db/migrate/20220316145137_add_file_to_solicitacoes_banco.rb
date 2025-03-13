class AddFileToSolicitacoesBanco < ActiveRecord::Migration
  def change
    add_column :solicitacao_bancos, :file, :string
  end
end
