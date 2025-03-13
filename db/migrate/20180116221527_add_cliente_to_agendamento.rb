class AddClienteToAgendamento < ActiveRecord::Migration
  def change
    add_reference :agendamentos, :cliente, index: true, foreign_key: true
  end
end
