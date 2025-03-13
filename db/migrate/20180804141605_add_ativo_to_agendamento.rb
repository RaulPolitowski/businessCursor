class AddAtivoToAgendamento < ActiveRecord::Migration
  def change
    add_column :agendamentos, :ativo, :boolean, default: true
  end
end
