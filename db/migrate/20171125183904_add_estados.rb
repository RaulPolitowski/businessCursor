class AddEstados < ActiveRecord::Migration
  def change
    execute <<-SQL
      INSERT INTO estados (sigla, nome, created_at, updated_at) VALUES ('PR', 'Paraná', '2016-08-23 20:57:59.602023', '2016-08-23 20:57:59.602023');
      INSERT INTO estados (sigla, nome, created_at, updated_at) VALUES ('SP', 'São Paulo', '2016-08-23 20:58:00.668487', '2016-08-23 20:58:00.668487');
    SQL
  end
end
