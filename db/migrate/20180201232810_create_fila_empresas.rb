class CreateFilaEmpresas < ActiveRecord::Migration
  def change
    create_table :fila_empresas do |t|
      t.references :cliente, index: true, foreign_key: true
      t.integer :numero_fila
      t.references :empresa, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
