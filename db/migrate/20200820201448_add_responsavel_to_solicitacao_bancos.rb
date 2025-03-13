class AddResponsavelToSolicitacaoBancos < ActiveRecord::Migration
  def change
    add_reference :solicitacao_bancos, :responsavel, index:true
    add_foreign_key :solicitacao_bancos, :users, column: :responsavel_id

    add_column :solicitacao_bancos, :data_desativado, :timestamp
    add_reference :solicitacao_bancos, :desativado_por, index:true
    add_foreign_key :solicitacao_bancos, :users, column: :desativado_por_id

    add_column :solicitacao_bancos, :link_request, :string
  end
end
