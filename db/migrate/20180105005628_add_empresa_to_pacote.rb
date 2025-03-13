class AddEmpresaToPacote < ActiveRecord::Migration
  def change
    add_reference :pacotes, :empresa, index: true, foreign_key: true
  end
end
