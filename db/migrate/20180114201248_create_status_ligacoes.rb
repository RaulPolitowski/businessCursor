class CreateStatusLigacoes < ActiveRecord::Migration
  def change
    create_table :status_ligacoes do |t|
      t.string :descricao

      t.timestamps null: false
    end
  end
end
