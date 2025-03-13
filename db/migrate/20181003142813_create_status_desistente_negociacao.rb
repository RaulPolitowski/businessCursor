class CreateStatusDesistenteNegociacao < ActiveRecord::Migration
  def change
    execute <<-SQL
      INSERT INTO STATUS (id, descricao, created_at, updated_at, fechamento, status_empresa, tipo_status, descartada)
      VALUES (10, 'DESISTENTE NEGOCIAÇÃO', current_date, current_date, false, 3, 1, false);
    SQL
  end
end
