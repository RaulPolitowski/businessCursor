class AddRestanteToControleJobs < ActiveRecord::Migration
  def change
    add_column :controle_jobs, :restante, :integer
    add_column :controle_jobs, :filas, :string
  end
end
