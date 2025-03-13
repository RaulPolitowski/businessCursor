class CreateGzapUsuarios < ActiveRecord::Migration
  def change
    create_table :gzap_usuarios do |t|
      t.string :destinatarios, array: true, null: false
      t.string :user_id, null: false
      t.string :name

      t.timestamps null: false
    end
  end
end
