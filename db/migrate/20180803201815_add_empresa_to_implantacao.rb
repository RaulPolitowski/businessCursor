class AddEmpresaToImplantacao < ActiveRecord::Migration
  def change
    add_reference :implantacoes, :empresa, index: true, foreign_key: true
  end
end
