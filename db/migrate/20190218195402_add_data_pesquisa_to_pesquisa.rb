class AddDataPesquisaToPesquisa < ActiveRecord::Migration
  def change
    add_column :pesquisas, :data_pesquisa, :timestamp
  end
end
