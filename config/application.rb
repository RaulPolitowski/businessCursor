require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module BusinessManager
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    #
    #
    config.active_record.raise_in_transactional_callbacks = true

    config.i18n.available_locales = [:en, :"pt-BR"]
    config.i18n.default_locale = :"pt-BR"


    
    config.time_zone = 'Brasilia'
    config.active_record.default_timezone = :local
    config.active_record.time_zone_aware_attributes = false

    config.assets.precompile += [ 'dashboards.css', 'importacoes.css', 'cnaes.css',  'sistemas.css', 'pacotes.css', 'empresas.css', 'status.css', 'escritorios.css',
                                  'users.css', 'parametros.css', 'ligacoes.css', 'agendamentos.css', 'tipo_agendamentos.css', 'clientes.css', 'permissoes.css',
                                  'cidades.css', 'formaspagamento.css', 'propostas.css', 'agendamento_retornos.css', 'lembretes.css', 'tipo_fechamentos.css',
                                  'negociacoes.css', 'implantacoes.css', 'acompanhamentos.css', 'relatorios.css', 'auditoria_desistencias.scss', 'perguntas.scss',
                                  'historico_cliente.css', 'contratos.css', 'solicitacao_bancos.scss', 'solicitacao_desistencias.scss', 'solicitacao_desistencia_externo.scss',
                                  'abordagem_iniciais.scss', 'solicitacao_banco_externo.css', 'servicos.css', 'setores.css', 'satisfacao.css', 'satisfacao_gruber.scss', 'campanhas.css',
                                  'whatsapp_numeros.css', 'receitaws_contas.css', 'loja_itens.css', 'mensagem_notificacoes.css', 'numero_notificacoes.css', 'gzap_usuarios.css',
                                  'dashboards/desistencias.css'
    ]

    config.assets.precompile += [ 'dashboards.js', 'importacoes.js', 'cnaes.js', 'sistemas.js', 'pacotes.js', 'empresas.js', 'status.js', 'escritorios.js', 'users.js',
                                  'parametros.js', 'ligacoes.js', 'agendamentos.js', 'locale/pt-br.js', 'tipo_agendamentos.js', 'clientes.js', 'permissoes.js',
                                  'cidades.js', 'formaspagamento.js', 'propostas.js', 'agendamento_retornos.js', 'lembretes.js', 'relatorios_ligacoes.js',
                                  'dashboards_ligacoes.js', 'tipo_fechamentos.js', 'negociacoes.js', 'implantacoes.js', 'acompanhamentos.js',
                                  'acompanhamentos_index.js', 'implantacoes_index.js', 'modal_propostas.js', 'relatorios.js', 'relatorios_resumo.js',
                                  'agendamento_retornos_index.js', 'agendamento_retornos_retornos_acompanhamento.js', 'auditoria_desistencias.js',
                                  'relatorios_projecao_clientes.js', 'relatorios_primeira_mensalidade.js', 'relatorios_negociacoes.js', 'perguntas.js',
                                  'agendamento_retornos_retornos_implantacao.js', 'historico_cliente.js', 'relatorios_pesquisa_satisfacao.js',
                                  'relatorios_analise_vendedor.js', 'relatorios_analise_pci.js', 'relatorios_analise_cliente.js', 'relatorios_periodo_inertes.js','contratos.js',
                                  'relatorios_comissionamento_mensalidades.js', 'contratos.js', 'solicitacao_bancos.js', 'relatorios_analise_desistencia.js', 'solicitacao_desistencias.js',
                                  'solicitacao_desistencia_externo.js', 'abordagem_iniciais.js', 'solicitacao_banco_externo.js', 'servicos.js', 'setores.js', 'satisfacao.js', 'satisfacao_gruber.js',
                                  'campanhas.js', 'whatsapp_numeros.js', 'receitaws_contas.js', 'loja_itens.js', 'mensagem_notificacoes.js', 'numero_notificacoes.js', 'gzap_usuarios.js',
                                  'dashboards/desistencias.js'
    ]

  end
end
