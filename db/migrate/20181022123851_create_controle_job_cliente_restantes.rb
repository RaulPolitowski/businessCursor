class CreateControleJobClienteRestantes < ActiveRecord::Migration
  def change
    create_table :controle_job_cliente_restantes do |t|
      t.references :controle_job, index: true, foreign_key: true
      t.references :cliente, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
