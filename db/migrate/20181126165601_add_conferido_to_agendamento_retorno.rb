class AddConferidoToAgendamentoRetorno < ActiveRecord::Migration
  def change
    add_column :agendamento_retornos, :conferido, :boolean, default: false
    add_column :agendamento_retornos, :baixado, :boolean, default: false
    add_column :agendamento_retornos, :data_cancelamento, :timestamp
  end
end
