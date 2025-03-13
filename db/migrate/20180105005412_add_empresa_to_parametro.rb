class AddEmpresaToParametro < ActiveRecord::Migration
  def change
    add_reference :parametros, :empresa, index: true, foreign_key: true
  end
end
