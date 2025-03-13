desc 'importar empresas'
task importar_pr: :environment do
  Importacao.criar_importacao_pr()
end

desc 'importar sp'
task importar_sp: :environment do
  Importacao.criar_importar_sp()
end

desc 'Importar MS'
task importar_ms: :environment do
  Importacao.criar_importacao_ms()
end

desc 'importar BA'
task importar_ba: :environment do
  Importacao.criar_importacao_ba();
end

desc 'importar RS'
task importar_rs: :environment do
  Importacao.criar_importacao_rs();
end

desc 'importar GO'
task importar_go: :environment do
  Importacao.criar_importacao_go();
end

desc 'importar MG'
task importar_mg: :environment do
  Importacao.criar_importacao_mg();
end

desc 'importar PB'
task importar_pb: :environment do
  Importacao.criar_importacao_pb();
end

desc 'importar PE'
task importar_pe: :environment do
  Importacao.criar_importacao_pe();
end

desc 'importar ES'
task importar_es: :environment do
  Importacao.criar_importacao_es();
end

desc 'importar RJ'
task importar_rj: :environment do
  Importacao.criar_importacao_rj();
end

desc 'importar MA'
task importar_ma: :environment do
  Importacao.criar_importacao_ma();
end

desc 'importar CE'
task importar_ce: :environment do
  Importacao.criar_importacao_ce();
end

desc 'Reajustar fila SP'
task reajustar_filas: :environment do
  FilaEmpresa.reajustar_filas()
end

desc 'Importar CPF SP'
task importar_cpf_job3_sp: :environment do
  Importacao.importar_cpf_job_3_sp()
end

task processar_limbo: :environment do
  Implantacao.alterar_empresas_limbo()
end

task registrar_inicio_controle: :environment do
  ControleJob.registrar_inicio_controle()
end

task registrar_fim_controle: :environment do
  ControleJob.registrar_fim_controle()
end

task registrar_empresas_inertes: :environment do
  PeriodoInerte.verificar_empresas_inertes()
end

task registrar_pesquisas: :environment do
  Pesquisa.registrar_pesquisas();
end

task importar_outras_empresas: :environment do
  Importacao.importar_outras_empresas()
end

task finalizar_notificacoes: :environment do
  Notificacao.finalizar_notificacoes()
end

task atualizar_campanhas: :environment do
  WhatsappBotService.new.atualizar_campanhas
end

task gerar_fila: :environment do
  DistribuirFilaCentroDistribuicao.new(empresa_id: nil, estado_id: nil).call
end

task atualizar_numeros_ocultos: :environment do
  WhatsappNumero.atualizar_numeros_ocultos
end

task reprocessar_todas_filas: :environment do
  FilaEmpresa.reprocessar_todas_filas
end

task recalcular_controle: :environment do
  ControleJob.recalcular_controle
end

task remover_controle: :environment do
  ControleJob.remover_controle
end

task reconsultar_empresas_recentes: :environment do
  clientes = Cliente.where("reconsultado is false and razao_social is null and created_at between CURRENT_DATE - interval '5 months' and CURRENT_DATE").where.not(cnpj: nil).order(created_at: :asc).limit(10000)
  total_invalidos = Importacao.reconsultar_empresas clientes
  puts "total: #{clientes.size}, invalidos: #{total_invalidos}"
end

task :incluir_clientes_importacao, [:empresa_id] => :environment do |t, args|
  empresa_id = args[:empresa_id] || 1
  Importacao.incluir_clientes_importacao(empresa_id)
end

task reconsultar_cliente_da_fila_empresa: :environment do
  Importacao.atualizar_clientes_da_fila_empresa
end

task gerar_importacao_massa: :environment do
  Importacao.processar_importacoes_em_massa
end