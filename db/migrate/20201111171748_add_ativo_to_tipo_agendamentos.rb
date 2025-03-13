class AddAtivoToTipoAgendamentos < ActiveRecord::Migration
  def change
    add_column :tipo_agendamentos, :ativo, :boolean, default: true
  end
end
