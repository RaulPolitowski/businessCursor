# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20230726204314) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "abordagem_iniciais", force: :cascade do |t|
    t.string   "texto"
    t.boolean  "ativa",                         default: true
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.string   "tipo"
    t.integer  "fila"
    t.string   "intervalo_resposta_automatica"
  end

  create_table "acompanhamentos", force: :cascade do |t|
    t.datetime "data_inicio"
    t.datetime "data_fim"
    t.integer  "cliente_id"
    t.integer  "empresa_id"
    t.integer  "user_id"
    t.integer  "status"
    t.integer  "proposta_id"
    t.boolean  "pausada"
    t.text     "observacao"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "motivo"
    t.integer  "user_cancelamento_id"
    t.boolean  "conferido",            default: false
    t.boolean  "baixado",              default: false
  end

  add_index "acompanhamentos", ["cliente_id"], name: "index_acompanhamentos_on_cliente_id", using: :btree
  add_index "acompanhamentos", ["empresa_id"], name: "index_acompanhamentos_on_empresa_id", using: :btree
  add_index "acompanhamentos", ["proposta_id"], name: "index_acompanhamentos_on_proposta_id", using: :btree
  add_index "acompanhamentos", ["user_id"], name: "index_acompanhamentos_on_user_id", using: :btree

  create_table "activities", force: :cascade do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree

  create_table "agendamento_retornos", force: :cascade do |t|
    t.integer  "ligacao_id"
    t.integer  "user_id"
    t.datetime "data_agendamento_retorno"
    t.datetime "data_efetuado_retorno"
    t.integer  "user_retorno_id"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.integer  "empresa_id"
    t.boolean  "cancelado",                  default: false
    t.string   "motivo"
    t.integer  "usuario_cancelamento_id"
    t.integer  "acompanhamento_id"
    t.integer  "cliente_id"
    t.boolean  "avisado",                    default: false
    t.boolean  "conferido",                  default: false
    t.boolean  "baixado",                    default: false
    t.datetime "data_cancelamento"
    t.integer  "implantacao_id"
    t.integer  "solicitacao_desistencia_id"
  end

  add_index "agendamento_retornos", ["acompanhamento_id"], name: "index_agendamento_retornos_on_acompanhamento_id", using: :btree
  add_index "agendamento_retornos", ["cliente_id"], name: "index_agendamento_retornos_on_cliente_id", using: :btree
  add_index "agendamento_retornos", ["empresa_id"], name: "index_agendamento_retornos_on_empresa_id", using: :btree
  add_index "agendamento_retornos", ["implantacao_id"], name: "index_agendamento_retornos_on_implantacao_id", using: :btree
  add_index "agendamento_retornos", ["ligacao_id"], name: "index_agendamento_retornos_on_ligacao_id", using: :btree
  add_index "agendamento_retornos", ["user_id"], name: "index_agendamento_retornos_on_user_id", using: :btree

  create_table "agendamentos", force: :cascade do |t|
    t.datetime "data_inicio"
    t.datetime "data_fim"
    t.integer  "user_id"
    t.string   "titulo"
    t.string   "observacao"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "tipo_agendamento_id"
    t.integer  "empresa_id"
    t.integer  "cliente_id"
    t.integer  "user_registro_id"
    t.string   "contato"
    t.string   "telefone"
    t.string   "telefone2"
    t.string   "responsavel2"
    t.integer  "implantacao_id"
    t.boolean  "ativo",                  default: true
    t.string   "motivo"
    t.integer  "user_cancelamento_id"
    t.datetime "data_cancelamento"
    t.boolean  "confirmado",             default: false
    t.integer  "user_confirmacao_id"
    t.datetime "data_confirmacao"
    t.boolean  "aviso_nao_confirmado",   default: false
    t.boolean  "telefone_preferencial",  default: false
    t.boolean  "telefone_preferencial2", default: false
    t.boolean  "telefone_whats",         default: false
    t.boolean  "telefone_whats2",        default: false
    t.integer  "historico_id"
  end

  add_index "agendamentos", ["cliente_id"], name: "index_agendamentos_on_cliente_id", using: :btree
  add_index "agendamentos", ["empresa_id"], name: "index_agendamentos_on_empresa_id", using: :btree
  add_index "agendamentos", ["implantacao_id"], name: "index_agendamentos_on_implantacao_id", using: :btree
  add_index "agendamentos", ["tipo_agendamento_id"], name: "index_agendamentos_on_tipo_agendamento_id", using: :btree
  add_index "agendamentos", ["user_id"], name: "index_agendamentos_on_user_id", using: :btree

  create_table "anexos", force: :cascade do |t|
    t.integer  "cliente_id"
    t.string   "file"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "solicitacao_desistencia_id"
  end

  add_index "anexos", ["cliente_id"], name: "index_anexos_on_cliente_id", using: :btree

  create_table "campanha_envios", force: :cascade do |t|
    t.integer  "campanha_id"
    t.integer  "cliente_id"
    t.string   "numero"
    t.string   "status"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "abordagem_inicial_id"
    t.string   "message"
    t.string   "resposta_automatica_message"
    t.integer  "intervalo_resposta_automatica"
  end

  add_index "campanha_envios", ["abordagem_inicial_id"], name: "index_campanha_envios_on_abordagem_inicial_id", using: :btree
  add_index "campanha_envios", ["campanha_id"], name: "index_campanha_envios_on_campanha_id", using: :btree
  add_index "campanha_envios", ["cliente_id"], name: "index_campanha_envios_on_cliente_id", using: :btree

  create_table "campanhas", force: :cascade do |t|
    t.integer  "qtd_total"
    t.integer  "qtd_enviado"
    t.integer  "qtd_erros"
    t.integer  "qtd_ignorado"
    t.string   "tipo"
    t.integer  "empresa_id"
    t.integer  "job"
    t.string   "status"
    t.string   "numero"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "tempo_espera"
