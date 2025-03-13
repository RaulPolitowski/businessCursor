class AddImplantacaoToAgendamentoRetorno < ActiveRecord::Migration
  def change
    add_reference :agendamento_retornos, :implantacao, index: true, foreign_key: true
  end
end
