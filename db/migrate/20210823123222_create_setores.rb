class CreateSetores < ActiveRecord::Migration
  def change
    create_table :setores do |t|
      t.string :nome_setor

      t.timestamps null: false
    end
  end
end
