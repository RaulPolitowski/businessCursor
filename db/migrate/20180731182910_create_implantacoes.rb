class CreateImplantacoes < ActiveRecord::Migration
  def change
    create_table :implantacoes do |t|
      t.references :cliente, index: true, foreign_key: true
      t.references :proposta, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.integer :status
      t.timestamp :data_inicio
      t.timestamp :data_fim

      t.timestamps null: false
    end
  end
end

