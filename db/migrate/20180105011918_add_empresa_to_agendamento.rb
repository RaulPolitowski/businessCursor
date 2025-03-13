class AddEmpresaToAgendamento < ActiveRecord::Migration
  def change
    add_reference :agendamentos, :empresa, index: true, foreign_key: true
  end
end
