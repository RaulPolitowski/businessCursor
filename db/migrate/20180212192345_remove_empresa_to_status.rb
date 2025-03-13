class RemoveEmpresaToStatus < ActiveRecord::Migration
  def change
    execute <<-SQL
    update clientes set status_id = case status_id when 10 then 1 when 11 then 2 when 12 then 3 when 13 then 4 when 14 then 5 when 15 then 6 when 16 then 7 when 17 then 8 when 18 then 9 end;
       delete from status where empresa_id = 2;
        alter table status drop column empresa_id;
    SQL
  end
end
