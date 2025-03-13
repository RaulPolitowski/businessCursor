class AddAvisadoToAgendamentoRetorno < ActiveRecord::Migration
  def change
    add_column :agendamento_retornos, :avisado, :boolean, default: false
  end
end
