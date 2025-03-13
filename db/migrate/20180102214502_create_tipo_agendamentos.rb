class CreateTipoAgendamentos < ActiveRecord::Migration
  def change
    create_table :tipo_agendamentos do |t|
      t.string :descricao
      t.string :cor

      t.timestamps null: false
    end
  end
end
