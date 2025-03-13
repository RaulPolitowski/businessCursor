class CreatePacotes < ActiveRecord::Migration
  def change
    create_table :pacotes do |t|
      t.references :sistema, index: true, foreign_key: true
      t.decimal :mensalidade
      t.decimal :mensalidade_promocional
      t.decimal :implantacao
      t.decimal :implantacao_promocional

      t.timestamps null: false
    end
  end
end
