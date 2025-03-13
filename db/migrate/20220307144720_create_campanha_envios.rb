class CreateCampanhaEnvios < ActiveRecord::Migration
  def change
    create_table :campanha_envios do |t|
      t.references :campanha, index: true, foreign_key: true
      t.references :cliente, index: true, foreign_key: true
      t.string :numero
      t.string :status

      t.timestamps null: false
    end
  end
end
