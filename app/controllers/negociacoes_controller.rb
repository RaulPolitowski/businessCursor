class NegociacoesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_negociacao, only: [:show, :cancelar, :conferir, :baixar, :recuperar]

  def index
  end

  def show
    respond_to do |format|
      format.html { render nothing }
      format.json { render json: @negociacao, status: 200 }
    end
  end

  def update
    negociacao = Negociacao.find params[:id]
    respond_to do |format|
      if negociacao.update(negociacao_params)
        format.json { render json: negociacao, status: 200 }
      else
        format.json { render json: { errors: negociacao.errors }, status: 422 }
      end
    end
  end

  def cancelar
    @negociacao.attributes = negociacao_params
    @negociacao.status = 2
    @negociacao.data_fim = Time.now

    @negociacao.save

    @negociacao.cliente.update(status_id: 10)

    @negociacao.create_activity(:cancelado, owner: current_user, recipient: @negociacao , params: {motivo: negociacao_params[:obs]})

    render json: @negociacao, status: 200
  end

  def conferir
    @negociacao.update(conferido: true)
    @negociacao.create_activity(:conferido, owner: current_user, recipient: @negociacao)

    render json: @negociacao, status: 200
  end

  def baixar
    @negociacao.update(baixado: true)
    @negociacao.create_activity(:baixado, owner: current_user, recipient: @negociacao)

    render json: @negociacao, status: 200
  end

  def recuperar
    user = User.find params[:negociador]

    if user !=  @negociacao.user
      @negociacao.create_activity(:responsavel, owner: current_user, recipient: @negociacao , params: {responsavel: user.id})
    end

    @negociacao.update(baixado: false, conferido: false, status: 0, data_fim: nil, user_id: user.id)
    @negociacao.cliente.update(status_id: 7, status_empresa: 2)

    AgendamentoRetorno.where(cliente: @negociacao.cliente, cancelado: false, data_efetuado_retorno: nil).update_all(cancelado: true, usuario_cancelamento_id: current_user.id)
    AgendamentoRetorno.create(empresa: @negociacao.empresa, user: @negociacao.user, data_agendamento_retorno: params[:retorno], cliente: @negociacao.cliente, cancelado: false)

    @negociacao.create_activity(:recuperada, owner: current_user, recipient: @negociacao, params: { comentario: params[:comentario] })

    render json: @negociacao, status: 200
  end

  def get_empresas_negociacao
    connection = ActiveRecord::Base.connection

    sql = NegociacoesHelper.get_sql_negociacoes params[:data_inicio], params[:data_fim], params[:empresa],
                                                params[:vendedor], params[:cliente], params[:filtro], params[:tipo]

    @negociacoes = connection.select_all sql

    render json: @negociacoes, status: 200
  end

  def get_empresas_negociacao_canceladas
    connection = ActiveRecord::Base.connection

    sql = NegociacoesHelper.get_sql_negociacoes_canceladas params[:data_inicio], params[:data_fim],
                                                           params[:empresa], params[:vendedor], params[:cliente],
                                                           params[:tipo], params[:conferido]

    @negociacoes = connection.select_all sql

    render json: @negociacoes, status: 200
  end

  def transferir_negociacao
    negociacao = Negociacao.find params[:id]
    user = User.find params[:resp_id]
    negociacao.user = user
    if negociacao.user_id_changed? && !negociacao.user.nil?
      negociacao.create_activity(:responsavel, owner: current_user, recipient: negociacao , params: {responsavel: negociacao.user_id})
    end
    negociacao.save
    render json: negociacao, status: 200
  end

  def transferir_negociacoes
    connection = ActiveRecord::Base.connection

    sql = NegociacoesHelper.get_sql_negociacoes params[:data_inicio], params[:data_fim], params[:empresa], params[:vendedor], params[:cliente], params[:filtro], params[:tipo]

    negociacoes = connection.select_all sql

    user = User.find params[:resp_id]

    negociacoes.each do |negociacao|
      neg = Negociacao.find negociacao['id']
      neg.user = user
      if neg.user_id_changed? && !neg.user.nil?
        neg.create_activity(:responsavel, owner: current_user, recipient: neg , params: {responsavel: neg.user_id})
      end
      neg.save
    end

    render json: negociacoes, status: 200
  end

  def activities
    @negociacao = Negociacao.find params[:id]

    @auditoria = params[:auditoria].present?

    @activities = PublicActivity::Activity.where(recipient_id: @negociacao.id, recipient_type: "Negociacao").order("created_at desc")

    return render :partial => 'negociacoes/modals/activities_negociacoes_ligacao' if params[:ligacao].present?

    return render :partial => 'negociacoes/modals/activities_negociacoes'
  end

  def set_canal_atendimento
    negociacao = Negociacao.find params[:negociacao_id]

    negociacao.update(atendimento_whatsapp: ApplicationHelper.true?(params[:valor])) if params[:tipo] == '1'
    negociacao.update(atendimento_telefone: ApplicationHelper.true?(params[:valor])) if params[:tipo] == '2'

    render json: negociacao
  end

  def get_informacao_por_consultor
    connection = ActiveRecord::Base.connection
    sql = NegociacoesHelper.get_informacao_por_consultor params[:data_inicio],params[:data_fim], params[:empresa]
    negociacoes = connection.select_all sql

    render json: negociacoes
  end

  private


  def set_negociacao
    @negociacao = Negociacao.find params[:id]
  end

  def negociacao_params
    params.require(:negociacao).permit(:data_fim, :status, :obs, :atendimento_whatsapp, :atendimento_telefone, :conferido, :baixado)
  end

end
