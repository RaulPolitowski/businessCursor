class AddColunsToRetorno < ActiveRecord::Migration
  def change
    add_column :agendamento_retornos, :cancelado, :boolean, default: false
    add_column :agendamento_retornos, :motivo, :string
  end
end
