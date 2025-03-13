class CreateComentarios < ActiveRecord::Migration
  def change
    create_table :comentarios do |t|
      t.text :comentario
      t.references :user, index: true, foreign_key: true
      t.references :implantacao, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
