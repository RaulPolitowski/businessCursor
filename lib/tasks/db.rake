# lib/tasks/db.rake
namespace :db do

  desc "create database"
  task :create_database, [:database_name]  do |t, args|
    connection = Ecf::EcfDatabase.establish_connection({"adapter"=>"postgresql", "encoding"=>"unicode", "host"=>"#{ENV['gerar_db_ip']}", "port":"#{ENV['gerar_db_port']}", "user"=>"postgres", "username"=>"postgres", "password"=>"#{ENV['gerar_db_password']}", "pool"=>25, "database"=>"#{ENV['gerar_db_base']}"})
    connection = connection.connection
    teste = connection.select_all "SELECT datname FROM pg_database where datname = '#{args[:database_name]}'"
    if teste[0].present?
      connection.select_all "drop database #{args[:database_name]}"
    end
    connection.select_all "create database #{args[:database_name]}"
  end

  desc "drop database"
  task :drop_database, [:database_name] do |t, args|
    connection = Ecf::EcfDatabase.establish_connection({"adapter"=>"postgresql", "encoding"=>"unicode", "host"=>"#{ENV['gerar_db_ip']}", "port":"#{ENV['gerar_db_port']}", "user"=>"postgres", "username"=>"postgres", "password"=>"#{ENV['gerar_db_password']}", "pool"=>25, "database"=>"#{ENV['gerar_db_base']}"})
    connection = connection.connection
    teste = connection.select_all "SELECT datname FROM pg_database where datname = '#{args[:database_name]}'"
    if teste[0].present?
      connection.select_all "drop database #{args[:database_name]}"
    end
  end

  desc "execute file sql"
  task :execute_file_sql, [:file_path, :database_name] do |t, args|
    system "psql --host #{ENV['gerar_db_ip']} --port #{ENV['gerar_db_port']} --username postgres --quiet --file #{args[:file_path]} --dbname #{args[:database_name]}"
  end

  desc "Dumps the database to db/database_name.dump"
  task :dump, [:database_name, :name_backup] do |t, args|
    system "/usr/pgsql-10/bin/pg_dump --host #{ENV['gerar_db_ip']} --port #{ENV['gerar_db_port']} --username postgres --format=c #{args[:database_name]} > #{Rails.root}/tmp/#{args[:name_backup]}.backup"
  end

  private

end