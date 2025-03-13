class CreateSolicitacaoDesistencias < ActiveRecord::Migration
  def change
    create_table :solicitacao_desistencias do |t|
      t.references :cliente, index: true, foreign_key: true
      t.references :empresa, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.string :status
      t.timestamp :data_solicitacao
      t.string :motivo_desistencia
      t.string :solicitante
      t.string :telefone
      t.string :motivo_ficou

      t.timestamps null: false
    end
  end
end
