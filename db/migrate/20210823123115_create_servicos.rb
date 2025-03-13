class CreateServicos < ActiveRecord::Migration
  def change
    create_table :servicos do |t|
      t.string :nome_servico

      t.timestamps null: false
    end
  end
end
