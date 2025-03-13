class AddFinanceiroFieldsToPesquisa < ActiveRecord::Migration
  def change
    add_column :pesquisas, :situacao_financeira, :string
    add_column :pesquisas, :com_pendencia_financeira, :boolean, default: false
    add_column :pesquisas, :bloqueado, :boolean, default: false
  end
end
