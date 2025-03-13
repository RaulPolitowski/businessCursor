class CreateCampanhas < ActiveRecord::Migration
  def change
    create_table :campanhas do |t|
      t.integer :qtd_total
      t.integer :qtd_enviado
      t.integer :qtd_erros
      t.integer :qtd_ignorado
      t.string :tipo
      t.references :empresa, index: true, foreign_key: true
      t.integer :job
      t.string :status
      t.text :message
      t.string :numero

      t.timestamps null: false
    end
  end
end
