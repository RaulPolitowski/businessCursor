class CreateTipoFechamentos < ActiveRecord::Migration
  def change
    create_table :tipo_fechamentos do |t|
      t.string :descricao

      t.timestamps null: false
    end
  end
end
