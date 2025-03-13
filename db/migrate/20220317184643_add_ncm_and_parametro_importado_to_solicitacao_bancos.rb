class AddNcmAndParametroImportadoToSolicitacaoBancos < ActiveRecord::Migration
  def change
    add_column :solicitacao_bancos, :ncm_importado, :boolean, default: false
    add_column :solicitacao_bancos, :parametro_ncm_importado, :boolean, default: false
  end
end
