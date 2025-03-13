class AddProximaPesquisaToCliente < ActiveRecord::Migration
  def change
    add_column :clientes, :proxima_pesquisa, :date
  end
end
