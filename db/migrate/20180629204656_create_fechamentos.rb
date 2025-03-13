class CreateFechamentos < ActiveRecord::Migration
  def change
    create_table :fechamentos do |t|
      t.timestamp :data_fechamento
      t.references :tipo_fechamento, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.references :proposta, index: true, foreign_key: true
      t.references :cliente, index: true, foreign_key: true
      t.references :status, index: true, foreign_key: true
      t.references :empresa, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
