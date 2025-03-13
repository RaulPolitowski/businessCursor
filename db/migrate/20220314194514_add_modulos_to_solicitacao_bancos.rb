class AddModulosToSolicitacaoBancos < ActiveRecord::Migration
  def change
    add_column :solicitacao_bancos, :nota_fiscal_modulo, :boolean, default: false
    add_column :solicitacao_bancos, :nota_fiscal_consumidor_modulo, :boolean, default: false
    add_column :solicitacao_bancos, :conhecimento_transporte_modulo, :boolean, default: false
    add_column :solicitacao_bancos, :manifesto_eletronico_modulo, :boolean, default: false
    add_column :solicitacao_bancos, :nota_fiscal_servico_modulo, :boolean, default: false
    add_column :solicitacao_bancos, :consulta_modulo, :boolean, default: false
    add_column :solicitacao_bancos, :cupom_fiscal_modulo, :boolean, default: false
  end
end
