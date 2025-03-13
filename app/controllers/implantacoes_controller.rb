class ImplantacoesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_implantacao, only: [:show, :update, :destroy, :iniciar, :finalizar_instalacao, :iniciar_treinamento, :finalizar,
                                         :alterar_treinamento, :desistente, :pausar_continuar, :reagendar_aguardar, :limbo, :baixar,
                                         :conferir, :recuperar, :assumir_responsabilidade]

  def index
    @status = [0, 1, 2, 3]
  end

  def get_implantacoes
    connection = ActiveRecord::Base.connection

    sql = ImplantacoesHelper.get_sql_implantacoes params[:data_inicio], params[:data_fim], params[:empresa], params[:vendedor],
                                                  params[:implantador], params[:cliente], params[:status], params[:novas],
                                                  params[:filtro], params[:fechamento], params[:estado]

    @implantacoes = connection.select_all sql

    render json: @implantacoes
  end

  def show
    respond_to do |format|
      format.html {
        user = User.empresas_acesso(@implantacao.empresa_id).where(id: current_user.id)
        if user.present?
          session[:empresa_id] = @implantacao.empresa_id
        else
          return redirect_to implantacoes_path, alert: 'Você não tem acesso a empresa desta implantação'
        end

        @activities = PublicActivity::Activity.where(recipient_id: @implantacao.id, recipient_type: "Implantacao").order("created_at desc")
        @agenda = @implantacao.agenda
        @cliente = @implantacao.cliente
        @propostas = @cliente.propostas.order(id: :desc)
        @ligacoes = @cliente.ligacoes.where(ligacao_old: nil).order(data_inicio: :desc) 
        @ligacoes_old = @cliente.ligacoes.where(ligacao_old: true).order(data_inicio: :desc)       
        @activities_acomp = PublicActivity::Activity.where(recipient_id: @cliente.hist_acomp_id, recipient_type: "Acompanhamento_old").order("created_at desc")
        @activities_impl = PublicActivity::Activity.where(recipient_id: @cliente.hist_impl_id, recipient_type: "Implantacao_old").order("created_at desc")
        @anexos = Anexo.where(cliente_id: @cliente.id);
        @banco = SolicitacaoBanco.where(cliente_id: @cliente.id, ativo: true).first
      }
      format.json { render json: @implantacao, status: 200 }
    end
  end

  def new
    @implantacao = Implantacao.new
  end

  def update
    respond_to do |format|
      if @implantacao.update(implantacao_params)
        format.html { redirect_to @implantacao }
        format.json { render json: @implantacao, status: 200 }
      else
        format.html { render action: 'show' }
        format.json { render json: @implantacao.errors, status: :unprocessable_entity }
      end
    end
  end

  def iniciar
    user = current_user
    user = User.find implantacao_params[:user_id].to_i if current_user.admin?

    # if user.implantacao_id.present? && user.implantacao_id != @implantacao.id
    #   flash[:error] =  'Não é possivel iniciar a implantação, usuário já esta com outra em andamento.'
    #   return redirect_to @implantacao
    # end

    if @implantacao.status.eql? 3
      flash[:error] =  'Implantação já foi inicíada.'
      return redirect_to @implantacao
    end

    @implantacao.user = user
    if @implantacao.user_id_changed? && !@implantacao.user.nil?
      @implantacao.create_activity(:responsavel, owner: user, recipient: @implantacao , params: {responsavel: @implantacao.user_id})
    end

    @implantacao.status = 3
    @implantacao.data_inicio = Time.now
    @implantacao.save

    @implantacao.create_activity(:iniciada, owner: user, recipient: @implantacao)
    @implantacao.cliente.update(status_id: 41)
    user.update(implantacao_id: @implantacao.id)

    @implantacao.notificar_alteracoes

    current_user.update(em_atendimento: false)

    redirect_to @implantacao
  end

  def finalizar_instalacao
    user = current_user
    user = User.find implantacao_params[:user_id].to_i if current_user.admin?

    # if user.implantacao_id.present? && user.implantacao_id != @implantacao.id
    #   flash[:error] =  'Não é possivel finalizar a instalação, usuário já esta com outra em andamento.'
    #   return redirect_to @implantacao
    # end

    @implantacao.user = user
    if @implantacao.user_id_changed? && !@implantacao.user.nil?
      @implantacao.create_activity(:responsavel, owner: user, recipient: @implantacao , params: {responsavel: @implantacao.user_id})
    end

    if @implantacao.status.eql? 4
      flash[:error] =  'Instalação já foi concluida.'
      return redirect_to @implantacao
    end

    @implantacao.status = 4
    @implantacao.save

    @implantacao.create_activity(:instalacao_terminada, owner: user, recipient: @implantacao)
    User.where(implantacao_id: @implantacao.id).update_all(implantacao_id: nil)

    @implantacao.notificar_alteracoes

    current_user.update(em_atendimento: false)

    redirect_to @implantacao
  end

  def iniciar_treinamento
    user = current_user
    user = User.find implantacao_params[:user_id].to_i if current_user.admin?

    # if user.implantacao_id.present? && user.implantacao_id != @implantacao.id
    #   flash[:error] =  'Não é possivel iniciar treinamento, usuário já esta com outra em andamento.'
    #   return redirect_to @implantacao
    # end

    if @implantacao.status.eql? 5
      flash[:error] =  'Treinamento já foi iniciado.'
      return redirect_to @implantacao
    end

    @implantacao.user = user
    if @implantacao.user_id_changed? && !@implantacao.user.nil?
      @implantacao.create_activity(:responsavel, owner: user, recipient: @implantacao , params: {responsavel: @implantacao.user_id})
    end

    @implantacao.status = 5
    @implantacao.save

    @implantacao.create_activity(:iniciado_treinamento, owner: user, recipient: @implantacao,  params: {pessoa: params[:pessoa_treinamento]})
    user.update(implantacao_id: @implantacao.id)

    @implantacao.notificar_alteracoes

    current_user.update(em_atendimento: false)

    redirect_to @implantacao
  end

  def finalizar
    user = current_user
    user = User.find implantacao_params[:user_id].to_i if current_user.admin?

    # if user.implantacao_id.present? && user.implantacao_id != @implantacao.id
    #   flash[:error] =  'Não é possivel finalizar a implantação, usuário já esta com outra em andamento.'
    #   return redirect_to @implantacao
    # end

    if @implantacao.status.eql? 9
      flash[:error] =  'Implantação já foi concluido.'
      return redirect_to @implantacao
    end

    cliente = @implantacao.cliente
    cliente.reload

    @implantacao.user = user
    if @implantacao.user_id_changed? && !@implantacao.user.nil?
      @implantacao.create_activity(:responsavel, owner: user, recipient: @implantacao , params: {responsavel: @implantacao.user_id})
    end

    @implantacao.status = 9
    @implantacao.data_fim = Time.now
    @implantacao.save

     return redirect_to @implantacao if cliente.acompanhamento.present?

    Acompanhamento.where(cliente: @implantacao.cliente).update_or_create(empresa: @implantacao.empresa, cliente: @implantacao.cliente, pausada: false, status: 0, proposta: @implantacao.proposta)
    AgendamentoRetorno.where(implantacao: @implantacao).update_all(user_retorno_id: current_user, data_efetuado_retorno: Time.now)

    @implantacao.create_activity(:finalizado_implantacao, owner: user, recipient: @implantacao)

    @implantacao.cliente.update(status_id: 43)
    User.where(implantacao_id: @implantacao.id).update_all(implantacao_id: nil)

    @implantacao.notificar_alteracoes

    current_user.update(em_atendimento: false)
    
    Notificacao.criar_notificacoes_implantacao(@implantacao, current_user)

    redirect_to @implantacao
  end

  def alterar_treinamento
    user = current_user
    user = User.find implantacao_params[:user_id].to_i if current_user.admin?

    # if user.implantacao_id.present? && user.implantacao_id != @implantacao.id
    #   flash[:error] =  'Não é possivel iniciar treinamento, usuário já esta com outra em andamento.'
    #   return redirect_to @implantacao
    # end

    User.where(implantacao_id: @implantacao.id).update_all(implantacao_id: nil)

    @implantacao.create_activity(:finalizado_treinamento, owner: @implantacao.user, recipient: @implantacao)

    @implantacao.user = user
    if @implantacao.user_id_changed? && !@implantacao.user.nil?
      @implantacao.create_activity(:responsavel, owner: user, recipient: @implantacao , params: {responsavel: @implantacao.user_id})
    end

    @implantacao.create_activity(:iniciado_treinamento, owner: user, recipient: @implantacao,  params: {pessoa: params[:pessoa_treinamento]})
    user.update(implantacao_id: @implantacao.id)

    redirect_to @implantacao
  end

  def desistente
    user = current_user
    user = User.find implantacao_params[:user_id].to_i if current_user.admin?
    User.where(implantacao_id: @implantacao.id).update_all(implantacao_id: nil)

    if [7,8].include? @implantacao.status
      flash[:error] =  'Implantação já foi marcada como desistente.'
      return redirect_to @implantacao
    end

    if @implantacao.is_aguardando?
       @implantacao.status = 7
       @implantacao.create_activity(:desistente_pre, owner: user, recipient: @implantacao, params: {motivo: implantacao_params[:motivo]})
       @implantacao.data_inicio = Time.now
    else
      @implantacao.status = 8
      @implantacao.create_activity(:desistente_implantacao, owner: user, recipient: @implantacao, params: {motivo: implantacao_params[:motivo]})
    end
    @implantacao.data_fim = Time.now
    @implantacao.motivo = implantacao_params[:motivo]
    @implantacao.user_cancelamento_id = user.id
    @implantacao.save
    @implantacao.cliente.update(status_id: 42)

    current_user.update(em_atendimento: false)

    redirect_to @implantacao
  end

  def pausar_continuar
    user = current_user
    user = User.find implantacao_params[:user_id].to_i if current_user.admin?

    #Raul pediu pra tirar essa validação 17-11-2020
    # if user.implantacao_id.present? && user.implantacao_id != @implantacao.id && @implantacao.pausada?
    #   flash[:error] =  'Não é possivel continuar a implantação, usuário já esta com outra em andamento.'
    #   return redirect_to @implantacao
    # end

    User.where(implantacao_id: @implantacao.id).update_all(implantacao_id: nil)

    @implantacao.pausada = !@implantacao.pausada
    @implantacao.user = user
    if @implantacao.user_id_changed? && !@implantacao.user.nil?
      @implantacao.create_activity(:responsavel, owner: user, recipient: @implantacao , params: {responsavel: @implantacao.user_id})
    end

    @implantacao.save
    if @implantacao.pausada?
      @implantacao.create_activity(:pausada, owner: user, recipient: @implantacao, params:{motivo: implantacao_params[:motivo]})
    else
      @implantacao.create_activity(:continuou, owner: user, recipient: @implantacao)
      user.update(implantacao_id: @implantacao.id)
    end

    @implantacao.notificar_alteracoes

    current_user.update(em_atendimento: false)

    redirect_to @implantacao
  end

  def reagendar_aguardar
    @implantacao.attributes = implantacao_params
    @implantacao.save

    if @implantacao.status == 2
      @implantacao.agendamentos.where(ativo: true).update_all(ativo: false)
      @implantacao.create_activity(:aguardando, owner: current_user, recipient: @implantacao, params:{motivo: params[:motivo]})
    end

    render json: @implantacao
  end

  def limbo
    @implantacao.update(status: 10)

    @implantacao.cliente.update(status_id: 47)

    @implantacao.create_activity(:limbo, owner: current_user, recipient: @implantacao)

    redirect_to @implantacao
  end

  def destroy
    @implantacao.destroy
    respond_to do |format|
      format.html { redirect_to implantacoes_url }
      format.json { head :no_content }
    end
  end

  def lancar
    if current_user.implantacao_id.present?
      redirect_to implantacao_path(current_user.implantacao_id)
    else
      redirect_to implantacoes_path, :flash => { :error => 'Você não possui nem uma implantação em andamento.' }
    end
  end

  def transferir_implantacao
    implantacao = Implantacao.find params[:id]
    user = User.find params[:resp_id]
    return render json: 'SOMENTE_ADMIN', status: :unprocessable_entity if implantacao.user != user && !current_user.admin?

    implantacao.user = user
    if implantacao.user_id_changed? && !implantacao.user.nil?
      implantacao.create_activity(:responsavel, owner: current_user, recipient: implantacao , params: {responsavel: implantacao.user_id})
    end
    implantacao.save
    redirect_to implantacoes_path
  end

  def transferir_vendedor
    implantacao = Implantacao.find params[:id]
    user = User.find params[:resp_id]

    fechamento = implantacao.cliente.fechamento
    fechamento.user = user
    if fechamento.present? && fechamento.user_id_changed? && !fechamento.user.nil?
      implantacao.create_activity(:vendedor, owner: current_user, recipient: implantacao , params: {responsavel: fechamento.user_id, observacao: params[:obs]})
    end
    fechamento.save
    redirect_to implantacoes_path
  end

  def activities
    @implantacao = Implantacao.find params[:id] if params[:id].present?

    @auditoria = params[:auditoria].present?
    
    if params[:historico].present?
      @activities = PublicActivity::Activity.where(recipient_id: params[:historico], recipient_type: "Implantacao_old").order("created_at desc")
    else
      @activities = PublicActivity::Activity.where(recipient_id: @implantacao.id, recipient_type: "Implantacao").order("created_at desc")
    end

    return render :partial => 'implantacoes/modals/activities_implantacao_body' if params[:ligacao].present?

    render :partial => 'implantacoes/modals/activities_implantacao'
  end

  def implantacoes_desistentes
    connection = ActiveRecord::Base.connection

    sql = ImplantacoesHelper.implantacoes_desistentes params[:data_inicio], params[:data_fim],
                                                            params[:empresa], params[:vendedor], params[:cliente],
                                                            params[:conferido], params[:status]

    @implantacoes = connection.select_all sql

    render json: @implantacoes, status: 200
  end

  def conferir
    @implantacao.update(conferido: true)
    @implantacao.create_activity(:conferido, owner: current_user, recipient: @implantacao)

    render json: @implantacao, status: 200
  end

  def baixar
    @implantacao.update(baixado: true)
    @implantacao.create_activity(:baixado, owner: current_user, recipient: @implantacao)

    msg = Financeiro::Contrato.cancelar_contrato_impl(@implantacao, current_user)

    render json: msg.to_json, status: 200
  end

  def recuperar
    user = User.find params[:responsavel] if  params[:responsavel].present?

    if user.present?  && user !=  @implantacao.user
      @implantacao.create_activity(:responsavel, owner: current_user, recipient: @acompanhamento , params: {responsavel: user.id})
      @implantacao.update(user_id: user.id);
    end

    @implantacao.update(baixado: false, conferido: false, status: params[:status], data_fim: nil)

    if @implantacao.is_aguardando?
      @implantacao.update(data_inicio: nil)
      @implantacao.cliente.update(status_id: 40, status_empresa: 5)
    end

    @implantacao.create_activity(:recuperada, owner: current_user, recipient: @implantacao, params: { status: params[:status], comentario: params[:comentario]})

    render json: @implantacao, status: 200
  end

  def implantacoes_sem_agendamento_retorno
    connection = ActiveRecord::Base.connection
    @implantacoes = connection.select_all ImplantacoesHelper.implantacoes_sem_retorno current_empresa.id

    render json: @implantacoes
  end

  def assumir_responsabilidade
    @implantacao.user = current_user
    if @implantacao.user_id_changed? && !@implantacao.user.nil?
      @implantacao.create_activity(:responsavel, owner: current_user, recipient: @implantacao , params: {responsavel: @implantacao.user_id})

      @implantacao.save
    end
    redirect_to @implantacao
  end

  def voltar_negociacao 
    @implantacao = Implantacao.find(params[:id])
    user = User.find params[:responsavel] if params[:responsavel].present?
    cliente = @implantacao.cliente
    
    historico = HistImplAcomp.create(impl_id: @implantacao.id, tipo:"Implantacao_old")
    #atualizar todo o historico da implantacao
    @activities = PublicActivity::Activity.where(recipient_id: @implantacao.id, recipient_type: "Implantacao")   
    @activities.each do |act|
      act.update(recipient_id: historico.id, recipient_type: historico.tipo)
    end

    #@agendamentos = Agendamento.where(implantacao_id: @implantacao.id)
    #@agendamentos.each do |agendamento|
     # Comentario.where(agendamento_id: agendamento.id).update_all(agendamento_id: nil, historico_id: historico.id)
    #end
    Agendamento.where(implantacao_id: @implantacao.id).update_all(implantacao_id: nil, historico_id: historico.id)
    
    @comentarios = Comentario.where(implantacao_id: @implantacao.id)
    @comentarios.each do |comt|
      comt.update(implantacao_id: nil, historico_id: historico.id)
    end

    @retornos = AgendamentoRetorno.where(implantacao_id: @implantacao.id).delete_all    
    #@ligacao = cliente.ligacoes.where(status_cliente_id: 2).delete_all
    @implantacao.delete
    
    #atualiza as ligacoes
    cliente.ligacoes.update_all(ligacao_old: true)

    cliente.fechamento.delete
    cliente.update(status_id: 7, hist_impl_id: historico.id)
    negociacao = cliente.negociacao
    negociacao.update(data_fim: nil, status: 0, status_id: 7)

    if user.present?
      negociacao.update(user_id: user.id)
      negociacao.create_activity(:responsavel, owner: current_user, recipient: negociacao , params: {responsavel: user.id})
      AgendamentoRetorno.create(empresa: @implantacao.empresa, user: user, data_agendamento_retorno: params[:data_retorno], cliente: cliente, cancelado: false)
    end

    negociacao.create_activity(:voltou, owner: current_user, recipient: negociacao, params:{etapa_ant: 'implantação', etapa_atual: 'negociação', comentario: params[:motivo]})
   
    render json: negociacao
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_implantacao
      @implantacao = Implantacao.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def implantacao_params
      params.require(:implantacao).permit(:cliente_id, :status, :data_inicio, :data_fim, :proposta_id, :pausada, :observacao, :user_id, :motivo, :user_cancelamento_id)
    end
end
