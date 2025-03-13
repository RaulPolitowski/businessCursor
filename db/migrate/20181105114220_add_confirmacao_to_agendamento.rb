class AddConfirmacaoToAgendamento < ActiveRecord::Migration
  def change
    add_column :agendamentos, :confirmado, :boolean, default: false
  end
end
