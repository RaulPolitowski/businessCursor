class CreateAnexos < ActiveRecord::Migration
  def change
    create_table :anexos do |t|
      t.references :cliente, index: true, foreign_key: true
      t.string :file

      t.timestamps null: false
    end
  end
end
