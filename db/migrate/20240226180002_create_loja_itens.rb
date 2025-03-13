class CreateLojaItens < ActiveRecord::Migration
  def change
    create_table :loja_itens do |t|
      t.string :status, default: 'INDISPONIVEL'
      t.string :numero, unique: true
      t.references :user, index: true, foreign_key: true
      t.string :qrCode

      t.timestamps null: false
    end
  end
end
