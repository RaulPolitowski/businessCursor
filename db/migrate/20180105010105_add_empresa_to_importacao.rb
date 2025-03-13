class AddEmpresaToImportacao < ActiveRecord::Migration
  def change
    add_reference :importacoes, :empresa, index: true, foreign_key: true
  end
end
