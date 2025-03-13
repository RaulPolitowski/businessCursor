class AddEmpresaToLigacao < ActiveRecord::Migration
  def change
    add_reference :ligacoes, :empresa, index: true, foreign_key: true
  end
end
