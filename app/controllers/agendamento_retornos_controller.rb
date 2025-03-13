class AgendamentoRetornosController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
  end

  def retornos_acompanhamento
  end

  def retornos_implantacao
  end

  def show
    retorno = AgendamentoRetorno.find params[:id]

    render json: retorno
  end

  def get_retornos
    connection = ActiveRecord::Base.connection

    if params[:tipo].eql? 'implantacao'
      sql = AgendamentoRetornosHelper.get_sql_retornos_implantacao current_empresa.id, params[:responsavel], params[:cliente], params[:filtro],
                                                       params[:cidade],
                                                       (params[:preferencial] == '0' ? nil: params[:preferencial])
    elsif params[:tipo].eql? 'acompanhamento'
      sql = AgendamentoRetornosHelper.get_sql_retornos_acompanhamento nil, params[:responsavel], params[:cliente], params[:filtro],
                                                                   params[:cidade],
                                                                   (params[:preferencial] == '0' ? nil: params[:preferencial])
    else
      sql = AgendamentoRetornosHelper.get_sql_retornos current_empresa.id, params[:responsavel], params[:cliente], params[:filtro],
                                                       params[:cidade], params[:qtd], params[:telefone],
                                                       (params[:preferencial] == '0' ? nil: params[:preferencial])
    end


    lista = connection.select_all sql

    if params[:tipo].eql? 'acompanhamento'
      lista = lista.to_hash
      lista.each do |empr|
        acompanhamento = Acompanhamento.find empr['acompanhamento_id'].strip
        if acompanhamento.present?
          empr['dias_sem_uso'] = acompanhamento.dias_sem_uso
        else
          empr['dias_sem_uso'] = 'Sem info.'
        end
      end
    end

    render json: lista
  end

  def create
    hora = Time.parse(agendamento_params[:data_agendamento_retorno])
    if hora.hour < 8 || hora.hour > 21
      return render json: 'FORA_HORARIO'.to_json, :status => 422
    end

    #deixei pra salvar na parte de finalizar ligacao
    #unless agendamento_params[:obs_ligacao].nil?
      #ligacao = Ligacao.find agendamento_params[:ligacao_id]
      #ligacao.observacao = agendamento_params[:obs_ligacao]
      #ligacao.save
    #end
    
    @retorno = AgendamentoRetorno.new
    @retorno.data_agendamento_retorno = agendamento_params[:data_agendamento_retorno]
    @retorno.ligacao_id = agendamento_params[:ligacao_id]
    @retorno.cliente_id = agendamento_params[:cliente_id]
    @retorno.empresa = @retorno.cliente.empresa
    @retorno.user ||= current_user
    respond_to do |format|
      if @retorno.save

        retornos = AgendamentoRetorno.where(cliente_id: @retorno.cliente_id, empresa_id: @retorno.empresa_id, cancelado: false, data_efetuado_retorno: nil).where('id != ?', @retorno.id)
        retornos.update_all(motivo: 'Reagendado.', cancelado: true, usuario_cancelamento_id: @retorno.user_id)

        format.json { render json: @retorno }
      else
        format.html { render json: @retorno.errors }
      end
    end
  end

  def proximo_retorno_usuario
    return render json: nil if current_user.em_atendimento?
    return render json: nil if Cliente.where(user_atendimento: current_user, em_atendimento: true, empresa_id: current_empresa.id).limit(1).first.present?

    connection = ActiveRecord::Base.connection

    sql = NotificacoesHelper.get_notificacoes_obrigatorias current_user.id

    retornos = connection.select_all sql

    return render json: nil if retornos.count == 0
    retornos[0][:ocupado] = current_user.ocupado
    render json: retornos[0]
  end

  def set_retorno_andamento
    current_user.update(em_atendimento: true)

    render json: current_user
  end

  def reagendar_retorno_negociacao
    hora = Time.parse(params[:data_agendamento_retorno])
    if hora.hour < 8 || hora.hour > 21
      return render json: 'FORA_HORARIO'.to_json, :status => 422
    end

    negociacao = Negociacao.find params[:negociacao_id]
    
    # Tarefa 10316 pediu para prosseguir com senha caso a data seja maior que 72hrs
    # if negociacao.present? && negociacao.atendimento_whatsapp? && TimeDifference.between(hora, Time.now).in_hours > 72
    #   return render json: '72_HORAS'.to_json, :status => 422
    # end
    
    if params[:negociador].present?
      user = User.find params[:negociador]
      negociacao.user = user
      negociacao.create_activity(:responsavel, owner: current_user, recipient: negociacao , params: {responsavel: negociacao.user_id})
      negociacao.save
    end    

    retornos = AgendamentoRetorno.where(cliente_id: negociacao.cliente_id, empresa_id: negociacao.empresa_id, cancelado: false, data_efetuado_retorno: nil)
    retornos.update_all(motivo: params[:motivo], cancelado: true, usuario_cancelamento_id: current_user.id)

    retorno = retornos[0]
    novo_retorno = AgendamentoRetorno.create(empresa: negociacao.empresa, user: negociacao.user, data_agendamento_retorno: params[:data_agendamento_retorno], cliente: negociacao.cliente, ligacao: (retorno.present? ? retorno.ligacao : nil), cancelado: false)

    novo_retorno.cliente.negociacao.create_activity(:retorno_reagendado, owner: current_user, recipient: negociacao , params: {motivo: params[:motivo], data: novo_retorno.data_agendamento_retorno}) if negociacao.present?

    current_user.update(em_atendimento: false)
    render json: novo_retorno
  end

  def reagendar_retorno_implantacao
    hora = Time.parse(params[:data_agendamento_retorno])
    if hora.hour < 8 || hora.hour > 21
      return render json: 'FORA_HORARIO'.to_json, :status => 422
    end

    implantacao = Implantacao.find params[:implantacao_id]

    retornos = AgendamentoRetorno.where(cliente_id: implantacao.cliente_id, empresa_id: implantacao.empresa_id, cancelado: false, data_efetuado_retorno: nil)

    retorno = retornos[0]

    retornos.update_all(motivo: params[:motivo], cancelado: true, usuario_cancelamento_id: current_user.id)

    novo_retorno = AgendamentoRetorno.create(empresa: implantacao.empresa, user_id: retorno.user_id, data_agendamento_retorno: params[:data_agendamento_retorno], cliente: implantacao.cliente, implantacao: implantacao, cancelado: false)

    implantacao.create_activity(:retorno_reagendado, owner: current_user, recipient: implantacao , params: {motivo: params[:motivo], data: novo_retorno.data_agendamento_retorno}) if implantacao.present?

    current_user.update(em_atendimento: false)
    render json: novo_retorno
  end

  def reagendar_retorno_acompanhamento
    hora = Time.parse(params[:data_agendamento_retorno])
    if hora.hour < 8 || hora.hour > 21
      return render json: 'FORA_HORARIO'.to_json, :status => 422
    end

    acompanhamento = Acompanhamento.find params[:acompanhamento_id]

    retornos = AgendamentoRetorno.where(acompanhamento_id: acompanhamento.id, cancelado: false, data_efetuado_retorno: nil)

    retorno = retornos[0]

    retornos.update_all(motivo: params[:motivo], cancelado: true, usuario_cancelamento_id: current_user.id)

    novo_retorno = AgendamentoRetorno.create(empresa: acompanhamento.empresa, user_id: retorno.user_id, data_agendamento_retorno: params[:data_agendamento_retorno], cliente: acompanhamento.cliente, acompanhamento: acompanhamento, cancelado: false)

    acompanhamento.create_activity(:retorno_reagendado, owner: current_user, recipient: acompanhamento , params: {motivo: params[:motivo], data: novo_retorno.data_agendamento_retorno}) if acompanhamento.present?

    current_user.update(em_atendimento: false)
    render json: novo_retorno
  end

  def cancelar_retorno
    retorno = AgendamentoRetorno.find params[:id]
    retorno.motivo = params[:motivo]
    retorno.cancelado = true
    retorno.usuario_cancelamento = current_user
    retorno.data_cancelamento = Time.now

    retorno.save

    render json: retorno
  end

  def retornos_cancelados
    connection = ActiveRecord::Base.connection

    sql = AgendamentoRetornosHelper.retornos_cancelados params[:data_inicio], params[:data_fim],
                                                      params[:empresa], params[:vendedor], params[:cliente],
                                                      params[:conferido], params[:atrasado]

    @retornos = connection.select_all sql

    render json: @retornos, status: 200
  end

  def conferir
    @retorno = AgendamentoRetorno.find params[:id]
    @retorno.update(conferido: true)
    @retorno.create_activity(:conferido, owner: current_user, recipient: @retorno)

    render json: @retorno, status: 200
  end

  def baixar
    @retorno = AgendamentoRetorno.find params[:id]
    @retorno.update(baixado: true)
    @retorno.create_activity(:baixado, owner: current_user, recipient: @retorno)

    render json: @retorno, status: 200
  end

  def recuperar
    @retorno = AgendamentoRetorno.find params[:id]

    user = User.find params[:operador] if  params[:operador].present?

    if user.present?  && user !=  @retorno.user
      @retorno.create_activity(:responsavel, owner: current_user, recipient: @retorno , params: {responsavel: user.id})
      @retorno.update(user_id: user.id);
    end

    @retorno.update(baixado: false, conferido: false, data_cancelamento: nil, usuario_cancelamento_id: nil, motivo: nil,
                    cancelado: false, data_agendamento_retorno: params[:retorno])
    @retorno.create_activity(:recuperada, owner: current_user, recipient: @retorno, params: { comentario: params[:comentario]})

    render json: @retorno, status: 200
  end

  def activities
    retorno = AgendamentoRetorno.find params[:id]

    @activities = PublicActivity::Activity.where(recipient_id: retorno.id, recipient_type: "AgendamentoRetorno").order("created_at desc")

    render :partial => 'agendamento_retornos/modals/activities'
  end

  def verificar_horario_acompanhamento
    agendas = AgendamentoRetorno.where(user_id: current_user.id, data_efetuado_retorno: nil).where("? between (data_agendamento_retorno - interval '4 minute') and (data_agendamento_retorno + interval '4 minute') and acompanhamento_id is not null", Time.parse(params[:data_retorno]))

    render json: agendas.count
  end

  def novo_retorno_acompanhamento
    hora = Time.parse(params[:data_retorno])
    if hora.hour < 8 || hora.hour > 21
      return render json: 'FORA_HORARIO'.to_json, :status => 422
    end

    acompanhamento = Acompanhamento.find params[:acompanhamento_id]
    return render json: 'ACOMPANHAMENTO NÃO LOCALIZADO'.to_json, :status => 422 if acompanhamento.nil?

    novo_retorno = AgendamentoRetorno.create(empresa: acompanhamento.empresa, user_id: params[:user_id], data_agendamento_retorno: params[:data_retorno], cliente: acompanhamento.cliente, acompanhamento: acompanhamento, cancelado: false)
    render json: novo_retorno, status: 200
  end

  private

  def agendamento_params
    params.require(:retorno).permit(:cancelado, :data_efetuado_retorno, :empresa_id, :user_id, :data_agendamento_retorno, :motivo,
                                    :usuario_cancelamento, :ligacao_id, :cliente_id, :acompanhamento_id, :negociador_id,
                                    :obs_ligacao)
  end

end
