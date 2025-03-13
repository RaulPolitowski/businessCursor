class AddImplantacaoToAgendamento < ActiveRecord::Migration
  def change
    add_reference :agendamentos, :implantacao, index: true, foreign_key: true
  end
end