<<<<<<< HEAD
    t.integer  "tempo_total"
    t.datetime "agendado_at"
=======
    t.datetime "agendado_at"
    t.boolean  "is_pausado"
    t.integer  "tempo_total"
    t.integer  "tipo_disparo"
    t.boolean  "is_resposta_automatica"
    t.boolean  "is_abordagem_inicial_especifica"
    t.boolean  "is_abordagem_resposta_especifica"
>>>>>>> master
  end

  add_index "campanhas", ["empresa_id"], name: "index_campanhas_on_empresa_id", using: :btree

  create_table "cidades", force: :cascade do |t|
    t.string   "codigo"
    t.string   "nome"
    t.integer  "estado_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.boolean  "blacklist"
    t.boolean  "preferencial"
  end

  add_index "cidades", ["estado_id"], name: "index_cidades_on_estado_id", using: :btree

  create_table "clientes", force: :cascade do |t|
    t.string   "cnpj"
    t.string   "inscricao_estadual"
    t.date     "data_licenca"
    t.string   "situacao"
    t.string   "nire"
    t.string   "razao_social"
    t.string   "endereco"
    t.string   "numero_endereco"
    t.string   "complemento"
    t.string   "cep"
    t.string   "bairro"
    t.string   "email"
    t.string   "telefone"
    t.string   "telefone2"
    t.string   "observacao"
    t.integer  "cidade_id"
    t.integer  "cnae_id"
    t.integer  "importacao_id"
    t.integer  "escritorio_id"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.integer  "empresa_id"
    t.integer  "status_id"
    t.boolean  "ativo",                     default: true
    t.string   "nome_fantasia"
    t.boolean  "em_atendimento",            default: false
    t.integer  "user_atendimento_id"
    t.datetime "data_retorno"
    t.integer  "user_retorno_id"
    t.integer  "numero_fila"
    t.boolean  "triagem",                   default: false
    t.date     "data_importacao"
    t.integer  "status_empresa"
    t.boolean  "telefone_preferencial",     default: false
    t.boolean  "telefone2_preferencial",    default: false
    t.boolean  "telefone_enviado_whats",    default: false
    t.boolean  "telefone2_enviado_whats",   default: false
    t.boolean  "telefone_respondeu_whats"
    t.boolean  "telefone2_respondeu_whats"
    t.string   "porte"
    t.integer  "tempo_inerte"
    t.date     "proxima_pesquisa"
    t.boolean  "rejeitado_rf",              default: false
    t.date     "sem_inerte_ate"
    t.integer  "hist_impl_id"
    t.integer  "hist_acomp_id"
    t.boolean  "assinou_contrato",          default: false
    t.string   "socio_admin"
    t.string   "email_backup"
    t.string   "senha_backup"
    t.integer  "empresaid_old"
    t.boolean  "reconsultado",              default: false
  end

  add_index "clientes", ["cidade_id"], name: "index_clientes_on_cidade_id", using: :btree
  add_index "clientes", ["cnae_id"], name: "index_clientes_on_cnae_id", using: :btree
  add_index "clientes", ["cnpj", "empresa_id"], name: "index_cnpj_empresa_id", using: :btree
  add_index "clientes", ["empresa_id"], name: "index_clientes_on_empresa_id", using: :btree
  add_index "clientes", ["escritorio_id"], name: "index_clientes_on_escritorio_id", using: :btree
  add_index "clientes", ["importacao_id"], name: "index_clientes_on_importacao_id", using: :btree
  add_index "clientes", ["status_id"], name: "index_clientes_on_status_id", using: :btree

  create_table "cnae_clientes", force: :cascade do |t|
    t.integer  "cnae_id"
    t.integer  "cliente_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "cnae_clientes", ["cliente_id"], name: "index_cnae_clientes_on_cliente_id", using: :btree
  add_index "cnae_clientes", ["cnae_id"], name: "index_cnae_clientes_on_cnae_id", using: :btree

  create_table "cnaes", force: :cascade do |t|
    t.string   "codigo"
    t.string   "descricao"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.boolean  "preferencial", default: false
    t.boolean  "blacklist",    default: false
  end

  create_table "comentarios", force: :cascade do |t|
    t.text     "comentario"
    t.integer  "user_id"
    t.integer  "implantacao_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "acompanhamento_id"
    t.integer  "negociacao_id"
    t.integer  "agendamento_id"
    t.integer  "cliente_id"
    t.integer  "historico_id"
    t.integer  "solicitacao_desistencia_id"
    t.boolean  "isAcordo"
  end

  add_index "comentarios", ["acompanhamento_id"], name: "index_comentarios_on_acompanhamento_id", using: :btree
  add_index "comentarios", ["agendamento_id"], name: "index_comentarios_on_agendamento_id", using: :btree
  add_index "comentarios", ["cliente_id"], name: "index_comentarios_on_cliente_id", using: :btree
  add_index "comentarios", ["implantacao_id"], name: "index_comentarios_on_implantacao_id", using: :btree
  add_index "comentarios", ["negociacao_id"], name: "index_comentarios_on_negociacao_id", using: :btree
  add_index "comentarios", ["user_id"], name: "index_comentarios_on_user_id", using: :btree

  create_table "contatos", force: :cascade do |t|
    t.string   "nome"
    t.string   "telefone"
    t.string   "email"
    t.string   "funcao"
    t.integer  "cliente_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "escritorio_id"
    t.string   "cpf"
    t.string   "telefone2"
    t.string   "telefone3"
    t.string   "telefone4"
    t.string   "celular"
    t.string   "celular2"
    t.string   "celular3"
    t.string   "celular4"
    t.boolean  "telefone_preferencial", default: false
    t.boolean  "telefone_whats",        default: false
  end

  add_index "contatos", ["cliente_id"], name: "index_contatos_on_cliente_id", using: :btree
  add_index "contatos", ["escritorio_id"], name: "index_contatos_on_escritorio_id", using: :btree

  create_table "contratos", force: :cascade do |t|
    t.text     "nome"
    t.text     "descricao"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.text     "texto"
    t.boolean  "ativo",      default: true
    t.integer  "sistema_id"
  end

  create_table "controle_job_cliente_restantes", force: :cascade do |t|
    t.integer  "controle_job_id"
    t.integer  "cliente_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "controle_job_cliente_restantes", ["cliente_id"], name: "index_controle_job_cliente_restantes_on_cliente_id", using: :btree
  add_index "controle_job_cliente_restantes", ["controle_job_id"], name: "index_controle_job_cliente_restantes_on_controle_job_id", using: :btree

  create_table "controle_job_clientes", force: :cascade do |t|
    t.integer  "controle_job_id"
    t.integer  "cliente_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "controle_job_clientes", ["cliente_id"], name: "index_controle_job_clientes_on_cliente_id", using: :btree
  add_index "controle_job_clientes", ["controle_job_id"], name: "index_controle_job_clientes_on_controle_job_id", using: :btree

  create_table "controle_jobs", force: :cascade do |t|
    t.date     "data_controle"
    t.integer  "job"
    t.integer  "quantidade"
    t.integer  "empresa_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "restante"
    t.string   "filas"
  end

  add_index "controle_jobs", ["empresa_id"], name: "index_controle_jobs_on_empresa_id", using: :btree

  create_table "empresas", force: :cascade do |t|
    t.string   "cnpj"
    t.string   "razao_social"
    t.string   "nome_fantasia"
    t.integer  "cidade_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "sequencia_cnpj"
    t.boolean  "ativo",          default: true
    t.string   "estado"
  end

  add_index "empresas", ["cidade_id"], name: "index_empresas_on_cidade_id", using: :btree

  create_table "empresas_users", force: :cascade do |t|
    t.integer "user_id"
    t.integer "empresa_id"
  end

  create_table "escritorios", force: :cascade do |t|
    t.string   "razao_social"
    t.string   "nome_fantasia"
    t.string   "telefone"
    t.string   "responsavel"
    t.boolean  "possui_parceria"
    t.string   "empresa_parceria"
    t.string   "observacao"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "empresa_id"
    t.boolean  "tem_interesse_parceria", default: true
    t.string   "motivo_sem_interesse"
    t.string   "parceria_obs"
    t.integer  "user_id"
    t.integer  "cidade_id"
    t.integer  "status_id"
    t.boolean  "passa_contato",          default: false
    t.boolean  "em_atendimento",         default: false
    t.integer  "user_atendimento_id"
  end

  add_index "escritorios", ["cidade_id"], name: "index_escritorios_on_cidade_id", using: :btree
  add_index "escritorios", ["empresa_id"], name: "index_escritorios_on_empresa_id", using: :btree
  add_index "escritorios", ["status_id"], name: "index_escritorios_on_status_id", using: :btree
  add_index "escritorios", ["user_id"], name: "index_escritorios_on_user_id", using: :btree

  create_table "estados", force: :cascade do |t|
    t.string   "sigla"
    t.string   "nome"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fechamentos", force: :cascade do |t|
    t.datetime "data_fechamento"
    t.integer  "tipo_fechamento_id"
    t.integer  "user_id"
    t.integer  "proposta_id"
    t.integer  "cliente_id"
    t.integer  "status_id"
    t.integer  "empresa_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.boolean  "solicitou_banco"
  end

  add_index "fechamentos", ["cliente_id"], name: "index_fechamentos_on_cliente_id", using: :btree
  add_index "fechamentos", ["empresa_id"], name: "index_fechamentos_on_empresa_id", using: :btree
  add_index "fechamentos", ["proposta_id"], name: "index_fechamentos_on_proposta_id", using: :btree
  add_index "fechamentos", ["status_id"], name: "index_fechamentos_on_status_id", using: :btree
  add_index "fechamentos", ["tipo_fechamento_id"], name: "index_fechamentos_on_tipo_fechamento_id", using: :btree
  add_index "fechamentos", ["user_id"], name: "index_fechamentos_on_user_id", using: :btree

  create_table "fila_empresas", force: :cascade do |t|
    t.integer  "cliente_id"
    t.integer  "numero_fila"
    t.integer  "empresa_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "user_retorno_id"
  end

  add_index "fila_empresas", ["cliente_id"], name: "index_fila_empresas_on_cliente_id", using: :btree
  add_index "fila_empresas", ["empresa_id"], name: "index_fila_empresas_on_empresa_id", using: :btree

  create_table "formas_pagamento", force: :cascade do |t|
    t.string   "descricao"
    t.boolean  "parcelado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "empresa_id"
  end

  add_index "formas_pagamento", ["empresa_id"], name: "index_formas_pagamento_on_empresa_id", using: :btree

  create_table "gruber_pesquisa_respostas", force: :cascade do |t|
    t.integer  "servico_id"
    t.integer  "setor_id"
    t.integer  "gruber_pesquisa_id"
    t.integer  "nota"
    t.string   "motivo"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "setor_financeiro_id"
    t.string   "setor_financeiro_nome"
  end

  add_index "gruber_pesquisa_respostas", ["gruber_pesquisa_id"], name: "index_gruber_pesquisa_respostas_on_gruber_pesquisa_id", using: :btree
  add_index "gruber_pesquisa_respostas", ["servico_id"], name: "index_gruber_pesquisa_respostas_on_servico_id", using: :btree
  add_index "gruber_pesquisa_respostas", ["setor_id"], name: "index_gruber_pesquisa_respostas_on_setor_id", using: :btree

  create_table "gruber_pesquisas", force: :cascade do |t|
    t.integer  "cliente_id"
    t.string   "cliente_nome"
    t.string   "cliente_telefone"
    t.string   "cliente_email"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "cliente_razao_social"
    t.string   "cliente_cpf_cnpj"
    t.boolean  "tem_avaliacao_negativa",   default: false
    t.string   "instituicao_beneficiente"
  end

  create_table "hist_impl_acomp", force: :cascade do |t|
    t.integer  "impl_id"
    t.integer  "acomp_id"
    t.string   "tipo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "implantacoes", force: :cascade do |t|
    t.integer  "cliente_id"
    t.integer  "proposta_id"
    t.integer  "user_id"
    t.integer  "status"
    t.datetime "data_inicio"
    t.datetime "data_fim"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.boolean  "pausada",              default: false
    t.text     "observacao"
    t.integer  "empresa_id"
    t.string   "motivo"
    t.integer  "user_cancelamento_id"
    t.boolean  "baixado",              default: false
    t.boolean  "conferido",            default: false
  end

  add_index "implantacoes", ["cliente_id"], name: "index_implantacoes_on_cliente_id", using: :btree
  add_index "implantacoes", ["empresa_id"], name: "index_implantacoes_on_empresa_id", using: :btree
  add_index "implantacoes", ["proposta_id"], name: "index_implantacoes_on_proposta_id", using: :btree
  add_index "implantacoes", ["user_id"], name: "index_implantacoes_on_user_id", using: :btree

  create_table "importacoes", force: :cascade do |t|
    t.datetime "data_importacao"
    t.integer  "total"
    t.integer  "importado"
    t.integer  "nao_importado"
    t.integer  "ja_existente"
    t.integer  "user_id"
    t.integer  "estado_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.boolean  "finalizada"
    t.integer  "progress_bar_id"
    t.integer  "empresa_id"
  end

  add_index "importacoes", ["empresa_id"], name: "index_importacoes_on_empresa_id", using: :btree
  add_index "importacoes", ["estado_id"], name: "index_importacoes_on_estado_id", using: :btree
  add_index "importacoes", ["progress_bar_id"], name: "index_importacoes_on_progress_bar_id", using: :btree
  add_index "importacoes", ["user_id"], name: "index_importacoes_on_user_id", using: :btree

  create_table "jobs", force: :cascade do |t|
    t.integer "job"
    t.integer "empresa_id"
    t.integer "filas",      limit: 8, array: true
  end

  create_table "lembretes", force: :cascade do |t|
    t.datetime "data"
    t.integer  "user_registro_id"
    t.integer  "user_lembrete_id"
    t.string   "observacao"
    t.integer  "empresa_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.boolean  "finalizado",       default: false
    t.boolean  "privado",          default: true
  end

  add_index "lembretes", ["empresa_id"], name: "index_lembretes_on_empresa_id", using: :btree

  create_table "ligacoes", force: :cascade do |t|
    t.datetime "data_inicio"
    t.datetime "data_fim"
    t.integer  "user_id"
    t.string   "observacao"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "empresa_id"
    t.integer  "cliente_id"
    t.integer  "status_ligacao_id"
    t.text     "anotacoes"
    t.integer  "status_cliente_id"
    t.integer  "agendamento_retorno_id"
    t.integer  "tipo",                   default: 0
    t.integer  "escritorio_id"
    t.boolean  "ligacao_old"
  end

  add_index "ligacoes", ["agendamento_retorno_id"], name: "index_ligacoes_on_agendamento_retorno_id", using: :btree
  add_index "ligacoes", ["cliente_id"], name: "index_ligacoes_on_cliente_id", using: :btree
  add_index "ligacoes", ["empresa_id"], name: "index_ligacoes_on_empresa_id", using: :btree
  add_index "ligacoes", ["escritorio_id"], name: "index_ligacoes_on_escritorio_id", using: :btree
  add_index "ligacoes", ["status_ligacao_id"], name: "index_ligacoes_on_status_ligacao_id", using: :btree
  add_index "ligacoes", ["user_id"], name: "index_ligacoes_on_user_id", using: :btree

  create_table "logged_exceptions", force: :cascade do |t|
    t.string   "exception_class"
    t.string   "controller_name"
    t.string   "action_name"
    t.text     "message"
    t.text     "backtrace"
    t.text     "environment"
    t.text     "request"
    t.datetime "created_at"
  end

  create_table "nao_perturbe_retornos", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "data_fim"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "nao_perturbe_retornos", ["user_id"], name: "index_nao_perturbe_retornos_on_user_id", using: :btree

  create_table "negociacoes", force: :cascade do |t|
    t.datetime "data_inicio"
    t.datetime "data_fim"
    t.integer  "user_id"
    t.integer  "cliente_id"
    t.text     "obs"
    t.integer  "status"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.boolean  "atendimento_whatsapp", default: false
    t.boolean  "atendimento_telefone", default: false
    t.integer  "empresa_id"
    t.integer  "status_id"
    t.boolean  "conferido",            default: false
    t.boolean  "baixado",              default: false
    t.integer  "prospectador_id"
  end

  add_index "negociacoes", ["cliente_id"], name: "index_negociacoes_on_cliente_id", using: :btree
  add_index "negociacoes", ["empresa_id"], name: "index_negociacoes_on_empresa_id", using: :btree
  add_index "negociacoes", ["status_id"], name: "index_negociacoes_on_status_id", using: :btree
  add_index "negociacoes", ["user_id"], name: "index_negociacoes_on_user_id", using: :btree

  create_table "notificacoes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "user_registro_id"
    t.datetime "data_hora"
    t.integer  "empresa_id"
    t.string   "observacao"
    t.string   "tipo"
    t.boolean  "lido"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.boolean  "visualizada"
    t.integer  "modelo_id"
    t.string   "title"
    t.string   "path"
    t.string   "tipo_fechamento"
  end

  add_index "notificacoes", ["empresa_id"], name: "index_notificacoes_on_empresa_id", using: :btree
  add_index "notificacoes", ["user_id"], name: "index_notificacoes_on_user_id", using: :btree

  create_table "pacotes", force: :cascade do |t|
    t.integer  "sistema_id"
    t.decimal  "mensalidade"
    t.decimal  "mensalidade_promocional"
    t.decimal  "implantacao"
    t.decimal  "implantacao_promocional"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "empresa_id"
    t.decimal  "implantacao_remota"
    t.decimal  "implantacao_remota_promocional"
  end

  add_index "pacotes", ["empresa_id"], name: "index_pacotes_on_empresa_id", using: :btree
  add_index "pacotes", ["sistema_id"], name: "index_pacotes_on_sistema_id", using: :btree

  create_table "parametros", force: :cascade do |t|
    t.integer  "tipo_prospeccao_pr_id"
    t.integer  "tipo_prospeccao_sp_id"
    t.string   "tipo_telefone_preferencial"
    t.boolean  "cidades_preferenciais"
    t.boolean  "cnaes_preferenciais"
    t.boolean  "data_habilitacao_preferencial"
    t.boolean  "telefone_preferencial"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "empresa_id"
    t.integer  "tipo_fila"
    t.string   "senha_master"
    t.string   "msg_whats"
    t.integer  "user_job1_id"
    t.integer  "user_job2_id"
    t.integer  "tempo_inerte"
  end

  add_index "parametros", ["empresa_id"], name: "index_parametros_on_empresa_id", using: :btree
  add_index "parametros", ["tipo_prospeccao_pr_id"], name: "index_parametros_on_tipo_prospeccao_pr_id", using: :btree
  add_index "parametros", ["tipo_prospeccao_sp_id"], name: "index_parametros_on_tipo_prospeccao_sp_id", using: :btree

  create_table "pergunta_cliente_resposta_tags", force: :cascade do |t|
    t.integer  "pergunta_cliente_resposta_id"
    t.string   "tag"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "pergunta_cliente_respostas", force: :cascade do |t|
    t.integer  "pergunta_id"
    t.integer  "cliente_id"
    t.text     "resposta"
    t.integer  "tipo"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "pergunta_cliente_respostas", ["cliente_id"], name: "index_pergunta_cliente_respostas_on_cliente_id", using: :btree
  add_index "pergunta_cliente_respostas", ["pergunta_id"], name: "index_pergunta_cliente_respostas_on_pergunta_id", using: :btree

  create_table "pergunta_pesquisa_respostas", force: :cascade do |t|
    t.integer  "pergunta_id"
    t.integer  "pesquisa_id"
    t.text     "resposta"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "pergunta_pesquisa_respostas", ["pergunta_id"], name: "index_pergunta_pesquisa_respostas_on_pergunta_id", using: :btree
  add_index "pergunta_pesquisa_respostas", ["pesquisa_id"], name: "index_pergunta_pesquisa_respostas_on_pesquisa_id", using: :btree

  create_table "perguntas", force: :cascade do |t|
    t.text     "pergunta"
    t.boolean  "fechamento"
    t.boolean  "implantacao"
    t.boolean  "acompanhamento"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.boolean  "confirmacao"
    t.integer  "pergunta_gatilho_id"
    t.string   "tipo"
    t.boolean  "pesquisa"
    t.boolean  "ativo",               default: true
  end

  create_table "periodo_inertes", force: :cascade do |t|
    t.integer  "cliente_id"
    t.integer  "empresa_id"
    t.date     "data"
    t.string   "feedback"
    t.string   "avaliacao"
    t.boolean  "positivo"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.integer  "tempo_inerte"
    t.datetime "last_login"
    t.datetime "data_feedback"
    t.integer  "user_feedback_id"
    t.datetime "data_avaliacao"
    t.integer  "user_avaliacao_id"
    t.boolean  "teste"
    t.string   "sistema"
    t.boolean  "nova"
    t.string   "versao"
    t.string   "situacao_financeira"
    t.boolean  "com_pendencia_financeira", default: false
    t.boolean  "bloqueado",                default: false
  end

  add_index "periodo_inertes", ["cliente_id"], name: "index_periodo_inertes_on_cliente_id", using: :btree
  add_index "periodo_inertes", ["empresa_id"], name: "index_periodo_inertes_on_empresa_id", using: :btree

  create_table "permissoes", force: :cascade do |t|
    t.string   "descricao"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.boolean  "agenda",     default: true
  end

  create_table "pesquisas", force: :cascade do |t|
    t.date     "data"
    t.integer  "cliente_id"
    t.integer  "empresa_id"
    t.string   "avaliacao"
    t.boolean  "positivo"
    t.integer  "user_avaliacao_id"
    t.datetime "data_avaliacao"
    t.integer  "user_id"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.datetime "data_pesquisa"
    t.datetime "ultimo_login"
    t.boolean  "nova"
    t.string   "sistema"
    t.string   "versao"
    t.integer  "tempo"
    t.string   "situacao_financeira"
    t.boolean  "com_pendencia_financeira", default: false
    t.boolean  "bloqueado",                default: false
  end

  add_index "pesquisas", ["cliente_id"], name: "index_pesquisas_on_cliente_id", using: :btree
  add_index "pesquisas", ["empresa_id"], name: "index_pesquisas_on_empresa_id", using: :btree
  add_index "pesquisas", ["user_id"], name: "index_pesquisas_on_user_id", using: :btree

  create_table "propostas", force: :cascade do |t|
    t.integer  "pacote_id"
    t.string   "tipo_mensalidade"
    t.decimal  "valor_mensalidade",         precision: 14, scale: 2
    t.string   "tipo_implantacao"
    t.decimal  "valor_implantacao",         precision: 14, scale: 2
    t.string   "observacao"
    t.integer  "qtde_parcela"
    t.decimal  "valor_parcelas"
    t.datetime "created_at",                                                        null: false
    t.datetime "updated_at",                                                        null: false
    t.integer  "empresa_id"
    t.integer  "user_id"
    t.integer  "formas_pagamento_id"
    t.integer  "cliente_id"
    t.date     "data"
    t.boolean  "ativa",                                              default: true
    t.date     "data_primeira_mensalidade"
    t.boolean  "fidelidade"
    t.integer  "meses_fidelidade"
    t.integer  "qtd_maquinas"
  end

  add_index "propostas", ["cliente_id"], name: "index_propostas_on_cliente_id", using: :btree
  add_index "propostas", ["empresa_id"], name: "index_propostas_on_empresa_id", using: :btree
  add_index "propostas", ["formas_pagamento_id"], name: "index_propostas_on_formas_pagamento_id", using: :btree
  add_index "propostas", ["pacote_id"], name: "index_propostas_on_pacote_id", using: :btree
  add_index "propostas", ["user_id"], name: "index_propostas_on_user_id", using: :btree

  create_table "receitaws_contas", force: :cascade do |t|
    t.string   "nome"
    t.string   "chave"
    t.integer  "qtd_disponivel"
    t.integer  "qtd_usada"
    t.date     "dia_renovacao"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "servicos", force: :cascade do |t|
    t.string   "nome_servico"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.boolean  "ativo"
    t.integer  "ordem"
    t.integer  "tipocobranca_id"
  end

  create_table "setores", force: :cascade do |t|
    t.string   "nome_setor"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.boolean  "ativo"
    t.integer  "ordem"
    t.integer  "setor_financeiro_id"
    t.string   "tipo_setor"
  end

  create_table "sistema_terceiros", force: :cascade do |t|
    t.string   "nome"
    t.string   "empresa"
    t.decimal  "mensalidade"
    t.string   "observacao"
    t.integer  "cliente_id"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "sistema_terceiros", ["cliente_id"], name: "index_sistema_terceiros_on_cliente_id", using: :btree
  add_index "sistema_terceiros", ["user_id"], name: "index_sistema_terceiros_on_user_id", using: :btree

  create_table "sistemas", force: :cascade do |t|
    t.string   "nome"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "tempo_inerte"
  end

  create_table "solicitacao_bancos", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "cliente_id"
    t.integer  "tipo"
    t.datetime "finalizado"
    t.string   "motivo_solicitacao"
    t.string   "observacao"
    t.string   "motivo_desativacao"
    t.boolean  "ativo",                          default: true
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "status"
    t.integer  "responsavel_id"
    t.datetime "data_desativado"
    t.integer  "desativado_por_id"
    t.string   "link_request"
    t.integer  "local_banco"
    t.integer  "empresa_id"
    t.string   "nome_solicitante"
    t.string   "email_solicitante"
    t.string   "cnpj_parceiro"
    t.string   "socio_admin"
    t.string   "telefone1"
    t.string   "telefone2"
    t.string   "regime"
    t.string   "sistema"
    t.decimal  "valor_mensalidade"
    t.date     "data_vencimento"
    t.decimal  "valor_implantacao"
    t.string   "telefone_parceiro"
    t.string   "email_cliente"
    t.date     "data_implantacao"
    t.boolean  "nota_fiscal_modulo",             default: false
    t.boolean  "nota_fiscal_consumidor_modulo",  default: false
    t.boolean  "conhecimento_transporte_modulo", default: false
    t.boolean  "manifesto_eletronico_modulo",    default: false
    t.boolean  "nota_fiscal_servico_modulo",     default: false
    t.boolean  "consulta_modulo",                default: false
    t.boolean  "cupom_fiscal_modulo",            default: false
    t.string   "username"
    t.string   "password"
    t.string   "nome_usuario"
    t.integer  "contribuinte_icms"
    t.string   "inscricao_estadual"
    t.string   "file"
    t.string   "motivo_erro"
    t.boolean  "ncm_importado",                  default: false
    t.boolean  "parametro_ncm_importado",        default: false
  end

  add_index "solicitacao_bancos", ["desativado_por_id"], name: "index_solicitacao_bancos_on_desativado_por_id", using: :btree
  add_index "solicitacao_bancos", ["empresa_id"], name: "index_solicitacao_bancos_on_empresa_id", using: :btree
  add_index "solicitacao_bancos", ["responsavel_id"], name: "index_solicitacao_bancos_on_responsavel_id", using: :btree

  create_table "solicitacao_desistencias", force: :cascade do |t|
    t.integer  "cliente_id"
    t.integer  "empresa_id"
    t.integer  "user_id"
    t.string   "status"
    t.datetime "data_solicitacao"
    t.string   "motivo_solicitacao"
    t.string   "solicitante"
    t.string   "telefone"
    t.string   "motivo_ficou"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.json     "tags"
    t.string   "cnpj"
    t.string   "nome_solicitante"
    t.string   "email_solicitante"
    t.string   "motivo_desistencia"
    t.datetime "data_inicio"
    t.datetime "data_recuperado"
    t.datetime "data_desistencia"
  end

  add_index "solicitacao_desistencias", ["cliente_id"], name: "index_solicitacao_desistencias_on_cliente_id", using: :btree
  add_index "solicitacao_desistencias", ["empresa_id"], name: "index_solicitacao_desistencias_on_empresa_id", using: :btree
  add_index "solicitacao_desistencias", ["user_id"], name: "index_solicitacao_desistencias_on_user_id", using: :btree

  create_table "status", force: :cascade do |t|
    t.string   "descricao"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "tipo",           default: "CLIENTE"
    t.boolean  "fechamento",     default: false
    t.integer  "status_empresa"
    t.integer  "tipo_status",    default: 1
    t.boolean  "descartada"
  end

  create_table "status_ligacoes", force: :cascade do |t|
    t.string   "descricao"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags_solicitacao_desistencias", force: :cascade do |t|
    t.string "descricao"
  end

  create_table "telefones", force: :cascade do |t|
    t.string   "telefone"
    t.integer  "tipo"
    t.boolean  "preferencial",    default: false
    t.boolean  "enviado_whats",   default: false
    t.integer  "contato_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "ativo",           default: true
    t.boolean  "respondeu_whats", default: false
  end

  add_index "telefones", ["contato_id"], name: "index_telefones_on_contato_id", using: :btree

  create_table "tipo_agendamentos", force: :cascade do |t|
    t.string   "descricao"
    t.string   "cor"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.boolean  "ativo",      default: true
  end

  create_table "tipo_fechamentos", force: :cascade do |t|
    t.string   "descricao"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                          default: "",    null: false
    t.string   "encrypted_password",             default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                  default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "avatar"
    t.string   "name"
    t.boolean  "admin"
    t.boolean  "active",                         default: true
    t.string   "color"
    t.integer  "permissao_id"
    t.integer  "job_id"
    t.integer  "implantacao_id"
    t.boolean  "em_atendimento",                 default: false
    t.boolean  "notificacao_agenda_cancelada",   default: false
    t.boolean  "notificacao_implantacao",        default: false
    t.boolean  "notificacao_implantacao_atraso", default: false
    t.integer  "tipo_comissao"
    t.boolean  "ocupado",                        default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["permissao_id"], name: "index_users_on_permissao_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "whatsapp_numeros", force: :cascade do |t|
    t.string   "numero"
    t.string   "status"
    t.integer  "campanha_id"
