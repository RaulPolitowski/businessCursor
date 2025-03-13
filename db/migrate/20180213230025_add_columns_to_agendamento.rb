class AddColumnsToAgendamento < ActiveRecord::Migration
  def change
    add_column :agendamentos, :contato, :string
    add_column :agendamentos, :telefone, :string
  end
end
