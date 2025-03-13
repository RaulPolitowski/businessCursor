class AddColumnsToPesquisa < ActiveRecord::Migration
  def change
    add_column :pesquisas, :ultimo_login, :datetime
    add_column :pesquisas, :nova, :boolean
    add_column :pesquisas, :sistema, :string
    add_column :pesquisas, :versao, :string
    add_column :pesquisas, :tempo, :integer
  end
end
