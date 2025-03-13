class CreateControleJobs < ActiveRecord::Migration
  def change
    create_table :controle_jobs do |t|
      t.date :data_controle
      t.integer :job
      t.integer :quantidade
      t.references :empresa, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
