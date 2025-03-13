class RemoveEmpresaMgUsers < ActiveRecord::Migration
  def change
    execute <<-SQL
      delete from empresas_users where empresa_id = 8;
    SQL
  end
end
