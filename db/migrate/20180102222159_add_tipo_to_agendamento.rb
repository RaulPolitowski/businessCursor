class AddTipoToAgendamento < ActiveRecord::Migration
  def change
    add_reference :agendamentos, :tipo_agendamento, index: true, foreign_key: true
  end
end
