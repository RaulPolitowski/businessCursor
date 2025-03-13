class CreateAgendamentoRetornos < ActiveRecord::Migration
  def change
    create_table :agendamento_retornos do |t|
      t.references :ligacao, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.datetime :data_agendamento_retorno
      t.datetime :data_efetuado_retorno
      t.integer :user_retorno_id

      t.timestamps null: false
    end
  end
end
