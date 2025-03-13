class Notificacao < ActiveRecord::Base
  belongs_to :user
  belongs_to :empresa
  belongs_to :user_registro, class_name: 'User'

  scope :notificacoes_user, ->(user) { where(user: user).where("(((data_hora - interval '10 minutes') < ?) )", Time.now) }
  scope :empresa, ->(empresa) { where(empresa: empresa) }
  scope :fechamento_outras_empresas, ->(empresa) { where(tipo: 'FECHAMENTO').where.not(empresa: empresa) }
  scope :nao_lidas, -> { where(lido: false) }
  scope :nao_visualizadas, -> { where(visualizada: false) }
  scope :chrome, -> { where(tipo: ['IMPLANTACAO', 'IMPLANTACAO_ATRASADA_20', 'IMPLANTACAO_ATRASADA_30', 'AGENDA_CANCELADA', 'IMPLANTACAO_ALTERACAO']) }


  def self.criar_notificacao(tipo, user_id, user_registro_id, observacao, datahora, empresa_id, modelo_id, title, path, tipo_fechamento)
      Notificacao.create!(user_id: user_id, user_registro_id: user_registro_id, tipo: tipo, observacao: observacao,
                         lido: false, data_hora: datahora, empresa_id: empresa_id, visualizada: false, modelo_id: modelo_id, title: title,
                        path: path, tipo_fechamento: tipo_fechamento)
  end

  def self.processar_notificacoes
    connection = ActiveRecord::Base.connection
    implantacoes = connection.select_all ImplantacoesHelper.sql_notificacao_implantacao

    criar_notificacao_implantacoes false, implantacoes

    implantacoes = connection.select_all ImplantacoesHelper.sql_notificacao_implantacao_atrasado 20

    criar_notificacao_implantacoes true, implantacoes

    implantacoes = connection.select_all ImplantacoesHelper.sql_notificacao_implantacao_atrasado 30

    criar_notificacao_implantacoes true, implantacoes
  end

  def self.criar_notificacao_implantacoes atrasado, implantacoes
    implantacoes.each do |implantacao|
      if implantacao['user_id'].present?
          criar_notificacao implantacao['tipo'], implantacao['user_id'], implantacao['user_id'],
                            criar_observacao(implantacao['tipo'], implantacao['data_agenda'], implantacao['razao_social'], implantacao['tipo_agenda']),
                            implantacao['data_agenda'], implantacao['empresa_id'], implantacao['implantacao_id'], 'Agenda!', "../agenda?agenda_index_id=#{ implantacao['id_agenda']}", nil
      end
      if atrasado
         criar_notificacao implantacao['tipo'], implantacao['vendedor_id'], implantacao['vendedor_id'],
                            criar_observacao(implantacao['tipo'], implantacao['data_agenda'], implantacao['razao_social'], implantacao['tipo_agenda']),
                            implantacao['data_agenda'], implantacao['empresa_id'], implantacao['implantacao_id'], 'Agenda!', "../agenda?agenda_index_id=#{ implantacao['id_agenda']}",nil

        adms = User.where(admin: true, active: true)
        adms.each do |user|
          if user.notificacao_implantacao_atraso?
            criar_notificacao implantacao['tipo'], user.id, user.id,
                              criar_observacao(implantacao['tipo'], implantacao['data_agenda'], implantacao['razao_social'], implantacao['tipo_agenda']),
                              implantacao['data_agenda'], implantacao['empresa_id'], implantacao['implantacao_id'], 'Agenda!', "../agenda?agenda_index_id=#{ implantacao['id_agenda']}",nil
          end
        end
      end
    end
  end

  def self.criar_observacao(tipo, horario, cliente, tipo_agenda)
    case tipo
      when 'IMPLANTACAO'
        "Agendamento de #{ tipo } marcado para às #{ horario } com o cliente #{ cliente }."
      when 'IMPLANTACAO_ATRASADA_20'
        "Agendamento atrasado à mais de 20 minutos de #{ tipo_agenda } marcado para às #{ Time.parse(horario).strftime("%d/%m/%Y %H:%M ") } com o cliente #{ cliente }."
      when 'IMPLANTACAO_ATRASADA_30'
        "Agendamento atrasado à mais de 30 minutos de #{ tipo_agenda } marcado para às #{ Time.parse(horario).strftime("%d/%m/%Y %H:%M ")  } com o cliente #{ cliente }."
      else
       ""
    end
  end

  def self.finalizar_notificacoes
    notificacoes = Notificacao.where(visualizada: false)

    notificacoes.each do |notificacao|
      notificacao.update(lido: true, visualizada: true)
    end
  end

  def self.criar_notificacoes_efetivacao(acompanhamento, current_user)
    user_fechamento = acompanhamento.cliente.fechamento.user
    if user_fechamento.present?
      notificacao = Notificacao.where(tipo: 'EFETIVACAO', modelo_id: acompanhamento.id, user_id: user_fechamento.id).first
      if notificacao.nil?
        criar_notificacao 'EFETIVACAO', user_fechamento.id, current_user.id,
                          "Cliente #{acompanhamento.cliente.razao_social},#{ acompanhamento.cliente.status.descricao},Mens. #{  ActionController::Base.helpers.number_to_currency(acompanhamento.proposta.valor_mensalidade)},#{acompanhamento.proposta.pacote.sistema.nome}",
                          Time.now, acompanhamento.empresa_id, acompanhamento.id, 'Efetivação!', "../acompanhamentos/#{acompanhamento.id}", nil
      end
    end

    user_implantacao = acompanhamento.cliente.implantacao.user
    if user_implantacao.present?
      notificacao = Notificacao.where(tipo: 'EFETIVACAO', modelo_id: acompanhamento.id, user_id: user_implantacao.id).first
      if notificacao.nil?
        criar_notificacao 'EFETIVACAO', user_implantacao.id, current_user.id,
                          "Cliente #{acompanhamento.cliente.razao_social},#{ acompanhamento.cliente.status.descricao},Mens. #{  ActionController::Base.helpers.number_to_currency(acompanhamento.proposta.valor_mensalidade)},#{acompanhamento.proposta.pacote.sistema.nome}",
                          Time.now, acompanhamento.empresa_id, acompanhamento.id, 'Efetivação!', "../acompanhamentos/#{acompanhamento.id}", nil
      end
    end


    adms = User.where(admin: true, active: true)
    adms.each do |user|
      notificacao = Notificacao.where(tipo: 'EFETIVACAO', modelo_id: acompanhamento.id, user_id: user.id).first
      if notificacao.nil?
        criar_notificacao 'EFETIVACAO', user.id, current_user.id,
                          "Cliente #{acompanhamento.cliente.razao_social},#{ acompanhamento.cliente.status.descricao},Mens. #{  ActionController::Base.helpers.number_to_currency(acompanhamento.proposta.valor_mensalidade)},#{acompanhamento.proposta.pacote.sistema.nome}",
                          Time.now, acompanhamento.empresa_id, acompanhamento.id, 'Efetivação!', "../acompanhamentos/#{acompanhamento.id}", nil
      end
    end
  end

  def self.criar_notificacoes_desativacao(acompanhamento, current_user)
    user_fechamento = acompanhamento.cliente.fechamento.user
    if user_fechamento.present?
      notificacao = Notificacao.where(tipo: 'DESATIVACAO', modelo_id: acompanhamento.id, user_id: user_fechamento.id).first
      if notificacao.nil?
        criar_notificacao 'DESATIVACAO', user_fechamento.id, current_user.id,
                          "Cliente #{acompanhamento.cliente.razao_social},#{ acompanhamento.cliente.status.descricao},Mens. #{  ActionController::Base.helpers.number_to_currency(acompanhamento.proposta.valor_mensalidade)},#{acompanhamento.proposta.pacote.sistema.nome}",
                          Time.now, acompanhamento.empresa_id, acompanhamento.id, 'Desativação!', "../acompanhamentos/#{acompanhamento.id}", tipo_fechamento
      end
    end

    user_implantacao = acompanhamento.cliente.implantacao.user
    if user_implantacao.present?
      notificacao = Notificacao.where(tipo: 'DESATIVACAO', modelo_id: acompanhamento.id, user_id: user_implantacao.id).first
      if notificacao.nil?
        criar_notificacao 'DESATIVACAO', user_implantacao.id, current_user.id,
                          "Cliente #{acompanhamento.cliente.razao_social},#{ acompanhamento.cliente.status.descricao},Mens. #{  ActionController::Base.helpers.number_to_currency(acompanhamento.proposta.valor_mensalidade)},#{acompanhamento.proposta.pacote.sistema.nome}",
                          Time.now, acompanhamento.empresa_id, acompanhamento.id, 'Desativação!', "../acompanhamentos/#{acompanhamento.id}", tipo_fechamento
      end
    end


    adms = User.where(admin: true, active: true)
    adms.each do |user|
      notificacao = Notificacao.where(tipo: 'DESATIVACAO', modelo_id: acompanhamento.id, user_id: user.id).first
      if notificacao.nil?
        criar_notificacao 'DESATIVACAO', user.id, current_user.id,
                          "Cliente #{acompanhamento.cliente.razao_social},#{ acompanhamento.cliente.status.descricao},Mens. #{  ActionController::Base.helpers.number_to_currency(acompanhamento.proposta.valor_mensalidade)},#{acompanhamento.proposta.pacote.sistema.nome}",
                          Time.now, acompanhamento.empresa_id, acompanhamento.id, 'Desativação!', "../acompanhamentos/#{acompanhamento.id}", tipo_fechamento
      end
    end
  end

  def self.criar_notificacoes_desistencia(desistencia, current_user, cliente_fin)
    adms = User.where(admin: true, active: true)
    adms.each do |user|
      notificacao = Notificacao.where(tipo: 'SOLICITACAO_DESATIVACAO', modelo_id: desistencia.cliente.id, user_id: user.id).first
      fechamento = Fechamento.where(cliente_id: desistencia.cliente.id).first
      if notificacao.nil?
        criar_notificacao 'SOLICITACAO_DESATIVACAO', user.id, current_user.id,
                          "#{desistencia.cliente.razao_social},#{ desistencia.cliente.status.descricao},Mens. #{  cliente_fin['valor_mensalidade']},#{cliente_fin['sistema']},#{desistencia.cliente.cnpj},#{desistencia.cliente.cidade},#{fechamento.user.name} ",
                          Time.now, desistencia.empresa_id, desistencia.id, 'Desativação!', "../solicitacao_desistencia/#{desistencia.id}", 'SOLICITACAO_DESATIVACAO'
      end
    end

  end

  def self.criar_notificacoes_implantacao(implantacao, current_user)
    user_fechamento = implantacao.cliente.fechamento.user
    if user_fechamento.present?
      notificacao = Notificacao.where(tipo: 'IMPLANTACAO', modelo_id: implantacao.id, user_id: user_fechamento.id).first
      if notificacao.nil?
        criar_notificacao 'IMPLANTACAO', user_fechamento.id, current_user.id,
                          "Cliente #{implantacao.cliente.razao_social},#{ implantacao.cliente.status.descricao},Mens. #{  ActionController::Base.helpers.number_to_currency(implantacao.proposta.valor_mensalidade)},#{implantacao.proposta.pacote.sistema.nome}",
                          Time.now, implantacao.empresa_id, implantacao.id, 'Implantação!', "../implantacoes/#{implantacao.id}", nil
      end
    end

    adms = User.where(admin: true, active: true)
    adms.each do |user|
      notificacao = Notificacao.where(tipo: 'IMPLANTACAO', modelo_id: implantacao.id, user_id: user.id).first
      if notificacao.nil?
        criar_notificacao 'IMPLANTACAO', user.id, current_user.id,
                          "Cliente #{implantacao.cliente.razao_social},#{ implantacao.cliente.status.descricao},Mens. #{  ActionController::Base.helpers.number_to_currency(implantacao.proposta.valor_mensalidade)},#{implantacao.proposta.pacote.sistema.nome}",
                          Time.now, implantacao.empresa_id, implantacao.id, 'Implantação!', "../implantacoes/#{implantacao.id}", nil
      end
    end
  end

  def self.criar_notificacao_arquivo_retorno(empresa_desc, empresa_id)
    adms = User.where(admin: true, active: true)
    empresa_desc = empresa_desc.force_encoding('iso-8859-1').encode('utf-8')
    adms.each do |user|
        criar_notificacao 'ARQUIVO_RETORNO', user.id, empresa_id,
                          "Importado arquivo de retorno, #{empresa_desc}",
                          Time.now, empresa_id, nil, 'Arquivo retorno!', "../dashboards/resultados", nil
    end
  end

  def self.criar_notificacao_centro_distribuicao(resultadoJob0, resultadoJob1, resultadoJob2, total)
    adms = User.where(admin: true, active: true)
    adms.each do |user|
      criar_notificacao 'CENTRO_DISTRIBUICAO', user.id, nil,
                        "Filas geradas job0: #{resultadoJob0},Filas geradas job1: #{resultadoJob1}, Filas geradas job2: #{resultadoJob2}, Total: #{total}",
                        Time.now, nil, nil, 'Filas Geradas CD!', "../dashboards/empresas_centro_distribuicao", nil
    end
  end

  def self.criar_notificacao_numero_desconectado(numero, nome, dias)
    adms = User.where(admin: true, active: true)
    adms.each do |user|
      puts user.name
      criar_notificacao 'NUMERO_DESCONECTADO', user.id, nil,
                        "Número desconectado: #{numero}, Nome: #{nome}, Dias maturados: #{dias.to_i}",
                        Time.now, nil, nil, 'Whatsapp', "../whatsapp_numeros", nil
    end
  end

end
