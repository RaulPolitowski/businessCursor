class CreateSolicitacaoBancos < ActiveRecord::Migration
  def change
    create_table :solicitacao_bancos do |t|
      t.references :user
      t.references :cliente
      t.integer :tipo
      t.integer :status
      t.timestamp :finalizado
      t.string :motivo_solicitacao
      t.string :observacao
      t.string :motivo_desativacao
      t.boolean :ativo, default: true

      t.timestamps null: false
    end
  end
end
