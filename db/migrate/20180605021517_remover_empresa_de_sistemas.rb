class RemoverEmpresaDeSistemas < ActiveRecord::Migration
  def change
    execute <<-SQL
      update pacotes 
      set sistema_id = case sistema_id when 5 then 3 when 6 then 2 when 7 then 1 when 8 then 4 end
      where empresa_id = 2;
      alter table sistemas drop column empresa_id;
    SQL
  end
end
