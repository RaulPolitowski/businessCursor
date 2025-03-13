class CreateAbordagemIniciais < ActiveRecord::Migration
  def change
    create_table :abordagem_iniciais do |t|
      t.string :texto
      t.boolean :ativa, default:true

      t.timestamps null: false
    end
  end
end
