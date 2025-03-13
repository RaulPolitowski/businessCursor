class AddUserCancelamentoToAgendamentoRetorno < ActiveRecord::Migration
  def change
    add_column :agendamento_retornos, :usuario_cancelamento_id, :integer
  end
end
