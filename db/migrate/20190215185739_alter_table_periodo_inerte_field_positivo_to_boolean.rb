class AlterTablePeriodoInerteFieldPositivoToBoolean < ActiveRecord::Migration
  def change
    execute <<-SQL
      alter table periodo_inertes ALTER COLUMN positivo TYPE boolean USING positivo::boolean;
    SQL
  end
end