<<<<<<< HEAD
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.string   "nome",           limit: 255
    t.integer  "user_id"
    t.boolean  "banido",                     default: false
    t.datetime "data_banimento"
    t.boolean  "is_docker"
=======
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.string   "nome",                  limit: 255
    t.integer  "user_id"
    t.boolean  "banido",                            default: false
    t.datetime "data_banimento"
    t.boolean  "chat_pro"
    t.string   "instancia_id"
    t.string   "token_chat_pro"
    t.boolean  "is_docker"
    t.boolean  "is_ocultado",                       default: false
    t.datetime "data_inicio_ocultacao"
    t.integer  "tempo_ocultacao"
>>>>>>> master
  end

  add_index "whatsapp_numeros", ["campanha_id"], name: "index_whatsapp_numeros_on_campanha_id", using: :btree
  add_index "whatsapp_numeros", ["user_id"], name: "index_whatsapp_numeros_on_user_id", using: :btree

  add_foreign_key "acompanhamentos", "clientes"
  add_foreign_key "acompanhamentos", "empresas"
  add_foreign_key "acompanhamentos", "propostas"
  add_foreign_key "acompanhamentos", "users"
  add_foreign_key "agendamento_retornos", "acompanhamentos"
  add_foreign_key "agendamento_retornos", "clientes"
  add_foreign_key "agendamento_retornos", "empresas"
  add_foreign_key "agendamento_retornos", "implantacoes"
  add_foreign_key "agendamento_retornos", "ligacoes"
  add_foreign_key "agendamento_retornos", "users"
  add_foreign_key "agendamentos", "clientes"
  add_foreign_key "agendamentos", "empresas"
  add_foreign_key "agendamentos", "implantacoes"
  add_foreign_key "agendamentos", "tipo_agendamentos"
  add_foreign_key "agendamentos", "users"
  add_foreign_key "anexos", "clientes"
  add_foreign_key "campanha_envios", "abordagem_iniciais"
  add_foreign_key "campanha_envios", "clientes"
  add_foreign_key "campanhas", "empresas"
  add_foreign_key "cidades", "estados"
  add_foreign_key "clientes", "cidades"
  add_foreign_key "clientes", "cnaes"
  add_foreign_key "clientes", "empresas"
  add_foreign_key "clientes", "escritorios"
  add_foreign_key "clientes", "importacoes"
  add_foreign_key "clientes", "status"
  add_foreign_key "cnae_clientes", "clientes"
  add_foreign_key "cnae_clientes", "cnaes"
  add_foreign_key "comentarios", "acompanhamentos"
  add_foreign_key "comentarios", "agendamentos"
  add_foreign_key "comentarios", "clientes"
  add_foreign_key "comentarios", "implantacoes"
  add_foreign_key "comentarios", "negociacoes"
  add_foreign_key "comentarios", "users"
  add_foreign_key "contatos", "clientes"
  add_foreign_key "contatos", "escritorios"
  add_foreign_key "controle_job_cliente_restantes", "clientes"
  add_foreign_key "controle_job_cliente_restantes", "controle_jobs"
  add_foreign_key "controle_job_clientes", "clientes"
  add_foreign_key "controle_job_clientes", "controle_jobs"
  add_foreign_key "controle_jobs", "empresas"
  add_foreign_key "empresas", "cidades"
  add_foreign_key "escritorios", "cidades"
  add_foreign_key "escritorios", "empresas"
  add_foreign_key "escritorios", "status"
  add_foreign_key "escritorios", "users"
  add_foreign_key "fechamentos", "clientes"
  add_foreign_key "fechamentos", "empresas"
  add_foreign_key "fechamentos", "propostas"
  add_foreign_key "fechamentos", "status"
  add_foreign_key "fechamentos", "tipo_fechamentos"
  add_foreign_key "fechamentos", "users"
  add_foreign_key "fila_empresas", "clientes"
  add_foreign_key "fila_empresas", "empresas"
  add_foreign_key "formas_pagamento", "empresas"
  add_foreign_key "gruber_pesquisa_respostas", "gruber_pesquisas"
  add_foreign_key "gruber_pesquisa_respostas", "servicos"
  add_foreign_key "gruber_pesquisa_respostas", "setores"
  add_foreign_key "implantacoes", "clientes"
  add_foreign_key "implantacoes", "empresas"
  add_foreign_key "implantacoes", "propostas"
  add_foreign_key "implantacoes", "users"
  add_foreign_key "importacoes", "empresas"
  add_foreign_key "importacoes", "estados"
  add_foreign_key "importacoes", "users"
  add_foreign_key "lembretes", "empresas"
  add_foreign_key "ligacoes", "agendamento_retornos"
  add_foreign_key "ligacoes", "clientes"
  add_foreign_key "ligacoes", "empresas"
  add_foreign_key "ligacoes", "escritorios"
  add_foreign_key "ligacoes", "status_ligacoes"
  add_foreign_key "ligacoes", "users"
  add_foreign_key "nao_perturbe_retornos", "users"
  add_foreign_key "negociacoes", "clientes"
  add_foreign_key "negociacoes", "empresas"
  add_foreign_key "negociacoes", "status"
  add_foreign_key "negociacoes", "users"
  add_foreign_key "notificacoes", "empresas"
  add_foreign_key "notificacoes", "users"
  add_foreign_key "pacotes", "empresas"
  add_foreign_key "pacotes", "sistemas"
  add_foreign_key "parametros", "empresas"
  add_foreign_key "pergunta_cliente_resposta_tags", "pergunta_cliente_respostas"
  add_foreign_key "pergunta_cliente_respostas", "clientes"
  add_foreign_key "pergunta_cliente_respostas", "perguntas"
  add_foreign_key "pergunta_pesquisa_respostas", "perguntas"
  add_foreign_key "pergunta_pesquisa_respostas", "pesquisas"
  add_foreign_key "periodo_inertes", "clientes"
  add_foreign_key "periodo_inertes", "empresas"
  add_foreign_key "pesquisas", "clientes"
  add_foreign_key "pesquisas", "empresas"
  add_foreign_key "pesquisas", "users"
  add_foreign_key "propostas", "clientes"
  add_foreign_key "propostas", "empresas"
  add_foreign_key "propostas", "pacotes"
  add_foreign_key "propostas", "users"
  add_foreign_key "sistema_terceiros", "clientes"
  add_foreign_key "sistema_terceiros", "users"
  add_foreign_key "solicitacao_bancos", "empresas"
  add_foreign_key "solicitacao_bancos", "users", column: "desativado_por_id"
  add_foreign_key "solicitacao_bancos", "users", column: "responsavel_id"
  add_foreign_key "solicitacao_desistencias", "clientes"
  add_foreign_key "solicitacao_desistencias", "empresas"
  add_foreign_key "solicitacao_desistencias", "users"
  add_foreign_key "telefones", "contatos"
  add_foreign_key "users", "permissoes"
  add_foreign_key "whatsapp_numeros", "campanhas"
  add_foreign_key "whatsapp_numeros", "users"
end
