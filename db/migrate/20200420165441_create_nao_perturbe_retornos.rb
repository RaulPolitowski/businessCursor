class CreateNaoPerturbeRetornos < ActiveRecord::Migration
  def change
    create_table :nao_perturbe_retornos do |t|
      t.references :user, index: true, foreign_key: true
      t.timestamp :data_fim

      t.timestamps null: false
    end
  end
end
