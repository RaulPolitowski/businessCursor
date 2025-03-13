class AddEmpresaToNegociacao < ActiveRecord::Migration
  def change
    add_reference :negociacoes, :empresa, index: true, foreign_key: true
  end
end
