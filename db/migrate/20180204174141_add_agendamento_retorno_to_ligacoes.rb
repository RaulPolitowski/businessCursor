class AddAgendamentoRetornoToLigacoes < ActiveRecord::Migration
  def change
    add_reference :ligacoes, :agendamento_retorno, index: true, foreign_key: true
  end
end
