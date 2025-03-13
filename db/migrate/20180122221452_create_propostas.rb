class CreatePropostas < ActiveRecord::Migration
  def change
    create_table :propostas do |t|
      t.references :pacote, index: true, foreign_key: true
      t.string :tipo_mensalidade
      t.decimal :valor_mensalidade
      t.string :tipo_implantacao
      t.string :valor_implantacao
      t.string :observacao
      t.integer :qtde_parcela
      t.decimal :valor_parcelas

      t.timestamps null: false
    end
  end
end
