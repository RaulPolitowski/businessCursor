class CreateTelefones < ActiveRecord::Migration
  def change
    create_table :telefones do |t|
      t.string :telefone
      t.integer :tipo
      t.boolean :preferencial
      t.boolean :enviado_whats
      t.references :contato, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
