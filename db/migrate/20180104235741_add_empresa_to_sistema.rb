class AddEmpresaToSistema < ActiveRecord::Migration
  def change
    add_reference :sistemas, :empresa, index: true, foreign_key: true
  end
end
