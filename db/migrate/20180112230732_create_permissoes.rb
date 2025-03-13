class CreatePermissoes < ActiveRecord::Migration
  def change
    create_table :permissoes do |t|
      t.string :descricao

      t.timestamps null: false
    end
  end
end
