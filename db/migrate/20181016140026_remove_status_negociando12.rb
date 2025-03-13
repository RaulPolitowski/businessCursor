class RemoveStatusNegociando12 < ActiveRecord::Migration
  def change
    execute <<-SQL
      update clientes set status_id = 7 where status_id in (29,30);
      update negociacoes set status_id = 7 where status_id in (29,30);
      update ligacoes set status_cliente_id = 7 where status_cliente_id in (29,30);
      DELETE FROM STATUS WHERE ID IN (29,30);
    SQL
  end
end
