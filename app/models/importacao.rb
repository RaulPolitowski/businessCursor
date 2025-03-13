class Importacao < ActiveRecord::Base
  self.table_name = "importacoes"
  require 'webdrivers'
  require 'watir-webdriver'
  require 'headless'
  require 'nokogiri'
  require 'watir-get-image-content'
  require 'net/http'
  require 'zip'
  require 'csv'
  require 'rest-client'
  require 'json'
  require 'i18n'
  require 'net/ftp'

  belongs_to :user
  belongs_to :estado
  belongs_to :progress_bar
  belongs_to :empresa

  scope :do_dia, -> { where('data_importacao BETWEEN ? AND ?', DateTime.now.beginning_of_day, DateTime.now.end_of_day).all }

  def self.criar_importar_sp
    dataLiberacaoFilas = Time.now.end_of_day + 3601
    puts "FILA SERÀ LANÇADA AS #{ dataLiberacaoFilas }"

    headless = Headless.new
    headless.start

    prefs = {
      plugins: {
        always_open_pdf_externally: true
      }
    }
    prefes = {
      prompt_for_download: false,
      default_directory: Rails.root.join('tmp').to_s
    }
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_preference(:download, prefes)
    browser = Watir::Browser.new :chrome, prefs: prefs, options: options, :switches => ['--ignore-certificate-errors']

    importacao = nova_importacao_sefaz 1, 2, 'SP'

    importar_empresas_jucesp_sp browser, importacao
    #  importacao = Importacao.find 19851
    clientes = Cliente.where(importacao_id: importacao.id)
    clientes.each_with_index do |cliente, index|
      puts "Importando cnpj Nire #{index + 1}/#{clientes.size}"
      if !cliente.nire.blank? && cliente.cnpj.nil?
        importar_jucesp_nire(browser, cliente)
        sleep 1
        cliente.reload
      end
    end

    clientes = Cliente.where(importacao_id: importacao.id).where('(cnpj is null)')
    clientes.each_with_index do |cliente|
      if !cliente.nire.blank? && cliente.cnpj.nil?
        importar_jucesp_nire(browser, cliente)
        sleep 1
        cliente.reload
      end
    end

    Importacao.importar_sp(importacao.id, dataLiberacaoFilas)
    #    Importacao.importar_sp(importacao.id, nil)

    browser.quit

    headless.destroy
  end

  def self.reprocessar_importacao_sp(importacao_id)
    importacao = Importacao.find importacao_id

    Importacao.importar_sp(importacao.id, nil)
  end

  def self.importar_sp(importacao_id, dataLiberacaoFilas)
    puts 'Importando receita primeira vez'
    importar_receita_pr importacao_id

    if dataLiberacaoFilas.present?
      while Time.now < dataLiberacaoFilas do
        sleep 10
      end
    end

    Importacao.importar_escritorios 'SP', 2, importacao_id

    #PROCESSAR JOB1 (EMPRESAS COM TELEFONE E CNAES VALIDOS)
    #clientesJob1 = Cliente.select("distinct clientes.*").cnae_blacklist.completo.para_ligacao.where(importacao_id: importacao_id)

    #puts 'Lancando job1'
    #FilaEmpresa.ajustar_fila_job1_sp clientesJob1

    FilaEmpresa.reprocessar_fila_empresa importacao_id, 2, nil

    puts 'Fim do processo de importacao'
  end

  def self.criar_importacao_pr
    puts "Iniciando importação PR as #{ Time.now.to_s }"
    importacao = nova_importacao_sefaz 1, 1, 'PR'
    importar_sefaz_pr importacao

    importar_receita 1, 'PR', importacao.id
    puts "Finalizou importação PR as #{ Time.now.to_s }"
  end

  def self.criar_importacao_ms
    puts "Iniciando importação MS as #{ Time.now.to_s }"
    importacao = nova_importacao_sefaz 1, 3, 'MS'
    importar_sefaz_ms importacao

    importar_receita 3, 'MS', importacao.id
    puts "Finalizou importação MS as #{ Time.now.to_s }"
  end

  def self.criar_importacao_mg
    puts "Iniciando importação MG as #{ Time.now.to_s }"
    importacao = nova_importacao_sefaz 1, 8, 'MG'
    importar_sefaz_mg importacao

    importar_receita 8, 'MG', importacao.id
    puts "Finalizou importação MG as #{ Time.now.to_s }"
  end

  def self.criar_importacao_rs
    puts "Iniciando importação RS as #{ Time.now.to_s }"
    importacao = nova_importacao_sefaz 1, 7, 'RS'
    importar_sefaz_rs importacao

    importar_receita 7, 'RS', importacao.id
    puts "Finalizou importação RS as #{ Time.now.to_s }"
  end

  def self.criar_importacao_go
    puts "Iniciando importação GO as #{ Time.now.to_s }"
    importacao = nova_importacao_sefaz 1, 9, 'GO'
    importar_sefaz_go importacao

    importar_receita 9, 'GO', importacao.id
    puts "Finalizou importação GO as #{ Time.now.to_s }"
  end

  def self.criar_importacao_ba
    puts "Iniciando importação BA as #{ Time.now.to_s }"
    importacao = nova_importacao_sefaz 1, 4, 'BA'
    importar_sefaz_ba importacao

    importar_receita 4, 'BA', importacao.id
    puts "Finalizou importação BA as #{ Time.now.to_s }"
  end

  def self.criar_importacao_pe
    puts "Iniciando importação PE as #{ Time.now.to_s }"
    importacao = nova_importacao_sefaz 1, 13, 'PE'
    importar_sefaz_pe importacao

    importar_receita 13, 'PE', importacao.id
    puts "Finalizou importação PE as #{ Time.now.to_s }"
  end

  def self.criar_importacao_es
    puts "Iniciando importação ES as #{ Time.now.to_s }"
    importacao = nova_importacao_sefaz 1, 14, 'ES'
    importar_sefaz_es importacao

    importar_receita 14, 'ES', importacao.id
    puts "Finalizou importação ES as #{ Time.now.to_s }"
  end

  def self.criar_importacao_rj
    puts "Iniciando importação RJ as #{ Time.now.to_s }"
    importacao = nova_importacao_sefaz 1, 15, 'RJ'
    importar_sefaz_rj importacao

    importar_receita 15, 'RJ', importacao.id
    puts "Finalizou importação RJ as #{ Time.now.to_s }"
  end

  def self.criar_importacao_pb
    puts "Iniciando importação PB as #{ Time.now.to_s }"
    importacao = nova_importacao_sefaz 1, 17, 'PB'
    importar_sefaz_pb importacao

    importar_receita 17, 'PB', importacao.id
    puts "Finalizou importação PB as #{ Time.now.to_s }"
  end

  def self.criar_importacao_ce
    puts "Iniciando importação CE as #{ Time.now.to_s }"
    importacao = nova_importacao_sefaz 1, 18, 'CE'
    importar_sefaz_ce importacao

    importar_receita 18, 'CE', importacao.id
    puts "Finalizou importação CE as #{ Time.now.to_s }"
  end

  def self.criar_importacao_ma
    puts "Iniciando importação MA as #{ Time.now.to_s }"
    importacao = nova_importacao_sefaz 1, 19, 'MA'
    importar_sefaz_ma importacao

    importar_receita 19, 'MA', importacao.id
    puts "Finalizou importação MA as #{ Time.now.to_s }"
  end

  def self.importar_receita(empresa_id, estado, importacao_id)
    importacao = Importacao.find importacao_id

    puts 'Importando receita primeira vez'
    importar_receita_pr importacao.id

    Importacao.importar_escritorios estado, empresa_id, importacao.id

    FilaEmpresa.reprocessar_fila_empresa importacao.id, empresa_id, nil
  end

  def self.importar_escritorios(estado, empresa_id, importacao_id)
    import = Importacao.where(data_importacao: Time.now.to_date, empresa_id: 5, estado: (Estado.find_by_sigla estado)).first
    if import.nil?
      import = Importacao.create(data_importacao: Time.now.to_date, user_id: 1, estado: (Estado.find_by_sigla estado), finalizada: true, empresa_id: 5, importado: 0, nao_importado: 0, ja_existente: 0, total: 0)
    end
    clientes = Cliente.select("distinct clientes.*").cliente_escritorios(empresa_id).where(importacao_id: importacao_id)

    clientesFile = Array.new
    clientes.each do |cliente|
      if cliente.empresa_id != 5
        cli = Cliente.where('cnpj = ? and empresa_id = ?', cliente.cnpj, 5).first
        if cli.nil?
          cliente.update(empresa_id: 5, importacao_id: import.id)
          clientesFile << cliente
        end
      end
    end

    import.update(importado: import.importado + clientesFile.length, total: import.total + clientesFile.length)
  end

  def self.importar_receita_pr importacao_id
    clientes = Cliente.where(importacao_id: importacao_id).incompleto
    importar_clientes_receita clientes
    puts 'TERMINADO RECEITA'
  end

  def self.importar_clientes_receita clientes
    clientes.each_with_index do |cliente, index|
      if !cliente.cnpj.blank?
        puts "Importado #{index + 1}/#{clientes.size}"
        aux = importar_dados_receita(cliente)
        puts aux if aux.present?
      end
    end
  end

  def self.getResponseAPI(cnpj)
    CnpjWsImporter.new(cnpj).import
  end

  def self.getResponseCep(cep)
    CepImporter.new(cep, true).import
  end

  def self.importar_dados_cnpj(cnpj)
    response = getResponseAPI(cnpj)
    return response
  end

  def self.importar_dados_receita(cliente)
    puts "Importando receita CNPJ #{cliente.cnpj}"
    begin
      response = getResponseAPI(cliente.cnpj)
      resposta = response
      if resposta.nil?
        cliente.update(rejeitado_rf: true)
        # send_empresa_pro_vendas_cnpj(cliente.cnpj)
        return 'CNPJ não localizado na API'
      end

      send_empresa_pro_vendas(resposta, nil)

      cliente.razao_social = resposta['razao_social']
      cliente.endereco = resposta['estabelecimento']['logradouro']
      cliente.numero_endereco = resposta['estabelecimento']['numero']
      cliente.complemento = resposta['estabelecimento']['complemento']
      cliente.bairro = resposta['estabelecimento']['bairro']
      cliente.cep = resposta['estabelecimento']['cep']
      cliente.status_empresa = 0
      cliente.nome_fantasia = resposta['estabelecimento']['nome_fantasia']
      cliente.porte = "#{resposta['natureza_juridica']['id']} - #{resposta['natureza_juridica']['descricao']}"
      telefone1 = resposta['estabelecimento']['telefone1']
      telefone2 = resposta['estabelecimento']['telefone2']
      cliente.telefone = "(#{resposta['estabelecimento']['ddd1']}) #{!telefone1.nil? && telefone1.length == 8 ? telefone1.insert(4, '-') : telefone1}"
      cliente.telefone2 = "(#{resposta['estabelecimento']['ddd2']}) #{!telefone2.nil? && telefone2.length == 8 ? telefone2.insert(4, '-') : telefone2}"

      cliente.data_licenca = resposta['estabelecimento']['data_inicio_atividade']

      cliente.email = resposta['estabelecimento']['email']
      if !resposta['estabelecimento']['atividade_principal'].nil?
        cnae_principal = resposta['estabelecimento']['atividade_principal']
        cnae = Cnae.find_by_codigo cnae_principal['subclasse'].gsub('-', '').gsub('/', '').strip

        if cnae.nil?
          cnae = Cnae.new
          cnae.codigo = cnae_principal.codigo
          cnae.descricao = cnae_principal.descricao
          cnae.save!
        end

        cliente.cnae = cnae
      end

      if !resposta['estabelecimento']['atividades_secundarias'].nil?
        CnaeCliente.where(cliente: cliente).destroy_all if resposta['estabelecimento']['atividades_secundarias'].size > 0
        resposta['estabelecimento']['atividades_secundarias'].each do |cnae_sec|
          codigo = cnae_sec['subclasse'].gsub('-', '').gsub('/', '').strip
          next if codigo == '0000000' || codigo == "8888888"

          cnae = Cnae.find_by_codigo codigo
          if cnae.nil?
            cnae = Cnae.new
            cnae.codigo = codigo
            cnae.descricao = cnae_sec['descricao'].strip
            cnae.save
          end

          seg = CnaeCliente.new
          seg.cliente = cliente
          seg.cnae = cnae
          seg.save
        end
      end

      if cliente.contatos.empty? && resposta['socios'].size > 0
        cliente.socio_admin = resposta['socios'][0]['nome']

        resposta['socios'].each do |aux|
          contato = Contato.new
          contato.nome = aux['nome']

          contato.funcao = aux['qualificacao_socio']['diretor']

          cliente.contatos << contato
        end
      end

      begin
        cep = getResponseCep cliente.cep
        if cep
          estado = Estado.find_by_sigla cep[:estado_sigla]
          municipio = Cidade.where(" upper(unaccent(nome)) = upper(unaccent(?)) and estado_id = ?", cep[:cidade].upcase, estado.id).limit(1).first

          if municipio.nil?
            municipio = Cidade.create(nome: I18n.transliterate(cep[:cidade]), estado_id: estado.id, codigo: cep[:ibge])
          end
        end
      rescue
        puts "CEP ERROR: #{cliente.cep}"
      end

      if municipio.nil?
        estado = Estado.find_by_sigla resposta['estabelecimento']['estado']['sigla']
        municipio = Cidade.where(" upper(unaccent(nome)) = upper(unaccent(?)) and estado_id = ?", resposta['estabelecimento']['cidade']['nome'].upcase, estado.id).limit(1).first

        if municipio.nil?
          municipio = Cidade.create(nome: I18n.transliterate(resposta['estabelecimento']['cidade']['nome'].upcase), estado_id: estado.id, codigo: nil)
        end
      end

      cliente.cidade = municipio

      # #Verifica DDD, se for 18, 17 ou 14...joga no PR
      # cliente.empresa_id = 1 if cliente.telefone.gsub('-', '').gsub('(', '').gsub(')', '').gsub( ' ', '').gsub('/', '').strip.first(2) == '18' || cliente.telefone.gsub('-', '').gsub('(', '').gsub(')', '').gsub( ' ', '').gsub('/', '').strip.first(3) == '018'
      # cliente.empresa_id = 1 if cliente.telefone.gsub('-', '').gsub('(', '').gsub(')', '').gsub( ' ', '').gsub('/', '').strip.first(2) == '17' || cliente.telefone.gsub('-', '').gsub('(', '').gsub(')', '').gsub( ' ', '').gsub('/', '').strip.first(3) == '017'
      # cliente.empresa_id = 1 if cliente.telefone.gsub('-', '').gsub('(', '').gsub(')', '').gsub( ' ', '').gsub('/', '').strip.first(2) == '14' || cliente.telefone.gsub('-', '').gsub('(', '').gsub(')', '').gsub( ' ', '').gsub('/', '').strip.first(3) == '014'

      escritorio = Escritorio.telefone(cliente.telefone).first
      if escritorio.present?
        cliente.escritorio = escritorio
        cliente.telefone = nil
      end

      escritorio = Escritorio.telefone_contato(cliente.telefone).first
      if escritorio.present?
        cliente.escritorio = escritorio
        cliente.telefone = nil
      end

      escritorio = Escritorio.telefone(cliente.telefone2).first
      if escritorio.present?
        cliente.escritorio = escritorio
        cliente.telefone2 = nil
      end

      escritorio = Escritorio.telefone_contato(cliente.telefone2).first
      if escritorio.present?
        cliente.escritorio = escritorio
        cliente.telefone2 = nil
      end
      cliente.save!
      puts "SALVEI #{cliente.cnpj}"

      return ''
    rescue Exception => ex
      cliente.update(rejeitado_rf: true)
      puts ex.to_s
      return ex.to_s
    end
  end

  def self.reconsultar_dados_receita(cliente)
    puts "Reconsultando receita CNPJ #{cliente.cnpj}"
    begin
      response = getResponseAPI cliente.cnpj
      resposta = response

      if resposta.nil?
        puts "#{Time.now} - Erro ao Reconsultar - Resposta igual null - CNPJ:#{cliente.cnpj}"
        verify_reconsultas_rf_cliente(cliente)
        # send_empresa_pro_vendas_cnpj(cliente.cnpj)
        return "#{Time.now} - CNPJ não localizado na API"
      end

      puts "#{Time.now} - CNPJ #{cliente.cnpj} encontrado!"
      send_empresa_pro_vendas(resposta, nil)

      cliente.razao_social = resposta['razao_social']
      cliente.endereco = resposta['estabelecimento']['logradouro']
      cliente.numero_endereco = resposta['estabelecimento']['numero']
      cliente.complemento = resposta['estabelecimento']['complemento']
      cliente.bairro = resposta['estabelecimento']['bairro']
      cliente.cep = resposta['estabelecimento']['cep']
      cliente.status_empresa = 0
      cliente.nome_fantasia = resposta['estabelecimento']['nome_fantasia']
      cliente.porte = "#{resposta['natureza_juridica']['id']} - #{resposta['natureza_juridica']['descricao']}"
      telefone1 = resposta['estabelecimento']['telefone1']
      telefone2 = resposta['estabelecimento']['telefone2']
      cliente.telefone = "(#{resposta['estabelecimento']['ddd1']}) #{!telefone1.nil? && telefone1.length == 8 ? telefone1.insert(4, '-') : telefone1}"
      cliente.telefone2 = "(#{resposta['estabelecimento']['ddd2']}) #{!telefone2.nil? && telefone2.length == 8 ? telefone2.insert(4, '-') : telefone2}"

      cliente.data_licenca = resposta['estabelecimento']['data_inicio_atividade']

      cliente.email = resposta['estabelecimento']['email']
      if !resposta['estabelecimento']['atividade_principal'].nil?
        cnae_principal = resposta['estabelecimento']['atividade_principal']
        cnae = Cnae.find_by_codigo cnae_principal['subclasse'].gsub('-', '').gsub('/', '').strip

        if cnae.nil?
          cnae = Cnae.new
          cnae.codigo = cnae_principal.codigo
          cnae.descricao = cnae_principal.descricao
          cnae.save!
        end

        cliente.cnae = cnae
      end

      if !resposta['estabelecimento']['atividades_secundarias'].nil?
        CnaeCliente.where(cliente: cliente).destroy_all if resposta['estabelecimento']['atividades_secundarias'].size > 0
        resposta['estabelecimento']['atividades_secundarias'].each do |cnae_sec|
          codigo = cnae_sec['subclasse'].gsub('-', '').gsub('/', '').strip
          next if codigo == '0000000' || codigo == "8888888"

          cnae = Cnae.find_by_codigo codigo
          if cnae.nil?
            cnae = Cnae.new
            cnae.codigo = codigo
            cnae.descricao = cnae_sec['descricao'].strip
            cnae.save
          end

          seg = CnaeCliente.new
          seg.cliente = cliente
          seg.cnae = cnae
          seg.save
        end
      end

      if cliente.contatos.empty? && resposta['socios'].size > 0
        cliente.socio_admin = resposta['socios'][0]['nome']

        resposta['socios'].each do |aux|
          contato = Contato.new
          contato.nome = aux['nome']

          contato.funcao = aux['qualificacao_socio']['diretor']

          cliente.contatos << contato
        end
      end

      begin
        cep = getResponseCep cliente.cep
        if cep
          estado = Estado.find_by_sigla cep[:estado_sigla]
          municipio = Cidade.where(" upper(unaccent(nome)) = upper(unaccent(?)) and estado_id = ?", cep[:cidade].upcase, estado.id).limit(1).first

          if municipio.nil?
            municipio = Cidade.create(nome: I18n.transliterate(cep[:cidade]), estado_id: estado.id, codigo: cep[:ibge])
          end
        end
      rescue
        puts "CEP ERROR: #{cliente.cep}"
      end

      if municipio.nil?
        estado = Estado.find_by_sigla resposta['estabelecimento']['estado']['sigla']
        municipio = Cidade.where(" upper(unaccent(nome)) = upper(unaccent(?)) and estado_id = ?", resposta['estabelecimento']['cidade']['nome'].upcase, estado.id).limit(1).first

        if municipio.nil?
          municipio = Cidade.create(nome: I18n.transliterate(resposta['estabelecimento']['cidade']['nome'].upcase), estado_id: estado.id, codigo: nil)
        end
      end

      cliente.cidade = municipio

      # #Verifica DDD, se for 18, 17 ou 14...joga no PR
      # cliente.empresa_id = 1 if cliente.telefone.gsub('-', '').gsub('(', '').gsub(')', '').gsub( ' ', '').gsub('/', '').strip.first(2) == '18' || cliente.telefone.gsub('-', '').gsub('(', '').gsub(')', '').gsub( ' ', '').gsub('/', '').strip.first(3) == '018'
      # cliente.empresa_id = 1 if cliente.telefone.gsub('-', '').gsub('(', '').gsub(')', '').gsub( ' ', '').gsub('/', '').strip.first(2) == '17' || cliente.telefone.gsub('-', '').gsub('(', '').gsub(')', '').gsub( ' ', '').gsub('/', '').strip.first(3) == '017'
      # cliente.empresa_id = 1 if cliente.telefone.gsub('-', '').gsub('(', '').gsub(')', '').gsub( ' ', '').gsub('/', '').strip.first(2) == '14' || cliente.telefone.gsub('-', '').gsub('(', '').gsub(')', '').gsub( ' ', '').gsub('/', '').strip.first(3) == '014'

      escritorio = Escritorio.telefone(cliente.telefone).first
      if escritorio.present?
        cliente.escritorio = escritorio
        cliente.telefone = nil
      end

      escritorio = Escritorio.telefone_contato(cliente.telefone).first
      if escritorio.present?
        cliente.escritorio = escritorio
        cliente.telefone = nil
      end

      escritorio = Escritorio.telefone(cliente.telefone2).first
      if escritorio.present?
        cliente.escritorio = escritorio
        cliente.telefone2 = nil
      end

      escritorio = Escritorio.telefone_contato(cliente.telefone2).first
      if escritorio.present?
        cliente.escritorio = escritorio
        cliente.telefone2 = nil
      end

      cliente.rejeitado_rf = false
      cliente.reconsultado = true
      cliente.save!
      puts "#{Time.now} - CNPJ #{cliente.cnpj} reconsultado com sucesso! #{cliente.razao_social}"

      return ''
    rescue Exception => ex
      verify_reconsultas_rf_cliente(cliente)
      puts "#{Time.now} - Erro ao Reconsultar - Exception - CNPJ:#{cliente.cnpj}"
      puts ex.to_s
      return ex.to_s
    end
  end

  def self.qtd_reconsultas_zerado?(cliente)
    cliente.qtd_reconsultas_rf.zero?
  end

  # Atualiza o cliente se caso sua qtd_reconsultas_rf foi ou vai zerada, senão decrementa um na reconsulta
  def self.verify_reconsultas_rf_cliente(cliente)
    cliente.qtd_reconsultas_rf -= 1 unless qtd_reconsultas_zerado?(cliente)

    if qtd_reconsultas_zerado?(cliente)
      cliente.rejeitado_rf = true
      cliente.reconsultado = true
    end

    cliente.save!
  end

  require 'open-uri'

  def self.importar_jucesp_nire(browser, cliente)
    begin
      browser.goto 'https://www.jucesponline.sp.gov.br/pesquisa.aspx'

      until browser.input(id: 'ctl00_cphContent_frmBuscaSimples_txtPalavraChave').exists? do
        sleep 1
      end
      browser.input(id: 'ctl00_cphContent_frmBuscaSimples_txtPalavraChave').send_keys cliente.nire

      browser.input(id: 'ctl00_cphContent_frmBuscaSimples_btPesquisar').click()
      sleep 3

      verificar_captcha_jucesp_empresa browser

      aux = importer_span browser, '//*[@id="ctl00_cphContent_frmPreVisualiza_lblCnpj"]'
      cliente.cnpj = aux.strip.gsub('.', '').gsub('-', '').gsub('/', '').strip

      aux = browser.span(xpath: '//*[@id="ctl00_cphContent_frmPreVisualiza_lblObjeto"]').html[54..(browser.span(xpath: '//*[@id="ctl00_cphContent_frmPreVisualiza_lblObjeto"]').html.size - 8)].split('<br>')
      cnae = Cnae.where('upper(unaccent(descricao)) = upper(unaccent(?))', aux[0].strip).first
      cliente.cnae = cnae if cnae.present?

      cliente.save

      return ''
    rescue Exception => ex
      puts ex.message
      return ex.to_s
    end
  end

  def self.importar_empresas_jucesp_sp(browser, importacao)
    estado = Estado.find_by_sigla 'SP'

    imported = 0
    notimported = 0
    already_exists = 0

    carregar_site browser

    verificar_captcha_jucesp_empresa browser

    hasNext = true
    puts 'Buscando total de empresas'
    total = Nokogiri::HTML(browser.span(id: 'ctl00_cphContent_gdvResultadoBusca_ifbGridView_lblDocCount').html).children.text
    total = total.gsub('.', '')
    importacao.update!({ total: total })
    puts 'Total ' + total

    puts 'Iniciando importacao'
    index = 0
    while hasNext do

      break if total.to_i == 0

      pageCont = 2
      while pageCont <= 16 && (importacao.total - index) != 0 do

        begin
          puts pageCont
          if browser.a(id: "ctl00_cphContent_gdvResultadoBusca_gdvContent_ctl#{pageCont.to_s.rjust(2, '0')}_lbtSelecionar").present?
            puts 'Buscando NIRE'
            begin
              nire = Nokogiri::HTML(browser.a(id: "ctl00_cphContent_gdvResultadoBusca_gdvContent_ctl#{pageCont.to_s.rjust(2, '0')}_lbtSelecionar").html).children.text
            rescue Exception => ex
              nire = Nokogiri::HTML(browser.a(id: "ctl00_cphContent_gdvResultadoBusca_gdvContent_ctl#{pageCont.to_s.rjust(2, '0')}_lbtSelecionar").html).children.text
            end
            if nire.present?
              registro = Cliente.find_by(nire: nire, empresa_id: importacao.empresa_id)

              if (registro.nil?)
                cliente = Cliente.new()

                cliente.nire = nire

                cliente.data_licenca = Date.yesterday
                cliente.data_importacao = Date.yesterday

                puts 'Buscando RazaoSocial'
                begin
                  razaoSocial = Nokogiri::HTML(browser.span(id: "ctl00_cphContent_gdvResultadoBusca_gdvContent_ctl#{pageCont.to_s.rjust(2, '0')}_lblRazaoSocial").html).children.text
                rescue Exception => ex
                  razaoSocial = Nokogiri::HTML(browser.span(id: "ctl00_cphContent_gdvResultadoBusca_gdvContent_ctl#{pageCont.to_s.rjust(2, '0')}_lblRazaoSocial").html).children.text
                end

                cliente.razao_social = razaoSocial

                puts 'Buscando Cidade'
                begin
                  nomeCidade = Nokogiri::HTML(browser.td(xpath: "//*[@id='ctl00_cphContent_gdvResultadoBusca_gdvContent']/tbody/tr[#{pageCont.to_s}]/td[3]").html).children.text
                rescue Exception => ex
                  nomeCidade = Nokogiri::HTML(browser.td(xpath: "//*[@id='ctl00_cphContent_gdvResultadoBusca_gdvContent']/tbody/tr[#{pageCont.to_s}]/td[3]").html).children.text
                end
                cidade = Cidade.where(" upper(unaccent(nome)) = upper(unaccent('#{ nomeCidade }')) and estado_id = #{ estado.id }").limit(1).first
                puts "Cidade= #{ cidade }"
                if cidade.nil?
                  cidade = Cidade.new
                  cidade.nome = I18n.transliterate(nomeCidade)
                  cidade.estado_id = estado.id
                  cidade.save
                end

                cliente.cidade_id = cidade.id
                cliente.importacao_id = importacao.id
                cliente.empresa_id = importacao.empresa_id

                if cliente.save
                  puts 'Cliente importada ' + nire
                  imported += 1
                  GC.start if index % 50 == 0
                else
                  puts "erro ao salvar= #{ cliente.errors.full_messages.to_sentence }"
                end
              else
                puts 'Cliente ja existe ' + nire
                already_exists += 1
              end
            end
          end
        rescue Exception => ex
          puts "ocorreu um erro = #{ ex }"
          pageCont = 17
        end

        pageCont += 1
        index += 1
      end

      verificar_captcha_jucesp_empresa browser

      puts 'FALTA ' + (importacao.total - index).to_s

      hasNext = false if (importacao.total - index) == 0

      if hasNext && importacao.total > 16
        verificar_captcha_jucesp_empresa browser

        if browser.a(id: 'ctl00_cphContent_gdvResultadoBusca_pgrGridView_btrNext_lbtText').present?
          begin
            browser.a(id: 'ctl00_cphContent_gdvResultadoBusca_pgrGridView_btrNext_lbtText').click
          rescue Exception => ex
            browser.a(id: 'ctl00_cphContent_gdvResultadoBusca_pgrGridView_btrNext_lbtText').click
          end

          begin
            sleep 1
          end while browser.span(id: 'ctl00_cphContent_gdvResultadoBusca_qtpLoading_lblMessage').present?
        end

        verificar_captcha_jucesp_empresa browser

      end
    end
    importacao.finalizar_importacao(imported, notimported, already_exists)
  end

  def self.carregar_site(browser)
    browser.goto 'https://www.jucesponline.sp.gov.br/BuscaAvancada.aspx?IDProduto='

    dataImportacao = Date.yesterday

    until browser.text_field(:id => "ctl00_cphContent_frmBuscaAvancada_txtDataAberturaInicio").exists? do
      sleep 1
    end
    diaant = dataImportacao - 4.day
    browser.text_field(id: 'ctl00_cphContent_frmBuscaAvancada_txtDataAberturaInicio').set diaant.strftime("%d/%m/%Y")
    sleep 1

    browser.text_field(id: 'ctl00_cphContent_frmBuscaAvancada_txtDataAberturaFim').set dataImportacao.strftime("%d/%m/%Y")
    sleep 1
    browser.button(id: 'ctl00_cphContent_frmBuscaAvancada_btPesquisar').click
    sleep 5
  end

  def self.verificar_captcha_jucesp_empresa(browser)
    puts 'Verificando se tem captcha'
    sleep 1 unless browser.div(id: 'ctl00_cphContent_frmPreVisualiza_pnlCaptcha').present? || browser.div(id: 'ctl00_cphContent_gdvResultadoBusca_pnlCaptcha').present?

    if browser.div(id: 'ctl00_cphContent_frmPreVisualiza_pnlCaptcha').present? || browser.div(id: 'ctl00_cphContent_gdvResultadoBusca_pnlCaptcha').present?
      puts 'Tem captcha'
      hasResolved = true

      hasResolved = false if browser.span(id: 'ctl00_cphContent_frmPreVisualiza_lblEmpresa').present? || browser.div(id: 'jo_resultado').present?
      captchaId = nil
      while hasResolved
        puts 'Verificando se captcha realmente existe'
        break if browser.span(id: 'ctl00_cphContent_frmPreVisualiza_lblEmpresa').present? || browser.div(id: 'jo_resultado').present?

        sleep 1 unless browser.div(xpath: '//*[@id="formBuscaAvancada"]/table/tbody/tr[1]/td/div/div[1]').img().present?

        img = browser.div(xpath: '//*[@id="formBuscaAvancada"]/table/tbody/tr[1]/td/div/div[1]').img()
        filename = "#{Rails.root.join('tmp').to_s}/current_captcha.png"
        File.open(filename, 'wb') { |file| file.write(img.to_png) }
        puts 'Criado img do captcha'
        client = TwoCaptcha.new('9d2f77abff4cf614d5f1cba28722420d')

        if (!captchaId.blank?)
          puts 'reportando captcha errado'
          client.report!(captchaId)
        end

        puts 'Enviado captcha para decodificar'
        captcha = client.decode(file: File.open(filename, 'rb'))

        if captcha.nil? || captcha.text.blank?
          sleep 1
          browser.input(id: 'ctl00_cphContent_frmPreVisualiza_btEntrar').click if browser.input(id: 'ctl00_cphContent_frmPreVisualiza_btEntrar').present?
          browser.input(id: 'ctl00_cphContent_gdvResultadoBusca_btEntrar').click if browser.input(id: 'ctl00_cphContent_gdvResultadoBusca_btEntrar').present?
          sleep 5
          next
        end

        puts 'Captcha ' + captcha.text
        captchaId = captcha.id
        browser.input(xpath: '//*[@id="formBuscaAvancada"]/table/tbody/tr[1]/td/div/div[2]/label/input').send_keys captcha.text.upcase
        sleep 1
        puts 'Setou captcha no campo'

        browser.input(id: 'ctl00_cphContent_frmPreVisualiza_btEntrar').click if browser.input(id: 'ctl00_cphContent_frmPreVisualiza_btEntrar').present?
        browser.input(id: 'ctl00_cphContent_gdvResultadoBusca_btEntrar').click if browser.input(id: 'ctl00_cphContent_gdvResultadoBusca_btEntrar').present?

        puts 'Aguardando liberar resultados'
        sleep 10

        break if browser.span(id: 'ctl00_cphContent_frmPreVisualiza_lblEmpresa').present? || browser.div(id: 'jo_resultado').present?

      end
      puts 'Captcha resolvido'
    end
  end

  def self.importer_span(browser, xpath)
    begin
      aux = Nokogiri::HTML(browser.span(xpath: xpath).html).children.text
    rescue Exception => ex
      aux = Nokogiri::HTML(browser.span(xpath: xpath).html).children.text
    end
    puts aux
    return aux if aux.present?
    return ''
  end

  def self.importer_td(browser, xpath)
    begin
      aux = Nokogiri::HTML(browser.td(xpath: xpath).html).children.text
    rescue Exception => ex
      aux = Nokogiri::HTML(browser.td(xpath: xpath).html).children.text
    end
    puts aux
    return aux if aux.present?
    return ''
  end

  def self.importer_b(browser, xpath)
    begin
      aux = Nokogiri::HTML(browser.b(xpath: xpath).html).children.text
    rescue Exception => ex
      aux = Nokogiri::HTML(browser.b(xpath: xpath).html).children.text
    end
    puts aux
    return aux if aux.present?
    return ''
  end

  def self.nova_importacao_sefaz(user_id, empresa_id, sigla_estado)
    import = Importacao.new()
    import.data_importacao = Time.now
    import.user_id = user_id
    import.estado = Estado.find_by_sigla sigla_estado
    import.finalizada = false
    import.empresa_id = empresa_id

    import.save!

    return import
  end

  def finalizar_importacao(importado, nao_importado, ja_existente)
    update(importado: importado, nao_importado: nao_importado, ja_existente: ja_existente, finalizada: true);
  end

  def humam_date_import
    data_importacao.strftime("%d/%m/%Y %H:%M") unless data_importacao.nil?
  end

  def self.importar_sefaz_pr(importacao)
    #Cidade.importar_cidades_sefaz_pr

    estado = Estado.find_by_sigla 'PR'

    uri = URI('http://processos.fazenda.pr.gov.br/arquivos/ativos')
    zipped_folder = Net::HTTP.get(uri)

    File.open('ativos.zip', 'wb') do |file|
      file.write(zipped_folder)
    end

    zip_file = Zip::File.open('ativos.zip')
    zip_file.each do |file|
      file.extract() { true }
    end

    csv = open('ativos.txt') { |f| f.read }
    arquivo = CSV.parse(csv, :headers => false)

    imported = 0
    notimported = 0
    already_exists = 0

    importacao.total = arquivo.size
    importacao.save

    arquivo.each_with_index do |row, index|
      cliente = Cliente.new()
      linha = row.to_s.split(';')

      reg = Cliente.find_by(cnpj: linha[1])

      if (reg.nil?)
        cliente.inscricao_estadual = linha[0].gsub("[\"", "")
        cliente.cnpj = linha[1]

        licenca = Date.new(linha[2][0..3].to_i, linha[2][4..6].to_i, 1)
        cliente.data_licenca = licenca
        cliente.data_importacao = importacao.data_importacao
        cliente.situacao = linha[3]

        cidade = Cidade.find_by(codigo: linha[4], estado_id: estado.id)
        #Se não tem cidade, pula o loop
        if cidade.nil?
          notimported += 1
          next
        end

        cliente.cidade_id = cidade.id
        cnae = Cnae.find_by_codigo linha[5].gsub("\"]", "")
        if cnae.nil?
          cnae = Cnae.importar_cnae(linha[5].gsub("\"]", ""))
        end
        cliente.cnae_id = cnae.id
        cliente.importacao_id = importacao.id
        cliente.empresa_id = importacao.empresa_id

        if cliente.save
          puts 'Cliente importada ' + linha[1]
          imported += 1
          GC.start if index % 50 == 0
        else
          puts "erro ao salvar= #{ cliente.errors.full_messages.to_sentence }"
        end
      else
        already_exists += 1
      end
    end
    importacao.finalizar_importacao(imported, notimported, already_exists)
  end

  def empresas_boas
    if empresa_id == 2
      Cliente.select("distinct clientes.*").where(importacao_id: id).cnae_blacklist.completo.count
    elsif empresa_id == 5
      total
    else
      Cliente.select("distinct clientes.*").where(importacao_id: id).cnae_blacklist.completo.para_ligacao.count
    end
  end

  def self.sintegra_sp(browser, cliente)
    begin
      browser.goto 'https://www.cadesp.fazenda.sp.gov.br/Pages/Cadastro/Consultas/ConsultaPublica/ConsultaPublica.aspx'

      until browser.td(class: 'titulo_pagina').exists? do
        sleep 1
      end

      browser.select_list(:id, 'ctl00_conteudoPaginaPlaceHolder_tipoFiltroDropDownList').select_value('2')

      browser.input(id: 'ctl00_conteudoPaginaPlaceHolder_valorFiltroTextBox').send_keys cliente.nire
      sleep 2

      hasResolved = true
      cont = 0

      captchaId = ''
      while hasResolved
        img = browser.img(id: 'ctl00_conteudoPaginaPlaceHolder_imagemDinamica')
        filename = "/var/www/business.gtech.site/shared/public/uploads/current_captcha.png"
        #filename = '/home/alison/current_captcha.png'
        File.open(filename, 'wb') { |file| file.write(img.to_png) }
        client = TwoCaptcha.new('9d2f77abff4cf614d5f1cba28722420d')

        captcha = client.decode(file: File.open(filename, 'rb'))

        if captcha.nil? || captcha.text.blank?
          next
        end

        captchaId = captcha.id

        browser.input(:id => "ctl00_conteudoPaginaPlaceHolder_imagemDinamicaTextBox").send_keys captcha.text.downcase
        sleep 1

        browser.input(id: 'ctl00_conteudoPaginaPlaceHolder_consultaPublicaButton').click()
        sleep 1

        break if browser.table(class: 'consultaFiltrosTable').present?

        cont += 1
      end

      aux = importer_td browser, '//*[@id="aspnetForm"]/table[3]/tbody/tr/td[2]/table/tbody/tr/td[2]/table[1]/tbody/tr[2]/td[2]/table/tbody/tr/td/table/tbody/tr/td/table/tbody/tr/td/table[2]/tbody/tr[3]/td[2]'
      cliente.cnpj = aux.gsub('-', '').gsub('.', '').gsub('/', '')

      cliente.save

      return ''

    rescue Exception => ex
      return ex.to_s
    end
  end

  def self.importar_sefaz_ms(importacao)
    uri = URI('http://arq.sefaz.ms.gov.br/sintegra/cci_resumido.zip')
    zipped_folder = Net::HTTP.get(uri)

    File.open('cci_resumido.zip', 'wb') do |file|
      file.write(zipped_folder)
    end

    zip_file = Zip::File.open('cci_resumido.zip')
    zip_file.each do |file|
      file.extract() { true }
    end

    csv = open('CCI_RESUMIDO.TXT') { |f| f.read }
    arquivo = CSV.parse(csv, :headers => false)

    imported = 0
    notimported = 0
    already_exists = 0

    importacao.total = arquivo.size
    importacao.save

    arquivo.each_with_index do |row, index|
      linha = row[0]

      if linha[28] == '1'
        notimported += 1
        next
      end

      reg = Cliente.find_by(cnpj: linha[0..13])

      if (reg.nil?)
        cliente = Cliente.new()
        cliente.inscricao_estadual = linha[14..27].strip()
        cliente.cnpj = linha[0..13].strip()

        licenca = Date.new(linha[29..32].to_i, linha[33..34].to_i, linha[35..36].to_i)
        cliente.data_licenca = licenca
        cliente.data_importacao = importacao.data_importacao
        cliente.situacao = linha[28]

        estado = Estado.find_by_sigla linha[37..38]
        if estado.nil? || estado.sigla != 'MS'
          notimported += 1
          next
        end

        cliente.importacao_id = importacao.id
        cliente.empresa_id = importacao.empresa_id

        if cliente.save
          puts 'Cliente importada ' + linha[1]
          imported += 1
          GC.start if index % 50 == 0
        else
          puts "erro ao salvar= #{ cliente.errors.full_messages.to_sentence }"
        end
      else
        already_exists += 1
      end
    end
    importacao.finalizar_importacao(imported, notimported, already_exists)
  end

  def self.importar_sefaz_rs(importacao)
    uri = URI('https://www.sefaz.rs.gov.br/ASP/Download/SAT/Cadastro/ICS_Ativo2.zip')
    zipped_folder = Net::HTTP.get(uri)

    File.open('ICS_Ativo2.zip', 'wb') do |file|
      file.write(zipped_folder)
    end

    zip_file = Zip::File.open('ICS_Ativo2.zip')
    zip_file.each do |file|
      file.extract() { true }
    end

    csv = open('ICS_ATIVO2.TXT') { |f| f.read }
    arquivo = CSV.parse(csv, :headers => false)

    imported = 0
    notimported = 0
    already_exists = 0

    importacao.total = arquivo.size
    importacao.save

    arquivo.each_with_index do |row, index|
      linha = row.to_s.split(';')
      reg = Cliente.find_by(cnpj: linha[1])
      if (reg.nil?)
        cliente = Cliente.new
        cliente.cnpj = linha[1]

        cliente.data_importacao = importacao.data_importacao
        cliente.importacao_id = importacao.id
        cliente.empresa_id = importacao.empresa_id

        if cliente.save
          puts 'Cliente importada ' + linha[1]
          imported += 1
          GC.start if index % 50 == 0
        else
          notimported += 1
          puts "erro ao salvar= #{ cliente.errors.full_messages.to_sentence }"
        end
      else
        already_exists += 1
      end
    end
    importacao.finalizar_importacao(imported, notimported, already_exists)
  end

  def self.importar_sefaz_go(importacao)
    ftp = Net::FTP.new('ftp.sefaz.go.gov.br')
    ftp.login
    files = ftp.chdir('sefazgo/')
    ftp.getbinaryfile('ContribuintesAtivos.ZIP', "#{Rails.root.join('tmp').to_s}/contribuintesativos.zip", 1024)
    ftp.close

    Zip::File.open("#{Rails.root.join('tmp').to_s}/contribuintesativos.zip") do |zip_file|
      zip_file.each do |f|
        zip_file.extract(f, "#{Rails.root.join('tmp').to_s}/empresas_go.txt") { true }
      end
    end

    imported = 0
    notimported = 0
    already_exists = 0
    size = 0

    File.open("#{Rails.root.join('tmp').to_s}/empresas_go.txt").each_with_index do |line, index|

      if index.eql? 0
        next
      end

      size += 1

      if line.nil? || !ImportacoesHelper.check_cnpj(line[59..72])
        notimported += 1
        next
      end

      reg = Cliente.find_by(cnpj: line[59..72].strip())

      if (reg.nil?)
        cliente = Cliente.new()
        cliente.inscricao_estadual = line[0..8].strip()
        cliente.cnpj = line[59..72].strip()

        cliente.data_importacao = importacao.data_importacao

        cliente.importacao_id = importacao.id
        cliente.empresa_id = importacao.empresa_id

        if cliente.save
          puts 'Cliente importada ' + cliente.cnpj
          imported += 1
          GC.start if index % 50 == 0
        else
          puts "erro ao salvar= #{ cliente.errors.full_messages.to_sentence }"
          notimported += 1
        end
      else
        already_exists += 1
      end
    end

    importacao.total = size
    importacao.save
    importacao.finalizar_importacao(imported, notimported, already_exists)
  end

  def self.importar_sefaz_ba(importacao)
    imported = 0
    notimported = 0
    already_exists = 0
    size = 0

    File.open("/var/www/business.gtech.site/shared/public/cnpjBA.txt", "r:UTF-8").each_with_index do |row, index|
      if [0].include? index
        next
      end

      cnpj = row.gsub(/\u0000/, '')[0..13].strip

      if cnpj.nil? || cnpj.blank?
        next
      end

      size += 1
      reg = Cliente.find_by(cnpj: cnpj)

      if (reg.nil?)
        cliente = Cliente.new()
        cliente.cnpj = cnpj

        cliente.data_importacao = importacao.data_importacao

        cliente.importacao_id = importacao.id
        cliente.empresa_id = importacao.empresa_id

        if cliente.save
          puts 'Cliente importada ' + cliente.cnpj
          imported += 1
          GC.start if index % 50 == 0
        else
          puts "erro ao salvar= #{ cliente.errors.full_messages.to_sentence }"
        end
      else
        already_exists += 1
      end
    end
    importacao.finalizar_importacao(imported, notimported, already_exists)
  end

  def self.importar_sefaz_mg(importacao)
    imported = 0
    notimported = 0
    already_exists = 0
    size = 0

    File.open("/var/www/business.gtech.site/shared/public/cnpjMG.TXT").each_with_index do |line, index|
      size += 1

      if line.nil? || line[91] == 'N'
        notimported += 1
        next
      end

      reg = Cliente.find_by(cnpj: line[14..27].strip())

      if (reg.nil?)
        cliente = Cliente.new()
        cliente.inscricao_estadual = line[0..12].strip()
        cliente.cnpj = line[14..27].strip()

        cliente.data_importacao = importacao.data_importacao

        cliente.importacao_id = importacao.id
        cliente.empresa_id = importacao.empresa_id

        if cliente.save
          puts 'Cliente importada ' + cliente.cnpj
          imported += 1
          GC.start if index % 50 == 0
        else
          puts "erro ao salvar= #{ cliente.errors.full_messages.to_sentence }"
          notimported += 1
        end
      else
        already_exists += 1
      end
    end
    importacao.total = size
    importacao.save

    importacao.finalizar_importacao(imported, notimported, already_exists)
  end

  def self.importar_sefaz_pe(importacao)
    if Time.now.day <= 15
      time = Time.now - 1.month
      nomeArquivo = "CACEPE_SIMPLIFICADO_#{time.strftime("%Y%m")}-2.zip"
    else
      time = Time.now
      nomeArquivo = "CACEPE_SIMPLIFICADO_#{time.strftime("%Y%m")}-1.zip"
    end

    uri = URI("https://www.sefaz.pe.gov.br/Servicos/sintegra/Download/#{nomeArquivo}")
    zipped_folder = Net::HTTP.get(uri)

    File.open(nomeArquivo, 'wb') do |file|
      file.write(zipped_folder)
    end

    zip_file = Zip::File.open(nomeArquivo)
    zip_file.each do |file|
      file.extract() { true }
    end

    csv = open('CADASTRO_DE_CONTRIBUINTE_SIMPLIFICADO.TXT') { |f| f.read }
    arquivo = CSV.parse(csv, :headers => false)

    imported = 0
    notimported = 0
    already_exists = 0
    size = 0

    arquivo.each_with_index do |line, index|
      line = line[0]

      if index.eql? 0
        next
      else
        size += 1
      end

      if line.nil? || line.size < 30 || line[23..32].strip() != 'ATIVO'
        notimported += 1
        next
      end

      reg = Cliente.find_by(cnpj: line[0..13].strip())

      if (reg.nil?)
        cliente = Cliente.new()
        cliente.inscricao_estadual = line[14..22].strip()
        cliente.cnpj = line[0..13].strip()

        cliente.data_importacao = importacao.data_importacao

        cliente.importacao_id = importacao.id
        cliente.empresa_id = importacao.empresa_id

        if cliente.save
          puts 'Cliente importada ' + cliente.cnpj
          imported += 1
          GC.start if index % 50 == 0
        else
          puts "erro ao salvar= #{ cliente.errors.full_messages.to_sentence }"
          notimported += 1
        end
      else
        already_exists += 1
      end
    end
    importacao.total = size
    importacao.save

    importacao.finalizar_importacao(imported, notimported, already_exists)
  end

  def self.importar_sefaz_es(importacao)
    ftp = Net::FTP.new('ftp.sefaz.es.gov.br')
    ftp.login
    ftp.getbinaryfile('/Sintegra/Sintegra.zip', "#{Rails.root.join('tmp').to_s}/contribibES.zip", 1024)
    ftp.close

    Zip::File.open("#{Rails.root.join('tmp').to_s}/contribibES.zip") do |zip_file|
      zip_file.each do |f|
        zip_file.extract(f, "#{Rails.root.join('tmp').to_s}/cnpjES.txt") { true }
      end
    end

    imported = 0
    notimported = 0
    already_exists = 0
    size = 0

    File.open("#{Rails.root.join('tmp').to_s}/cnpjES.txt").each_with_index do |line, index|

      next if line.nil? || !(line[-4..line.size].strip().eql? "ES")

      size += 1

      cnpj = line[0..13].strip()
      if !ImportacoesHelper.check_cnpj(cnpj)
        notimported += 1
        next
      end

      reg = Cliente.find_by(cnpj: cnpj)

      if (reg.nil?)
        cliente = Cliente.new()
        cliente.cnpj = cnpj

        cliente.data_importacao = importacao.data_importacao
        cliente.importacao_id = importacao.id
        cliente.empresa_id = importacao.empresa_id

        if cliente.save
          puts 'Cliente importada ' + cliente.cnpj
          imported += 1
          GC.start if index % 50 == 0
        else
          puts "erro ao salvar= #{ cliente.errors.full_messages.to_sentence }"
          notimported += 1
        end
      else
        already_exists += 1
      end
    end

    importacao.total = size
    importacao.save
    importacao.finalizar_importacao(imported, notimported, already_exists)
  end

  def self.importar_sefaz_rj(importacao)
    uri = URI('http://www.fazenda.rj.gov.br/sefaz/content/conn/UCMServer/uuid/dDocName%3a3076284')
    zipped_folder = Net::HTTP.get(uri)

    File.open('rjcontrib.zip', 'wb') do |file|
      file.write(zipped_folder)
    end

    zip_file = Zip::File.open('rjcontrib.zip')
    zip_file.each do |file|
      file.extract() { true }
    end

    csv = open('RJCONTRIB.TXT') { |f| f.read }
    arquivo = CSV.parse(csv, :headers => false)

    imported = 0
    notimported = 0
    already_exists = 0
    size = 0

    arquivo.each_with_index do |line, index|
      next if line.nil?
      line = line[0]
      size += 1

      cnpj = line[0..13].strip()
      if !ImportacoesHelper.check_cnpj(cnpj)
        notimported += 1
        next
      end

      reg = Cliente.find_by(cnpj: cnpj)

      if (reg.nil?)
        cliente = Cliente.new()
        cliente.cnpj = cnpj

        cliente.data_importacao = importacao.data_importacao
        cliente.importacao_id = importacao.id
        cliente.empresa_id = importacao.empresa_id

        if cliente.save
          puts 'Cliente importada ' + cliente.cnpj
          imported += 1
          GC.start if index % 50 == 0
        else
          puts "erro ao salvar= #{ cliente.errors.full_messages.to_sentence }"
          notimported += 1
        end
      else
        already_exists += 1
      end
    end
    importacao.finalizar_importacao(imported, notimported, already_exists)

  end

  def self.importar_sefaz_pb(importacao)
    imported = 0
    notimported = 0
    already_exists = 0
    size = 0

    File.open("#{Rails.root.join('tmp').to_s}/cnpjPB.txt", "r:UTF-8").each_with_index do |line, index|
      next if line.nil?
      linha = line.encode("UTF-8", invalid: :replace, replace: "").to_s.split("\;")
      size += 1

      if !ImportacoesHelper.check_cnpj(linha[1]) || !(linha[3].eql? "SIMPLES NACIONAL")
        notimported += 1
        next
      end
      reg = Cliente.find_by(cnpj: linha[1])

      if reg.nil?
        cliente = Cliente.new()
        cliente.cnpj = linha[1]

        cliente.data_importacao = importacao.data_importacao
        cliente.importacao_id = importacao.id
        cliente.empresa_id = importacao.empresa_id

        if cliente.save
          puts 'Cliente importada ' + cliente.cnpj
          imported += 1
          GC.start if index % 50 == 0
        else
          puts "erro ao salvar= #{ cliente.errors.full_messages.to_sentence }"
          notimported += 1
        end
      else
        already_exists += 1
      end
    end
    importacao.update(total: size)
    importacao.finalizar_importacao(imported, notimported, already_exists)
  end

  def self.importar_sefaz_ce(importacao)
    file = open('http://servicos.sefaz.ce.gov.br/internet/download/sintegra/contribuinte.txt')
    imported = 0
    notimported = 0
    already_exists = 0
    size = 0

    file.each_line do |line|
      next if line.nil?
      size += 1
      linha = line.to_s.split(",")

      if !ImportacoesHelper.check_cnpj(linha[0].strip)
        notimported += 1
        next
      end
      reg = Cliente.find_by(cnpj: linha[0].strip)

      if reg.nil?
        cliente = Cliente.new()
        cliente.cnpj = linha[0].strip

        cliente.data_importacao = importacao.data_importacao
        cliente.importacao_id = importacao.id
        cliente.empresa_id = importacao.empresa_id

        if cliente.save
          puts 'Cliente importada ' + cliente.cnpj
          imported += 1
          GC.start if size % 50 == 0
        else
          puts "erro ao salvar= #{ cliente.errors.full_messages.to_sentence }"
          notimported += 1
        end
      else
        already_exists += 1
      end
    end
    importacao.update(total: size)
    importacao.finalizar_importacao(imported, notimported, already_exists)
  end

  def self.importar_sefaz_ma(importacao)
    imported = 0
    notimported = 0
    already_exists = 0
    size = 0

    File.open("/var/www/business.gtech.site/shared/public/cnpjMA.txt", "r:UTF-8").each_with_index do |line, index|
      next if line.nil?
      size += 1
      linha = line.encode("UTF-8", invalid: :replace, replace: "");

      cnpj = linha[0..13].strip
      if !ImportacoesHelper.check_cnpj(cnpj)
        notimported += 1
        next
      end
      reg = Cliente.find_by(cnpj: cnpj)

      if reg.nil?
        cliente = Cliente.new()
        cliente.cnpj = cnpj

        cliente.data_importacao = importacao.data_importacao
        cliente.importacao_id = importacao.id
        cliente.empresa_id = importacao.empresa_id

        if cliente.save
          puts 'Cliente importada ' + cliente.cnpj
          imported += 1
          GC.start if size % 50 == 0
        else
          puts "erro ao salvar= #{ cliente.errors.full_messages.to_sentence }"
          notimported += 1
        end
      else
        already_exists += 1
      end
    end
    importacao.update(total: size)
    importacao.finalizar_importacao(imported, notimported, already_exists)
  end

  def generate_csv_file
    clientes = Cliente.select("distinct clientes.*").where(importacao_id: id).cnae_blacklist.completo.para_ligacao

    attributes = ["First Name", "E-mail Address", "Primary Phone", "Other Phone"]

    CSV.generate(headers: true) do |csv|
      csv << attributes

      clientes.each do |cliente|
        csv << [cliente.razao_social, (cliente.email.present? ? cliente.email : nil), (cliente.telefone.present? ? cliente.telefone : nil), (cliente.telefone2.present? ? cliente.telefone2 : nil)]
      end
    end
  end

  def self.importar_outras_empresas
    # clientes = Cliente.where('cnpj is not null and (razao_social is null or endereco is null) and rejeitado_rf is false').order('data_importacao asc').limit(1000)
    clientes = Cliente.where("empresa_id in (3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21) and data_importacao > '2021-10-01'").order('id desc')
    clientes.each_with_index do |cliente, index|
      if !cliente.cnpj.blank?
        puts "Importado #{index + 1}/#{clientes.size}"
        begin
          response = getResponseAPI cliente.cnpj, 11000
          if response.nil?
            next
          end

          if response['status'] != 'OK'
            next
          end

          send_empresa_pro_vendas(response, cliente.cnpj)
        rescue Exception => ex
          puts ex
        end
      end
    end
  end

  def self.send_empresa_pro_vendas(empresa, cnpj)
    begin
      response = RestClient.post("http://api.provendas.gtech.site/prospects", empresa, nil)
      response = JSON.parse(response)

      if response && response["id"].present?
        puts "CNPJ: #{ cnpj}   -  ID: #{response["id"]}, Data #{response["data_abertura"]}, Ultima atualizacao: #{response["ultima_atualizacao"]}"
      else
        puts "CNPJ: #{ cnpj} - ERRP"
      end

    rescue Exception => ex
      puts ex
    end
  end

  def self.send_empresa_pro_vendas_cnpj(cnpj)
    begin
      list = Array.new
      list << { "cnpj": cnpj }
      RestClient.post("http://api.provendas.gtech.site/prospects/importar_pacote_cnpj", { list: list.to_json })
    rescue Exception => ex
      puts ex
    end
  end

  def self.importar_empresas_pro_vendas
    clientes = Cliente.where(empresa: 1).order('id').offset(999).limit(10000)
    clientes.each_with_index do |cliente, index|
      puts "Enviando #{clientes.size}/#{index}"
      list = Array.new
      list << { "cnpj": cliente.cnpj }
    end
    begin
      teste = RestClient.post("https://api.provendas.gtech.site/prospects/importar_pacote_cnpj", { list: list.to_json })
      # teste = RestClient.post("http://localhost:3000/prospects/importar_pacote_cnpj", {list: list.to_json})
      sleep 1
    rescue Exception => ex
      puts ex
    end
  end

  def self.importar_empresas_intervalo(numero_inicial, numero_final)
    # 45543859
    # 45544859
    min = numero_inicial
    max = numero_final

    while min <= max
      cnpj = gerarCnpj(min)
      if BRDocuments::CNPJ.valid?(cnpj)
        cliente = Cliente.where(cnpj: cnpj).limit(1).first
        if cliente.nil?
          Cliente.create(cnpj: cnpj, empresa_id: 20)
          ImporterCnpjWorker.perform_async(cnpj)
        elsif cliente.endereco.nil?
          ImporterCnpjWorker.perform_async(cnpj)
        end
      end
      min += 1
    end
  end

  def self.reconsultar_empresas(clientes)
    invalidos = 0
    for cliente in clientes
      if !cliente.nil? && BRDocuments::CNPJ.valid?(cliente.cnpj)
        ReconsultarCnpjWorker.perform_async(cliente.cnpj)
      else
        puts "Cliente Invalido CNPJ: #{cliente.cnpj}"
        invalidos = invalidos + 1
        cliente.reconsultado = true
      end
      cliente.save
    end
    return invalidos
  end

  def self.gerarCnpj(sequencial)
    cnpj = sequencial.to_s + '0001'
    digitos = BRDocuments::CNPJ.calculate_verify_digits(cnpj)
    return cnpj + digitos[0].to_s + digitos[1].to_s
  end

  def self.create_browser
    prefs = {
      plugins: {
        always_open_pdf_externally: true
      }
    }
    prefes = {
      prompt_for_download: false,
      default_directory: Rails.root.join('tmp').to_s
    }
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_preference(:download, prefes)
    browser = Watir::Browser.new :chrome, prefs: prefs, options: options, :switches => ['--ignore-certificate-errors']
    browser
  end

  def self.connect_whatsapp(numero_telefone)
    browser = create_browser
    browser.goto 'https://web.whatsapp.com/'

    browser.header(class: '_1G3Wr').wait_until_present(300)

    numero_whatsapp = WhatsappNumero.where(numero: numero_telefone).update_or_create({numero: numero_telefone, status: 'AGUARDANDO'})
    status = true
    while status
      begin
        #SE NUMERO ESTA AGUARDADANDO, ENTRA EM LOOP ATÈ ENTRAR ALGUMA NOVA CAMPANHA
        if numero_whatsapp.status.eql? 'AGUARDANDO'
          campanha = Campanha.find numero_whatsapp.campanha_id if numero_whatsapp.campanha_id.present?
          campanha = get_campanha_aguardando(browser, numero_whatsapp.numero) if campanha.nil?
          numero_whatsapp.update(status: 'ANDAMENTO', campanha: campanha) if campanha.present?
        end

        #SE AQUI, ALGUMA CAMPANHA APARECEU
        if campanha.present?
          campanha.update(status: 'ANDAMENTO')
          numero_whatsapp.update(status: 'ANDAMENTO')
          texto = campanha.message
          #Busca todos os envios
          envios = CampanhaEnvio.where(campanha: campanha, status: 'AGUARDANDO')
          enviar_whatsapp_campanha(browser, envios, campanha, texto, campanha.tempo_espera.present? ? campanha.tempo_espera : 25, numero_whatsapp)

          #Busca com erros para reenvio
          #envios = CampanhaEnvio.where(campanha: campanha, status: 'ERROR')
          #enviar_whatsapp_campanha(browser, envios, campanha, texto, campanha.tempo_espera.present? ? campanha.tempo_espera : 25)

          qtd_error = CampanhaEnvio.where(campanha: campanha, status: 'ERROR').count
          qtd_ignorado = CampanhaEnvio.where(campanha: campanha, status: 'IGNORADO').count
          qtd_enviado = CampanhaEnvio.where(campanha: campanha, status: 'ENVIADO').count
          campanha.update(status: 'FINALIZADO', qtd_enviado: qtd_enviado, qtd_erros: qtd_error, qtd_ignorado: qtd_ignorado)
          numero_whatsapp.update(status: 'AGUARDANDO', campanha: nil)
          campanha = nil
        end

        sleep 120
        #browser.goto 'https://web.whatsapp.com/'
        #browser.header(class: '_1G3Wr').wait_until_present(240)
      rescue Exception => ex
        numero_whatsapp.update(status: 'DESCONECTADO')
        puts ex
        status = false
      end
    end
  end

  def self.enviar_whatsapp_campanha(browser, envios, campanha, texto, tempo_espera, numero_whatsapp)
    envios.each_with_index do |envio, index|
      puts "Enviando #{index}/#{envios.size}"
      begin
        numero_whatsapp.reload
        next if numero_whatsapp.banido?
        #byebug
        #Verifica se esse numero
        envCamp = CampanhaEnvio.joins(:campanha).where("campanha_envios.numero = ? and campanha_envios.status in ('ENVIADO', 'IGNORADO') and campanhas.tipo = ? ", envio.numero, campanha.tipo).first

        if envCamp.present? || ((campanha.tipo.eql? 'CAPTACAO') && envio.cliente.status_empresa > 1)
          envio.update(status: 'IGNORADO')
          next
        end

        browser.goto "https://wa.me/#{envio.numero}?text=" + texto

        if browser.alert.exists?
          browser.alert.ok
        end

        browser.a(id: 'action-button').wait_until_present(30)
        browser.a(id: 'action-button').when_enabled(15).click

        browser.a(xpath: '//*[@id="fallback_block"]/div/div/a').wait_until_present(30)
        browser.a(xpath: '//*[@id="fallback_block"]/div/div/a').click

        sleep 15
        sleep tempo_espera if browser.div(xpath: '//*[@id="app"]/div[1]/span[2]/div[1]/span/div[1]/div/div/div/div/div[1]').exists?
        if browser.div(xpath: '//*[@id="app"]/div[1]/span[2]/div[1]/span/div[1]/div/div/div/div/div[1]').exists? &&
          (browser.div(xpath: '//*[@id="app"]/div[1]/span[2]/div[1]/span/div[1]/div/div/div/div/div[1]').text.eql? 'O número de telefone compartilhado através de url é inválido.')
          envio.update(status: 'IGNORADO')
          next
        end

        browser.button(xpath: '//*[@id="main"]/footer/div[1]/div/span[2]/div/div[2]/div[2]/button').wait_until_present(120)
        sleep 5
        browser.button(xpath: '//*[@id="main"]/footer/div[1]/div/span[2]/div/div[2]/div[2]/button').when_enabled(30).click

        envio.update(status: 'ENVIADO')
        sleep tempo_espera
      rescue Exception => e
        puts e
        envio.update(status: 'ERROR')
      end
    end
  end

  def self.get_campanha_aguardando(browser, numero_telefone)
    campanha = nil
    while campanha.nil?
      #begin
        sleep 120
      #  browser.goto 'https://web.whatsapp.com/'
      #  browser.header(class: '_1G3Wr').wait_until_present(240)
        browser.exists?
        puts "Aguardando campanha"
        campanha = Campanha.where(numero: numero_telefone, status: 'AGUARDANDO').first
      #rescue Exception => ex
      #  puts "Erro ao buscar campanha"
      #  puts ex
      #  return nil
      #end
    end
    campanha
  end

  def self.atualizar_clientes_da_fila_empresa
    empresas = Empresa.ativas
    empresas.each do |empresa|
      atualizar_clientes_por_empresa(empresa.id)
    end
  end

  def self.atualizar_clientes_por_empresa(empresa_id)
    clientes = Cliente.select('clientes.cnpj')
      .joins(:fila_empresa)
      .where("fila_empresas.empresa_id = #{empresa_id}")
      .pluck(:cnpj)

    clientes.each do |cnpj|
      ReconsultarCnpjWorker.perform_async(cnpj)
    end
  end

  def self.telefone_zerado?(telefone)
    ddd_zerado = /^\(0\)/
    telefone.match(ddd_zerado)
  end

  def self.telefone_converter(telefone)
    if telefone.present? && !telefone_zerado?(telefone)
      telefone = telefone.gsub(/\D/, '')
      if telefone.size < 11
        telefone = telefone[0..1] + "9" + telefone[2..-1]
      end
      if telefone.size == 11
        telefone = telefone.gsub(/(\d{2})(\d{4,})(\d{4})/, '(\1)\2-\3')
      end
      telefone= telefone.gsub(/(\(\d{2}\)\d{4})(\d{4})/, '\1-\2')
    end
  end

  def self.create_campanha(empresa_id, job, quantidade, offset, numero_telefone, tempo_espera, agendado_at, tempo_total, tipo_disparo, is_resposta_automatica, tempo_ocultacao, abordagem_inicial_especifica, abordagem_resposta_especifica, palavra_chave_especifica)
    ActiveRecord::Base.transaction do
      begin
        campanha = Campanha.new_campanha(
          quantidade,
          empresa_id,
          job,
          'CAPTACAO',
          numero_telefone,
          tempo_espera,
          agendado_at,
          tempo_total,
          tipo_disparo,
          is_resposta_automatica,
          (abordagem_inicial_especifica.present? ? true : false),
          (abordagem_resposta_especifica.present? ? true : false)
        )
        ordem_abordagem_inicial = nil
        ordem_abordagem_resposta = nil

        filas = FilaEmpresa.where(empresa_id: empresa_id, numero_fila: job).order('id').offset(offset).limit(quantidade)
        abordagens_respostas = AbordagemInicial.order(fila: :asc).where(ativa: true, tipo: 'RESPOSTA')
        abordagens_iniciais = AbordagemInicial.order(fila: :asc).where(ativa: true, tipo: 'CAPTACAO')
        mensagem_notificacao = MensagemNotificacao.find_by(tipo: 'INTERESSE', ativo: true)
        filas.each do |fila|
          cliente = fila.cliente
          fila.destroy
          telefone = (cliente.telefone.present? ? cliente.telefone : (cliente.telefone2.present? ? cliente.telefone2 : nil))
          if telefone.present? && !telefone_zerado?(telefone)
            telefone = telefone.gsub(/\D/, '')
            if (empresa_id.to_i.eql? 2) && telefone.size < 11
              telefone = telefone[0..1] + "9" + telefone[2..-1]
            end
            telefone = "55" + telefone
          
            ((!ordem_abordagem_inicial.nil?) && (ordem_abordagem_inicial < abordagens_iniciais.length)) ? ordem_abordagem_inicial += 1 : ordem_abordagem_inicial = 1
            ((!ordem_abordagem_resposta.nil?) && (ordem_abordagem_resposta < abordagens_respostas.length)) ? ordem_abordagem_resposta += 1 : ordem_abordagem_resposta = 1

            abordagemInicial = abordagens_iniciais.find { |abordagem| abordagem.fila == ordem_abordagem_inicial && abordagem.ativa && abordagem.tipo == 'CAPTACAO' }
            abordagemResposta = abordagens_respostas.find { |abordagem| abordagem.fila == ordem_abordagem_resposta && abordagem.ativa && abordagem.tipo == 'RESPOSTA' }
            texto = campanha.is_abordagem_inicial_especifica ? abordagem_inicial_especifica : abordagemInicial.texto

            whatsappUsuario = WhatsappNumero.where(numero: numero_telefone).first
            if whatsappUsuario.present?
              # Substituição de variáveis da string
              texto = AbordagemInicial.ajuste_usuario(texto, whatsappUsuario.user&.name)
              texto = AbordagemInicial.ajuste_saudacao(texto)
              texto = AbordagemInicial.ajuste_empresa(texto, cliente.razao_social)
            end

            if campanha.is_resposta_automatica && abordagemResposta && abordagemResposta.tipo == 'RESPOSTA'
              abordagemRespostaTexto = campanha.is_abordagem_resposta_especifica ? abordagem_resposta_especifica : abordagemResposta.texto
              abordagemRespostaTexto = AbordagemInicial.ajuste_empresa(abordagemRespostaTexto, cliente.razao_social)
            end

            whatsappUsuario.update!(is_ocultado: false, tempo_ocultacao: tempo_ocultacao ? tempo_ocultacao : nil)
            destinatarios = mensagem_notificacao.gzap_usuarios.map { |a| a.destinatarios }.flatten.uniq

            attr_campanha_envio = {
              cliente: cliente,
              numero: telefone,
              abordagem_inicial_id: campanha.is_abordagem_inicial_especifica ? nil : abordagemInicial.id,
              message: texto,
              status: 'AGUARDANDO',
              resposta_automatica_message: campanha.is_resposta_automatica && abordagemRespostaTexto ? abordagemRespostaTexto : nil,
              intervalo_resposta_automatica: abordagemResposta ? abordagemResposta.intervalo_resposta_automatica : nil,
              campanha: campanha,
              mensagem_notificacao: mensagem_notificacao.mensagem,
              destinatarios_notificacao: destinatarios,
              palavra_chave_resposta: palavra_chave_especifica.present? && campanha.is_resposta_automatica ? palavra_chave_especifica : abordagemResposta&.palavra_chave_validacao.present? ? abordagemResposta.palavra_chave_validacao : nil
            }

            CampanhaEnvio.create(attr_campanha_envio)
          end
        end
        campanha.update(status: 'AGUARDANDO')
        campanha
      rescue => exception
        raise ActiveRecord::Rollback
      end
    end
  end

  def self.create_campanha_personalizada(clientes, numero_telefone, tipo, adicionarNove, tempo_espera, job, empresa_id)
    campanha = Campanha.new_campanha(clientes.size, empresa_id, job, tipo, numero_telefone, tempo_espera)
    clientes.each do |cliente|
      telefone = (cliente.telefone.present? ? cliente.telefone : (cliente.telefone2.present? ? cliente.telefone2 : nil))
      if telefone.present?
        telefone = telefone.gsub(/\D/, '')
        if adicionarNove && telefone.size < 11
          telefone = telefone[0..1] + "9" + telefone[2..-1]
        end
        telefone = "55" + telefone
        CampanhaEnvio.create(cliente: cliente, numero: telefone, status: 'AGUARDANDO', campanha: campanha)
      end
    end
    campanha.update(status: 'AGUARDANDO')
    campanha
  end

  def self.reprocessar_importacoes_do_dia
    importacoes = Importacao.where('data_importacao::date = ?', Time.now.to_date)
    importacoes.each do |importacao|
      FilaEmpresa.reprocessar_fila_empresa(importacao.id, importacao.empresa_id, nil) if importacao.total.present? && importacao.total > 0
    end
  end

  def self.reimportar_empresas
    clientes = Cliente.where("empresa_id = 20 and endereco is null and cnpj is not null and created_at > '2022-09-15'").order('id desc')
    clientes.each do |cliente|
      ImporterCnpjWorker.perform_async(cliente.cnpj)
    end
  end

  def self.incluir_clientes_importacao(empresa_id)
    puts 'Iniciando reprocessamento de fila'
    clientes = Array.new
  
    cliFila = Cliente.select('distinct clientes.*')
      .joins('inner join fila_empresas on fila_empresas.cliente_id = clientes.id', 'inner join cnaes cnae on cnae.id = clientes.cnae_id')
      .where('fila_empresas.empresa_id = ? and fila_empresas.numero_fila in (0,1,2,3,4)', empresa_id)
      .where("cnae.blacklist = false AND (clientes.data_licenca between current_date - interval '9 months' and current_date)")
    puts "cliFila: #{cliFila.count}"
    clientes.push(*cliFila) if cliFila.count > 0

    cliImportacao = Cliente.select("distinct clientes.*")
      .para_ligacao
      .cnae_blacklist
      .completo
      .where(empresa_id: empresa_id)
      .joins('left join fila_empresas on fila_empresas.cliente_id = clientes.id', 'inner join cnaes cnae on cnae.id = clientes.cnae_id')
      .joins('left join fila_empresas on fila_empresas.cliente_id = clientes.id', 'inner join cnaes cnae on cnae.id = clientes.cnae_id')
      .where('fila_empresas.id IS NULL')
      .where("cnae.blacklist = false AND (clientes.data_licenca between current_date - interval '9 months' and current_date)")
      .to_a

    puts "cliImportacao: #{cliImportacao.count}"
    clientes.push(*cliImportacao) if cliImportacao.count > 0
  
    puts "Clientes final: #{clientes.count}"
  
    FilaEmpresa.where(empresa_id: empresa_id).where('numero_fila not in (11,12,13,5)').destroy_all
    clientesFiltrados = Array.new
    clientes.each do |cli|
      if cli.present? && !cli.fila_empresa.present? && cli.status.nil? && cli.ligacoes.first.nil? && cli.campanha_envios.first.nil?
        clientesFiltrados << cli
      end
    end
  
    puts "Qtd de Clientes Filtrados: #{clientesFiltrados.count}"
    job0 = Array.new
    job1 = Array.new
    job2 = Array.new
    job3 = Array.new
    job4 = Array.new
  
    FilaEmpresa.processar_jobs_0_1_2_3_4(clientesFiltrados, job0, job1, job2, job3, job4)
    puts "Criando fila job0: #{job0.count} job1: #{job1.count}, job2: #{job2.count}, job3: #{job3.count} job4: #{job4.count}"
  
    FilaEmpresa.criar_fila(job0, 0, empresa_id)
    FilaEmpresa.criar_fila(job1, 1, empresa_id)
    FilaEmpresa.criar_fila(job2, 2, empresa_id)
    FilaEmpresa.criar_fila(job3, 3, empresa_id)
    FilaEmpresa.criar_fila(job4, 4, empresa_id)
  end

  def self.importacao_em_massa(qtd)
    empresa = Empresa.find 1
    qtd_final = (empresa.sequencia_cnpj + qtd)
    importar_empresas_intervalo empresa.sequencia_cnpj, qtd_final
    empresa.update(sequencia_cnpj: qtd_final)
  end

  def self.processar_importacoes_em_massa
    GerarMultiplasImportacoesEmMassaWorker.perform_async(10000)
  end
end