class AddEmpresaToTipoAgendamento < ActiveRecord::Migration
  def change
    add_reference :tipo_agendamentos, :empresa, index: true, foreign_key: true
  end
end
