class AddUserRegistroToAgendamento < ActiveRecord::Migration
  def change
    add_column :agendamentos, :user_registro_id, :integer
  end
end
