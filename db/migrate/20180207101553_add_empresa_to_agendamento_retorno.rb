class AddEmpresaToAgendamentoRetorno < ActiveRecord::Migration
  def change
    add_reference :agendamento_retornos, :empresa, index: true, foreign_key: true
  end
end
