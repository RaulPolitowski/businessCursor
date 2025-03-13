class RemoveEmpresaToTipoAgendamentos < ActiveRecord::Migration
  def change
    remove_column :tipo_agendamentos, :empresa_id, :integer
  end
end
