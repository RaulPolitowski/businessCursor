class AddAcompanhamentoToAgendamentoRetorno < ActiveRecord::Migration
  def change
    add_reference :agendamento_retornos, :acompanhamento, index: true, foreign_key: true
  end
end
