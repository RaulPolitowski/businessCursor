class AddFinanceiroFieldsToPeriodoInerte < ActiveRecord::Migration
  def change
    add_column :periodo_inertes, :situacao_financeira, :string
    add_column :periodo_inertes, :com_pendencia_financeira, :boolean, default: false
  end
end
