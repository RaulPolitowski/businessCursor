class AddAvisoConfirmacaoToAgendamento < ActiveRecord::Migration
  def change
    add_column :agendamentos, :aviso_nao_confirmado, :boolean, default: false
  end
end
