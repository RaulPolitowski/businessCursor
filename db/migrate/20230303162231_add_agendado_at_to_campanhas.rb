class AddAgendadoAtToCampanhas < ActiveRecord::Migration
  def change
    add_column :campanhas, :agendado_at, :datetime
  end
end
