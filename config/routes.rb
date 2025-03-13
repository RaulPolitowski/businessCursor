BusinessManager::Application.routes.draw do

  resources :gzap_usuarios do
    member do
      post 'ativar_desativar'
    end
  end

  resources :numero_notificacoes, except: [:show, :destroy] do
    collection do
      post ':numero/desconectar_numero', action: :desconectar_numero, as: :desconectar_numero
    end
  end

  post 'whatsapp_numeros/:numero/conectar_numero', to: 'whatsapp_numeros#conectar_numero'

  resources :mensagem_notificacoes, except: :show do
    collection do
      get 'render_form'
    end
    member do
      post 'ativar_desativar'
    end
  end

  resources :loja_itens, except: :show do
    
    collection do
      get 'get_loja_itens'
      get 'vendas_pendentes_vendedor'
      post 'comprar_numero'
    end
    member do
      post 'conectar_qrcode'
    end
  end

  resources :receitaws_contas
  resources :setores do
    member do
      get 'desativar'
    end
  end
 
  resources :servicos do
    member do
      get 'desativar'
    end
  end

  resources :abordagem_iniciais do
    collection do
      post 'create_abordagem'
      get 'render_form'
      get 'ativar_abordagem'
      post 'desativar_abordagem'
      post 'deletar_abordagem'
      get 'get_abordagem_tipo'
    end
  end

  get 'solicitacao_desistencia_externo/lancar_desistencia'
  get 'solicitacao_desistencia_externo/get_dados_cliente'
  post 'solicitacao_desistencia_externo/criar_desistencia'
  get 'solicitacao_desistencia_externo/get_cliente_api'
  get 'solicitacao_desistencia_externo/get_cliente_financeiro_ativo' 
  get 'solicitacao_desistencia_externo/get_cliente_financeiro' 
  get 'solicitacao_banco_externo/solicitar_banco_externo' 
  post 'solicitacao_banco_externo/criar_solicitacao'

  resources :satisfacao, only:[:index] do
    collection do
      post 'criar_pesquisa'
      get 'buscar_cliente'
      get 'teste'
    end
  end


  resources :satisfacao_gruber, only:[:index, :show] do
    collection do
      get 'dashboard'
      get 'media_setores_rh'
      get 'media_setores_externo'
      get 'media_setores_contabil'
      get 'media_setores'
      get 'media_servicos'
      get 'media_setores_financeiro'
      get 'media_setores_atendimento'
    end
  end


  resources :solicitacao_desistencias do
    collection do
      get 'get_cliente_api'
      get 'get_contatos_api'
      get 'find_cliente'
      post 'create_tag'
      post 'finalizar'
      get 'get_solicitacoes_status'
      get 'activities'
      post 'alterar_status'
      get 'montar_msg'
      post 'iniciar_solicitacao'
      get 'painel_desistencias'
      get 'get_estatisticas_tags'
      delete 'deletar_solicitacao'
    end
  end
  
  resources :solicitacao_bancos do
    collection do
      get 'get_dados_modal'
      get 'create_banco'
      get 'solicitacoes_bancos'
      get 'get_solicitacao'
      get 'desativar_banco'
      get 'editar_solicitacao'    
      get 'get_parceiro_financeiro'
    end
    member do
      post 'gerar_database'
      get 'download_database'
    end
  end

  resources :nao_perturbe_retornos do
    collection do
      get 'fim_nao_perturbe'
    end
  end
  scope path_names: { new: "novo", edit: "editar" } do

    resources :contratos do
      collection do
        get 'emitir_contrato'
        get 'emitir' ,format: 'docx'
      end
      member do
        get 'desativar'
        get 'ativar'
      end
    end

    resources :historico_cliente, only:[:show] do
      collection do
        get 'aguardando_inertes'
        get 'avaliacao_inertes'
        get 'aguardando_pesquisa'
        get 'avaliacao_pesquisa'
        get 'show_periodo_inerte'
        get 'show_pesquisa'
        post 'registrar_feedback'
        post 'registrar_avaliacao'
        post 'registrar_avaliacao_pesquisa'
        get 'pesquisa_respostas'
        get 'get_periodos_inertes_cliente'
        get 'reprocessar_inertes'
        get 'reprocessar_pesquisas'
        get 'financeiro_cnpj'
      end
    end

    resources :perguntas do
      collection do
        get 'perguntas_fechamento'
        get 'perguntas_fechamento_condicional'
        get 'perguntas_implantacao'
        get 'perguntas_implantacao_condicional'
        get 'perguntas_acompanhamento'
        get 'perguntas_acompanhamento_condicional'
        get 'perguntas_pesquisa'
        post 'registrar_respostas_cliente'
        post 'registrar_respostas_pesquisa'
        get 'get_tags'
      end
      member do
        get 'desativar'
      end
    end

    resources :auditoria_desistencias, only: ['index']

    resources :relatorios do
      collection do
        get 'resumo_comercial'
        get 'resumo_comercial_relatorio'
        get 'ligacoes_relatorio'
        get 'ligacoes'
        get 'recebimento_primeira_mensalidade_json'
        get 'primeira_mensalidade'
        post 'primeira_mensalidade_print'
        get 'projecao_clientes_novos'
        get 'projecao_clientes_novos_json'
        post 'projecao_clientes_novos_print'
        get 'negociacoes'
        post 'negociacoes_print'
        post 'negociacoes_sp_print'
        post 'ligacoes_print'

        get 'pesquisa_satisfacao'
        post 'pesquisa_print'
        get 'pesquisa_satisfacao_json'

        get 'analise_vendedor'
        post 'analise_vendedor_print'
        get 'analise_vendedor_json'

        get 'analise_pci'
        post 'analise_pci_print'
        get 'analise_pci_json'

        get 'analise_cliente'
        post 'analise_cliente_print'
        get 'analise_cliente_json'

        get 'periodo_inertes'
        post 'periodo_inertes_print'
        get 'periodo_inertes_json'

        get 'comissionamento_mensalidades'
        post 'comissionamento_mensalidades_print'
        get 'comissionamento_mensalidades_json'

        get 'relatorio_atividades_ecf_json'

        get 'analise_desistencias_json'
        post 'analise_desistencias_print'
        get 'analise_desistencias'

        get 'analise_bloqueados_paralisados_json'
        post 'analise_bloqueados_paralisados_print'
        get 'analise_bloqueados_paralisados'

        get 'cobranca_primeira_mensalidade_json'
        post 'cobranca_primeira_mensalidade_print'
        get 'cobranca_primeira_mensalidade'

        get 'contratos_assinados_json'
        post 'contratos_assinados_print'
        get 'contratos_assinados'
      end
    end

    resources :acompanhamentos do
      member do
        patch 'desistente'
        get 'pausar'
        post 'continuar'
        post 'iniciar'
        patch 'finalizar'
        get 'get_dias_sem_uso'
        put 'conferir'
        put 'baixar'
        put 'recuperar'
        patch 'pausar'
        put 'voltar_negociacao'
        put 'voltar_acomp_pra_impl'
        put 'voltar_acomp_pra_acomp'
      end
      collection do
        get 'get_acompanhamentos'
        get 'activities'
        get 'get_acompanhamentos_retorno_notificacao'
        get 'acompanhamentos_desistentes'
        post 'transferir'
        get 'get_dias_sem_uso_by_cnpj'
        get 'acompanhamentos_sem_agendamento_retorno'
      end
    end

    resources :comentarios do
      collection do
        post 'historico'
      end
    end

    resources :tipo_fechamentos

    resources :negociacoes do
      member do
        put 'cancelar'
        put 'conferir'
        put 'baixar'
        put 'recuperar'
      end
      collection do
        get 'get_empresas_negociacao'
        post 'transferir_negociacao'
        post 'transferir_negociacoes'
        get 'activities'
        get 'set_canal_atendimento'
        get 'get_empresas_negociacao_canceladas'
        get 'get_informacao_por_consultor'
      end
    end

    resources :implantacoes do
      member do
        patch 'iniciar'
        patch 'finalizar_instalacao'
        patch 'iniciar_treinamento'
        patch 'finalizar'
        patch 'alterar_treinamento'
        patch 'desistente'
        patch 'pausar_continuar'
        patch 'reagendar_aguardar'
        get 'iniciar'
        get 'finalizar_instalacao'
        get 'finalizar'
        get 'pausar_continuar'
        get 'reagendar_aguardar'
        get 'limbo'
        put 'conferir'
        put 'baixar'
        put 'recuperar'
        get 'assumir_responsabilidade'
        put 'voltar_negociacao'
      end
      collection do
        get 'get_implantacoes'
        get 'lancar'
        post 'transferir_implantacao'
        get 'activities'
        get 'implantacoes_desistentes'
        get 'implantacoes_sem_agendamento_retorno'
        post 'transferir_vendedor'
      end
    end

    resources :notificacoes do
      collection do
        get 'contador'
        get 'novas_notificacoes'
        get 'get_notificacoes'
        get 'marcar_lido'
        get 'notificacoes_nao_lidas'
        post 'criar_notificacao_arquivo_retorno'
      end
    end
    # resources :lembretes do
    #   member do
    #     get 'finalizar'
    #   end
    #   collection do
    #     get 'get_lembretes'
    #     post 'salvar'
    #     get 'find_lembrete'
    #   end
    # end
    resources :agendamento_retornos do
      member do
        put 'conferir'
        put 'baixar'
        put 'recuperar'
        get 'activities'
      end
      collection do
        get 'cancelar_retorno'
        get 'get_retornos'
        get 'proximo_retorno_usuario'
        post 'reagendar_retorno_negociacao'
        get 'set_retorno_andamento'
        get 'retornos_acompanhamento'
        get 'retornos_cancelados'
        get 'verificar_horario_acompanhamento'
        get 'retornos_implantacao'
        post 'reagendar_retorno_implantacao'
        post 'reagendar_retorno_acompanhamento'
        post 'novo_retorno_acompanhamento'
      end
    end

    resources :formaspagamento, only: [:index, :new, :create, :edit, :update, :show]

    resources :propostas, only: [:create, :show] do
      collection do
        get 'find_propostas'
      end
    end

    resources :permissoes, only: [:index, :new, :create, :edit, :update]

    resources :tipo_agendamentos, only: [:index, :new, :create, :edit, :update] do
      member do
        get 'desativar'
      end
    end

    resources :parametros, only: [:update] do
      collection do
        get 'editar_parametros'
        post 'senha_master_valida'
      end
    end

    resources :ligacoes, only: [:index, :show, :update, :create] do
      member do
        put 'finalizar_ligacao_escritorio'
        put 'set_status_ligacao'
        put 'finalizar_ligacao'
        get 'redirect_to_whats'
      end

      collection do
        post 'enviar_captacao_em_massa'
        get 'buscar_cidades_por_estado'
        get 'mostrar_ligacoes_filtradas'
        get 'ligacao'
        get 'retorno'
        get 'get_proximo_cliente'
        get 'user_em_atendimento'
        get 'ligacao_em_andamento'
        post 'cadastrar_sistema_terceiro'
        post 'sistema_especifico'
        post 'enviado_whats'
        put 'cancelar_atendimentos_usuario'
        get 'ligacoes_por_estado'
        get 'ligacoes_old'
      end
    end

    resources :agendamentos do
      member do
        post 'reagendar'
        get 'nao_confimado_avisado'
      end
      collection do
        post 'salvar'
        get 'get_agenda'
        get 'get_users_agenda'
        get 'get_legenda'
        post 'alterar_contato'
        get 'find_cliente_agenda'
        get 'activities'
        get 'agendamento_nao_confirmado'
        get 'find_agendamento_by_fechamento'
      end
    end

    get 'agenda', to: 'agendamentos#agenda'

    resources :escritorios, only: [:index, :new, :create, :edit, :update, :show] do
      collection do
        get 'find_escritorios'
        post 'add_cliente'
        post 'remove_cliente'
        get 'add_historico'
        get 'get_historicos'
        get 'todos'
        get 'add_novo_telefone'
        post 'salvar_atualizar_cadastro'
      end
    end

    resources :status do
      collection do
        get 'get_status_cliente'
      end
    end

    devise_scope :user do
      get '/users/sign_out' => 'devise/sessions#destroy'
    end
    devise_for :users, controllers: {
        sessions: 'users/sessions'
    }

    resources :users, only: [:index, :new, :create, :edit, :update] do
      collection do
        get 'editar_usuario'
        get 'find_usuarios'
        get 'find_usuarios_agenda'
        get 'avatar'
        get 'avatar_user'
        post 'alterar_empresa'
        get 'get_current_empresa_id'
        get 'get_current_empresa'
        get 'set_preference'
        get 'find_usuario_by_name'
        get 'find_usuario_by_id'
        get 'implantacao_em_andamento'
        get 'inverter_status_ocupado'
        get 'qtd_numeros_autenticados'
      end
      member do
        get 'desativar'
      end
    end

    resources :importacoes, only: [:index] do
      collection do
        post 'importar_receita'
        post 'reprocessar_importacao'
        get 'importar_cnpj'
        get 'importacoes_estado'
        get 'saldo_atual_por_job'
        post 'importacao_em_massa'
        post 'reconsultar_empresas'
        post 'reajustar_filas'
        get 'ultima_data_importacao'
        get 'quantidade_empresas_reconsultar'
        post 'reimportar_empresas'
      end
      member do
        get 'download_csv_file'
      end
    end

    resources :cnaes, only: [:index, :new, :create, :update] do
      member do
        get 'blacklist'
        get 'preferencial'
      end
      collection do
        get 'top_vendidos'
        get 'find_cnaes'
      end
    end

    resources :cidades, only: [:index] do
      member do
        get 'blacklist'
        get 'preferencial'
      end
      collection do
        get 'find_by_estado'
        get 'find_cidades'
        get 'cidades_buscar'
        get 'find_cidades_estado_financeiro'
      end
    end

    resources :sistemas, only: [:index, :new, :create, :edit, :update] do
      collection do
        get 'find_sistemas'
      end
    end

    resources :pacotes, only: [:index, :new, :create, :edit, :update, :show] do
      collection do
        get 'find_pacotes'
      end
    end

    resources :empresas, only: [:index, :new, :create, :edit, :update] do
      collection do
        get 'empresa_logada'
        post 'exportar_listas_job'
        get 'get_empresa_by_sigla_estado'
        get 'get_estado_by_empresa'
      end
    end

    resources :clientes, only: [:index, :new, :create, :edit, :update, :show] do
      member do
        get 'desativar'
        put 'cancelar_atendimento'
        post 'novo_contato'
      end
      collection do
        get 'find_cidades'
        get 'find_cliente_id'
        get 'find_cliente'
        get 'find_cliente_all_empresa'
        get 'find_cliente_cnpj'
        get 'find_cliente_financeiro'
        get 'set_telefone_preferencial'
        get 'set_telefone_whatsapp'
        get 'set_respondeu_whats'
        get 'desativar_telefone'
        get 'get_fechamento_cliente'
        get 'find_cliente_params'
        get 'assinar_contrato'
      end
    end

    resources :dashboards do
      collection do
        get 'empresas'
        get 'empresas_contatadas'
        get 'implantacoes'
        get 'acompanhamentos'
        get 'get_ligacoes_dias'
        get 'get_ligacoes_dia'
        get 'get_ligacoes_status'
        get 'get_ligacoes_status_ligacao'
        get 'get_clientes_by_status'
        get 'get_clientes_by_status_ligacao'
        get 'get_percentual_fila'
        get 'get_contatos_12_meses'
        get 'get_contatos_mes'

        #PAINEL VENDAS
        get 'painel_vendas'
        get 'get_fechamentos'
        get 'get_fechamentos_by_sistemas'
        get 'get_valores_fechamento'
        get 'get_top_fechamentos'
        get 'get_top_implantacao'
        get 'get_top_mensalidade'
        get 'get_fechamentos_table'
        get 'get_tipo_fechamento'
        get 'get_top_estados_vendas'
        

        #IMPLANTACAO
        get 'get_valores_implantacao'
        get 'get_implantacoes_concluidas'
        get 'get_implantacoes_andamento'
        get 'get_implantacoes_aguardando'
        get 'get_implantacoes_desistente'
        get 'get_implantacoes_cidades'
        get 'get_top_implantadores'
        get 'get_implantacoes_table'
        get 'get_top_estados_implantacao'

        #ACOMPANHAMENTOS
        get 'get_valores_acompanhamentos'
        get 'get_acompanhamentos_concluidas'
        get 'get_acompanhamentos_aguardando'
        get 'get_acompanhamentos_andamento'
        get 'get_top_implantadores_acompanhamento'
        get 'get_top_vendedores_acompanhamento'
        get 'get_acompanhamentos_table'
        get 'get_top_estados_acompanhamento'

        #EMPRESAS
        get 'get_empresas_status_geral'
        get 'get_empresas_status'
        get 'get_controle_filas_job'
        get 'get_lista_job'
        get 'get_controle_filas_table'
        get 'get_empresas_boas_ruins'
        get 'get_empresas_boas_ruins_status_geral'
        get 'get_empresas_boas_ruins_status_empresa'
        get 'exportar_lista_empresas_xlsx'

        #RESULTADOS
        get 'resultados'
        get 'get_clientes_ativos'
        get 'get_efetivacoes_desativacoes'
        get 'get_efetivacoes_desativacoesReal'
        get 'get_efetivacoes_desativacoes_sistema'
        get 'get_efetivacoes_desativacoes_sistema_real'
        get 'get_efetivacoes_desativacoes_2meses'
        get 'get_total_faturamento_tipo'
        get 'get_total_primeira_mensalidade_por_tipo'
        get 'get_total_primeira_mensalidade_por_tipo_mes_anterior'
        get 'get_cliente_12_meses'
        get 'get_cliente_12_meses_sistema'
        get 'get_clientes_ativos_cidade'
        get 'get_total_faturamento_12_meses'
        get 'get_total_faturamento_12_meses_sistema'
        get 'get_total_faturamento_mes_anterior'
        get 'get_inadimplencia_12_meses'
        get 'get_demonstrativo_12_meses'
        get 'get_demonstrativo_mes_anterior'
        get 'get_tabela_receitas'
        get 'get_receita_12_meses'
        get 'get_receita_12_meses_sistema'
        get 'get_outras_receitas_12_meses'
        get 'get_cliente_UF'
        get 'get_total_faturamento_UF'
        get 'get_resumo_ultimos_5_anos'
        get 'get_despesas_com_pessoal'

        #RESULTADOS - COMERCIAL
        get 'implantacoes_conluidas_12_meses'
        get 'implantacoes_conluidas_12_meses_mes_anterior'
        get 'acompanhamentos_concluidos_12_meses'
        get 'acompanhamentos_concluidos_12_meses_mes_anterior'
        get 'desistencia_12_meses'
        get 'desistencia_12_meses_mes_anterior'
        get 'fechamentos_12_meses'
        get 'fechamentos_12_meses_mes_anterior'

        get 'top_vendedores_acompanhamentos'
        get 'top_vendedores_implantacoes'

        #RESULTADOS - TABELAS
        get 'table_efetivacoes'
        get 'table_implantacoes'
        get 'table_desistencia_acompanhamento'
        get 'table_desistencia_implantacao'
        get 'table_efetivacoes_financeiro'
        get 'table_efetivacoes_financeiroReal'
        get 'table_desistencia_financeiro'
        get 'table_desistencia_financeiroReal'
        get 'table_primeira_parcela'
        get 'table_primeira_parcela_instalacao'
        get 'table_historico_cobranca_cliente'
        get 'table_clientes_ativos_bloqueados'
        get 'table_clientes_bloqueados_atualmente'

        #RESULTADOS - PROJECAO
        get 'get_projecao_honorario_12_meses'
        get 'get_projecao_instalacao_12_meses'
        get 'get_projecao_faturamento'
        get 'get_projecao_clientes'
        get 'get_projecao_faturamento_honorario'

        #RESUMO_COMERCIAL
        get 'resumo_comercial'

        #FUNIL
        get 'funil'
        get 'get_dados_funil'
        get 'get_empresas_funil_status'
        get 'get_dados_funil_usuario'
        get 'get_empresas_funil_status_usuario'
        get 'get_dados_funil_captacao'
        get 'get_empresas_funil_status_captacao'

        #RESULTADOS_GRUBER
        get 'resultados_gruber'
        get 'clientes_12_meses_gruber'
        get 'table_clientes_gruber'
        get 'get_efetivacoes_desativacoes_gruber'
        get 'table_efetivacoes_financeiro_gruber'
        get 'table_desistencia_financeiro_gruber'
        get 'get_total_faturamento_12_meses_gruber'
        get 'get_total_faturamento_mes_anterior_gruber'
        get 'get_faturamento_por_tipo'
        get 'get_inadimplencia_12_meses_gruber'
        get 'get_total_primeira_honorario'
        get 'get_total_primeira_honorario_mes_anterior'
        get 'get_inadimplencia_tipo_gruber'
        get 'table_primeira_parcela_honorario'
        get 'get_receita_12_meses_gruber'
        get 'get_demonstrativo_12_meses_gruber'
        get 'get_resultado_12_meses'

        #Centro de dis
        get 'empresas_centro_distribuicao'
        post 'create_fila_empresas_centro_distribuicao'

        # Desistências
        get 'desistencias'
        get 'desistentes_por_tags'
        get 'clientes_bloqueados'
        get 'buscar_info_desistentes_por_tag'
        get 'comparacao_tags_mensal'
      end
    end

    resources :progress_bar, only: 'show'

    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'

    resources :receitaws_contas

  end

  namespace :api do
    resources :clientes, only: [] do
      collection do
        get 'dados_cliente_fechamento'
      end
    end
  end

  resources :upload do
    collection do
      get 'download_file'
      get 'remove_file'
    end
  end

  resources :campanhas do
    member do
      get 'previsao_termino'
    end

    collection do
      get 'by_status'
      get 'analise_dados'
      get 'numeros_ativos_usuario'
      get 'simples_nacional'
      post 'finalizar_campanha'
      post 'reenviar_campanha'
      post 'pausar'
      post 'pausar_todas'
      post 'parar'
      post 'parar_todas'
      post 'disparo_efetuado'
      get 'atualizar_campanhas'
      post 'transferir_campanha'
    end
  end

  resources :whatsapp_numeros do
    collection do
      post 'desconectar_numero'
      post 'ativar_numero_ocultado'
      post 'conectar_numero'
      get ':numero/qrcode', action: :qrcode, as: :qrcode
    end
    member do
      post 'set_numero_conectado'
      post 'desconectar_numero_manualmente'
    end
  end


  # You can have the root of your site routed with "root"
  root to: 'dashboards#painel_vendas'
  # mount ExceptionLogger::Engine => "/exception_logger"

end
