class AddSqlStatus < ActiveRecord::Migration
  def change
    execute <<-SQL
      INSERT INTO STATUS (id, descricao, created_at, updated_at, fechamento, status_empresa, tipo_status, descartada)
      VALUES (47, 'AGUARDANDO IMPLANTAÇÃO (LIMBO)', current_date, current_date, false, 5, 2, false);
    SQL
  end
end
