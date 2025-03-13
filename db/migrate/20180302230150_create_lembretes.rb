class CreateLembretes < ActiveRecord::Migration
  def change
    create_table :lembretes do |t|
      t.datetime :data
      t.integer :user_registro_id
      t.integer :user_lembrete_id
      t.string :observacao
      t.references :empresa, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
