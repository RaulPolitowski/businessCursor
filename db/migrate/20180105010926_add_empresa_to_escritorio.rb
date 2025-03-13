class AddEmpresaToEscritorio < ActiveRecord::Migration
  def change
    add_reference :escritorios, :empresa, index: true, foreign_key: true
  end
end
