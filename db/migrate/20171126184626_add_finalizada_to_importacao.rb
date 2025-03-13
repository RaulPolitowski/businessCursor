class AddFinalizadaToImportacao < ActiveRecord::Migration
  def change
    add_column :importacoes, :finalizada, :boolean
  end
end
