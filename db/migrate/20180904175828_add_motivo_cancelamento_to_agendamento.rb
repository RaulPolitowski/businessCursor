class AddMotivoCancelamentoToAgendamento < ActiveRecord::Migration
  def change
    add_column :agendamentos, :motivo, :string
    add_column :agendamentos, :user_cancelamento_id, :int
    add_column :agendamentos, :data_cancelamento, :timestamp
  end
end
