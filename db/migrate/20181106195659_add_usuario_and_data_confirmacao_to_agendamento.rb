class AddUsuarioAndDataConfirmacaoToAgendamento < ActiveRecord::Migration
  def change
    add_column :agendamentos, :user_confirmacao_id, :integer
    add_column :agendamentos, :data_confirmacao, :timestamp
  end
end
