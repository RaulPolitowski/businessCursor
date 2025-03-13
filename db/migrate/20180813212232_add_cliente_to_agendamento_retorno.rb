class AddClienteToAgendamentoRetorno < ActiveRecord::Migration
  def change
    add_reference :agendamento_retornos, :cliente, index: true, foreign_key: true
  end
end
