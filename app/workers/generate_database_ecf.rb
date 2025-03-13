class GenerateDatabaseEcf
  include Sidekiq::Worker
  sidekiq_options queue: 'critical', retry: false

  require "rake"
  Rails.application.load_tasks
  require 'digest/md5'

  def perform(database_name, id_solicitacao_banco, ibge)

    solicitacao = SolicitacaoBanco.find id_solicitacao_banco
    cliente = Cliente.find solicitacao.cliente_id
    estado = cliente.cidade.estado.sigla
    solicitacao.update(status: 'ANDAMENTO')

    conn_newdatabase = {"adapter"=>"postgresql", "encoding"=>"unicode", "host"=>"#{ENV['gerar_db_ip']}", "port":"#{ENV['gerar_db_port']}", "user"=>"postgres", "username"=>"postgres", "password"=>"#{ENV['gerar_db_password']}", "pool"=>25, "database"=>"#{database_name}"}
    begin
      #Create database
      Rake::Task["db:create_database"].reenable
      Rake::Task["db:create_database"].invoke(database_name)

      #Run sql files
      files = Dir.glob("#{Rails.root}/lib/sql/*")
      puts "Reordenando arquivos SQL"
      files = files.sort_by{ |name| [name[/\d+/].to_i, name] }
      files.each do |file|
        puts "Executando file #{ file }"
        Rake::Task["db:execute_file_sql"].reenable
        Rake::Task["db:execute_file_sql"].invoke(file, database_name)
      end

      begin
        execute_ncm_file(id_solicitacao_banco, database_name)
        execute_parametroncm_file(estado, id_solicitacao_banco, database_name)
      rescue  Exception => e
        puts 'sem parametro aqui'
      end

      conn = Ecf::EcfDatabase.establish_connection(conn_newdatabase)
      connection = conn.connection

      nomeArray = cliente.socio_admin.present? ? cliente.socio_admin.split(' ') : nil
      nomeContato = nomeArray.nil? ? 'Contato' : "#{nomeArray[0]} #{nomeArray[1]}"

      connection.execute("UPDATE empresa SET cnpj = '#{cliente.cnpj.gsub(/\D/, '')}', endereco = '#{cliente.endereco}', inscricaoestadual = '#{solicitacao.inscricao_estadual.gsub(/\D/, '')}', nomefantasia = '#{cliente.nome_fantasia.gsub("''", '')}',
      razaosocial = '#{cliente.razao_social.gsub("''", '')}', nomecontato = '#{nomeContato}', bairro = '#{cliente.bairro}', numero = '#{cliente.numero_endereco}', cep = '#{cliente.cep.gsub(/\D/, '')}',
      municipio_id = #{ibge}, telefone = '#{cliente.telefone.gsub(/\D/, '')}', contribuicaoicms = #{solicitacao.contribuinte_icms}, issqn = false WHERE ID = 1")

      passwordAdmin = Digest::MD5.hexdigest('q27pptz8')
      connection.execute("INSERT INTO usuario(ativo, nome, senha, usuario, empresa_id, papel_id, senhacriptografada) VALUES (true, 'Administrador', '#{passwordAdmin}', 'admin', 1, 1, '#{passwordAdmin}')")

      password = Digest::MD5.hexdigest(solicitacao.password)
      connection.execute("INSERT INTO usuario(ativo, nome, senha, usuario, empresa_id, papel_id, senhacriptografada) VALUES (true, '#{solicitacao.nome_usuario}', '#{password}', '#{solicitacao.username}', 1, 1, '#{password}')")

      #Preferencia
      connection.execute("INSERT INTO preferencia (ambiente, forma, empresa_id) VALUES ('HOMOLOGACAO', 'normal', 1)")

      #Cliente Fornecedor
      connection.execute("INSERT INTO clientefornecedor (ativo, bairro, cep, cpfcnpj, endereco, inscricaoestadual, nomefantasia, numero, razaosocial, tiporegistro, empresa_id, telefone, contribuicaoicms, municipio_id)
      VALUES (true, '#{cliente.bairro}', '#{cliente.cep.gsub(/\D/, '')}', '#{cliente.cnpj.gsub(/\D/, '')}', '#{cliente.endereco}', '#{solicitacao.inscricao_estadual.gsub(/\D/, '')}', '#{cliente.nome_fantasia}', '#{cliente.numero_endereco}', '#{cliente.razao_social}', 'J', 1,
      '#{cliente.telefone.gsub(/\D/, '')}', #{solicitacao.contribuinte_icms} , #{ibge})")

      connection.execute("update empresa set clifor_id = 1")

      connection.execute SolicitacaoBancosHelper.modulo_insert('a078b208c352329dbdca66e2ffd77bc0', 1) if solicitacao.nota_fiscal_modulo?
      connection.execute SolicitacaoBancosHelper.modulo_insert('573a30057492bd05856cc1a8d59d2d45', 1) if solicitacao.nota_fiscal_consumidor_modulo?
      connection.execute SolicitacaoBancosHelper.modulo_insert('516bc5769d2ebb0b135fc08c7b4c0d13', 1) if solicitacao.conhecimento_transporte_modulo?
      connection.execute SolicitacaoBancosHelper.modulo_insert('6fb2d25e1a4895252c51923783e1d65b', 1) if solicitacao.manifesto_eletronico_modulo?
      connection.execute SolicitacaoBancosHelper.modulo_insert('728c42048127567fb3cbe243b826be7d', 1) if solicitacao.nota_fiscal_servico_modulo?
      connection.execute SolicitacaoBancosHelper.modulo_insert('454985c0ea0da86d2d2296f99134bcf2', 1) if solicitacao.cupom_fiscal_modulo?

      connection.execute SolicitacaoBancosHelper.permissao_usuario_empresa
      connection.execute SolicitacaoBancosHelper.parametro_impressao_insert
      connection.execute SolicitacaoBancosHelper.parametro_backup_insert
      connection.execute SolicitacaoBancosHelper.parametro_notificacao

      #create backup
      Rake::Task["db:dump"].reenable
      Rake::Task["db:dump"].invoke(database_name, database_name)

      #drop database
      Rake::Task["db:drop_database"].reenable
      Rake::Task["db:drop_database"].invoke(database_name)

      solicitacao.status = 'CRIADO'
      solicitacao.finalizado = Time.now
      file = File.open("#{Rails.root.join('tmp').to_s}/#{database_name}.backup")
      solicitacao.file = file

      solicitacao.save

      File.delete("#{Rails.root.join('tmp').to_s}/#{database_name}.backup") if File.exist?("#{Rails.root.join('tmp').to_s}/#{database_name}.backup")
    rescue Exception => ex
      connection.disconnect! unless connection.nil?
      conn.disconnect! unless conn.nil?
      puts "Erro na construçao do DB"
      puts ex
      solicitacao.update(status: 'ERROR', motivo_erro: ex.message)
    end
  end

  def execute_parametroncm_file(estado, id_solicitacao, databasename)
      ncm_file = get_parametros_estado estado
      execute_file(ncm_file, id_solicitacao, false, databasename)
  end

  def execute_ncm_file(id_solicitacao, databasename)
    ncm_file = get_ncm_file
    execute_file(ncm_file, id_solicitacao, true, databasename)
  end

  def get_ncm_file
    url = "http://updates.gtech.site/ecf/tabelas/ncm/NCM-init.sql"
    open(url, "r:ISO-8859-1")
  end

  def get_parametros_estado(estado)
    url = "http://updates.gtech.site/ecf/tabelas/ncm/ParametrosNCM-#{estado}-init.sql"
    open(url, "r:ISO-8859-1")
  end

  def execute_file(file, id_solicitacao, isNcm, databasename)
    line_array = file.readlines
    file_path = "#{Rails.root.join('tmp').to_s}/#{isNcm ? 'ncm' : 'parametro'}_#{id_solicitacao}.sql"
    File.open(file_path, "w+") do |f|
      line_array.each_with_index do |line, index|
        begin
          next if line.nil? || !line.strip.start_with?('INSERT')
          linha = line.encode("UTF-8", invalid: :replace, replace: "").to_s.strip
          if !linha.end_with?(');')
            linha += line_array[index+1].encode("UTF-8", invalid: :replace, replace: "").to_s.strip
            if !linha.end_with?(');')
              linha += line_array[index+2].encode("UTF-8", invalid: :replace, replace: "").to_s.strip
            end
          end
          f.puts(linha)
        rescue Exception => ex
          puts ex
        end
      end
    end

    Rake::Task["db:execute_file_sql"].reenable
    Rake::Task["db:execute_file_sql"].invoke(file_path, databasename)

    File.delete(file_path) if File.exist?(file_path)
  end


end
