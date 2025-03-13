class CreateCnaeClientes < ActiveRecord::Migration
  def change
    create_table :cnae_clientes do |t|
      t.references :cnae, index: true, foreign_key: true
      t.references :cliente, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
