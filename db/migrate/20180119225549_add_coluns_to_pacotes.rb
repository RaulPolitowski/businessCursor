class AddColunsToPacotes < ActiveRecord::Migration
  def change
    add_column :pacotes, :implantacao_remota, :decimal
    add_column :pacotes, :implantacao_remota_promocional, :decimal
  end
end
