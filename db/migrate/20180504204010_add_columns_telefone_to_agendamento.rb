class AddColumnsTelefoneToAgendamento < ActiveRecord::Migration
  def change
    add_column :agendamentos, :telefone2, :string
    add_column :agendamentos, :responsavel2, :string
  end
end
