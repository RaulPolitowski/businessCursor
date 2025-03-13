class AcompanhamentosController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_acompanhamento, only: [:show, :update, :destroy, :pausar, :continuar, :desistente, :iniciar, :finalizar,
                                            :get_dias_sem_uso, :conferir, :baixar, :recuperar]

  def index
  end

  def get_acompanhamentos
    connection = ActiveRecord::Base.connection

    sql = AcompanhamentosHelper.get_sql_acompanhamentos params[:data_inicio], params[:data_fim], params[:empresa],
                                                        params[:vendedor], params[:implantador], params[:cliente],
                                                        params[:status], params[:novas], params[:responsavel], params[:estado]

    @acompanhamentos = connection.select_all sql
    
    render json: @acompanhamentos
  end

  def show
    user = User.empresas_acesso(@acompanhamento.empresa_id).where(id: current_user.id)
    if user.present?
      session[:empresa_id] = @acompanhamento.empresa_id
    else
      return redirect_to acompanhamentos_path, alert: 'Você não tem acesso a empresa deste acompanhamento'
    end

    @activities = PublicActivity::Activity.where(recipient_id: @acompanhamento.id, recipient_type: "Acompanhamento").order("created_at desc")
    @activities_implantacao = PublicActivity::Activity.where(recipient_id: @acompanhamento.cliente.implantacao.id, recipient_type: "Implantacao").order("created_at desc")
    @cliente = @acompanhamento.cliente
    @ligacoes = @cliente.ligacoes.where(ligacao_old: nil).order(data_inicio: :desc)
    @ligacoes_old = @cliente.ligacoes.where(ligacao_old: true).order(data_inicio: :desc) 
    @propostas = @cliente.propostas.order(id: :desc)
    @agenda = @cliente.implantacao.agenda
    @activities_acomp = PublicActivity::Activity.where(recipient_id: @cliente.hist_acomp_id, recipient_type: "Acompanhamento_old").order("created_at desc")
    @activities_impl = PublicActivity::Activity.where(recipient_id: @cliente.hist_impl_id, recipient_type: "Implantacao_old").order("created_at desc")
    @anexos = Anexo.where(cliente_id: @cliente.id)
    
    respond_to do |format|
      format.html
      format.json { render json: @acompanhamento, status: 200 }
    end
  end

  def update
    respond_to do |format|
      if @acompanhamento.update(acompanhamento_params)
        format.json { render json: @acompanhamento, status: 200 }
      else
        format.json { render json: @acompanhamento.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @acompanhamento.destroy
    respond_to do |format|
      format.html { redirect_to acompanhamentos_url }
      format.json { head :no_content }
    end
  end

  def iniciar
    if @acompanhamento.status.eql? 1
      flash[:error] =  'Acompanhamento já foi iniciado.'
      return redirect_to @acompanhamento
    end

    @acompanhamento.user = current_user
    if @acompanhamento.user_id_changed? && !@acompanhamento.user.nil?
      @acompanhamento.create_activity(:responsavel, owner: current_user, recipient: @acompanhamento , params: {responsavel: @acompanhamento.user_id})
    end
    @acompanhamento.update(status: 1, data_inicio: Time.now)
    @acompanhamento.create_activity(:iniciada, owner: current_user, recipient: @acompanhamento)
    @acompanhamento.cliente.update(status_id: 44)

    current_user.update(em_atendimento: false)

    redirect_to @acompanhamento
  end

  def desistente
    if [3,4].include? @acompanhamento.status
      flash[:error] =  'Acompanhamento já foi marcada como desistente.'
      return redirect_to @implantacao
    end


    @acompanhamento.user = current_user
    if @acompanhamento.user_id_changed? && !@acompanhamento.user.nil?
      @acompanhamento.create_activity(:responsavel, owner: current_user, recipient: @acompanhamento , params: {responsavel: @acompanhamento.user_id})
    end

    if @acompanhamento.is_stand_by?
      @acompanhamento.status = 3
      @acompanhamento.create_activity(:desistente_stand_by, owner: current_user, recipient: @acompanhamento, params: {motivo: acompanhamento_params[:motivo]})
    else
      @acompanhamento.status = 4
      @acompanhamento.create_activity(:desistente_acompanhamento, owner: current_user, recipient: @acompanhamento, params: {motivo: acompanhamento_params[:motivo]})
    end
    @acompanhamento.data_fim = Time.now
    @acompanhamento.motivo = acompanhamento_params[:motivo]
    @acompanhamento.user_cancelamento_id = current_user
    @acompanhamento.save
    @acompanhamento.cliente.update(status_id: 45)

    current_user.update(em_atendimento: false)

    AgendamentoRetorno.where(acompanhamento: @acompanhamento).update_all(user_retorno_id: current_user, data_efetuado_retorno: Time.now)
    
    Notificacao.criar_notificacoes_desativacao(@acompanhamento, current_user)

    redirect_to @acompanhamento
  end

  def pausar
    if @acompanhamento.status.eql? 2
      flash[:error] =  'Acompanhamento já foi pausado.'
      return redirect_to @acompanhamento
    end
    @acompanhamento.user = current_user
    if @acompanhamento.user_id_changed? && !@acompanhamento.user.nil?
      @acompanhamento.create_activity(:responsavel, owner: current_user, recipient: @acompanhamento , params: {responsavel: @acompanhamento.user_id})
    end
    @acompanhamento.status = 2
    @acompanhamento.create_activity(:pausada, owner: current_user, recipient: @acompanhamento, params: {motivo: params[:acompanhamento][:motivo]})

    AgendamentoRetorno.where(acompanhamento: @acompanhamento).update_all(user_retorno_id: current_user, data_efetuado_retorno: Time.now)

    if params[:data_retorno].present?
      AgendamentoRetorno.criarRetornoAcompanhamento params[:data_retorno], @acompanhamento, current_user.id
    end

    current_user.update(em_atendimento: false)

    @acompanhamento.save
    redirect_to @acompanhamento
  end

  def continuar
    if @acompanhamento.status.eql? 1
      flash[:error] =  'Acompanhamento já foi iniciado.'
      return redirect_to @acompanhamento
    end

    @acompanhamento.user = current_user
    if @acompanhamento.user_id_changed? && !@acompanhamento.user.nil?
      @acompanhamento.create_activity(:responsavel, owner: current_user, recipient: @acompanhamento , params: {responsavel: @acompanhamento.user_id})
    end

    @acompanhamento.status = 1
    @acompanhamento.create_activity(:continuou, owner: current_user, recipient: @acompanhamento)
    @acompanhamento.save

    current_user.update(em_atendimento: false)

    redirect_to @acompanhamento
  end

  def finalizar
    if @acompanhamento.status.eql? 5
      flash[:error] =  'Acompanhamento já foi finalizado.'
      return redirect_to @acompanhamento
    end

    @acompanhamento.user = current_user
    if @acompanhamento.user_id_changed? && !@acompanhamento.user.nil?
      @acompanhamento.create_activity(:responsavel, owner: current_user, recipient: @acompanhamento , params: {responsavel: @acompanhamento.user_id})
    end
    @acompanhamento.update(status: 5, data_fim: Time.now)
    @acompanhamento.create_activity(:finalizado_acompanhamento, owner: current_user, recipient: @acompanhamento)
    @acompanhamento.cliente.update(status_id: 46)

    current_user.update(em_atendimento: false)

    @acompanhamento.cliente.registrar_proxima_pesquisa @acompanhamento.data_fim

    AgendamentoRetorno.where(acompanhamento: @acompanhamento).update_all(user_retorno_id: current_user, data_efetuado_retorno: Time.now)

    Notificacao.criar_notificacoes_efetivacao(@acompanhamento, current_user)

    redirect_to @acompanhamento
  end

  def activities
    @acompanhamento = Acompanhamento.find params[:id]  if params[:id].present?

    @auditoria = params[:auditoria].present?

    if params[:historico].present?
      @activities = PublicActivity::Activity.where(recipient_id: params[:historico], recipient_type: "Acompanhamento_old").order("created_at desc")
    else
      @activities = PublicActivity::Activity.where(recipient_id: @acompanhamento.id, recipient_type: "Acompanhamento").order("created_at desc")
    end

    return render :partial => 'acompanhamentos/modals/activities_acompanhamento_body' if params[:ligacao].present?

    render :partial => 'acompanhamentos/modals/activities_acompanhamentos'
  end

  def get_dias_sem_uso
    render json: @acompanhamento.dias_sem_uso.to_json
  end

  def get_dias_sem_uso_by_cnpj
    cliente = Cliente.find_by_cnpj params[:cnpj]
    return render json: 'Sem info.'.to_json if cliente.nil?

    acompanhamento = Acompanhamento.find_by_cliente_id cliente.id
    return render json: 'Sem info.'.to_json if acompanhamento.nil?

    render json: acompanhamento.dias_sem_uso.to_json
  end

  def get_acompanhamentos_retorno_notificacao
    connection = ActiveRecord::Base.connection

    sql = AcompanhamentosHelper.get_acompanhamentos_retorno current_user.id , current_empresa.id, (ApplicationHelper.true? params[:aviso])

    @acompanhamentos = connection.select_all sql

    if (ApplicationHelper.true? params[:aviso])
      @acompanhamentos.each do |acomp|
        AgendamentoRetorno.where(id: acomp['retorno_id']).update_all(avisado: true)
      end
    end

    render json: @acompanhamentos
  end

  def acompanhamentos_desistentes
    connection = ActiveRecord::Base.connection

    sql = AcompanhamentosHelper.acompanhamentos_desistentes params[:data_inicio], params[:data_fim],
                                                           params[:empresa], params[:vendedor], params[:cliente],
                                                            params[:conferido], params[:status]

    @acompanhamentos = connection.select_all sql

    render json: @acompanhamentos, status: 200
  end

  def conferir
    @acompanhamento.update(conferido: true)
    @acompanhamento.create_activity(:conferido, owner: current_user, recipient: @acompanhamento)

    render json: @acompanhamento, status: 200
  end

  def baixar
    @acompanhamento.update(baixado: true)
    @acompanhamento.create_activity(:baixado, owner: current_user, recipient: @acompanhamento)

    msg = Financeiro::Contrato.cancelar_contrato(@acompanhamento, current_user)

    render json: msg.to_json, status: 200
  end

  def recuperar
    user = User.find params[:responsavel]

    if user !=  @acompanhamento.user
      @acompanhamento.create_activity(:responsavel, owner: current_user, recipient: @acompanhamento , params: {responsavel: user.id})
    end

    @acompanhamento.update(baixado: false, conferido: false, status: params[:status], data_fim: nil, user_id: user.id)

    if @acompanhamento.aguardando?
      @acompanhamento.update(data_inicio: nil)
      @acompanhamento.cliente.update(status_id: 43, status_empresa: 8)
    end

    AgendamentoRetorno.where(cliente: @acompanhamento.cliente, cancelado: false, data_efetuado_retorno: nil).update_all(cancelado: true, usuario_cancelamento_id: current_user.id)
    AgendamentoRetorno.create(empresa: @acompanhamento.empresa, user: @acompanhamento.user, data_agendamento_retorno: params[:retorno], cliente: @acompanhamento.cliente, cancelado: false)

    @acompanhamento.create_activity(:recuperada, owner: current_user, recipient: @acompanhamento, params: { status: params[:status], comentario: params[:comentario]})

    render json: @acompanhamento, status: 200
  end

  def transferir
    acompanhamento = Acompanhamento.find params[:id]
    user = User.find params[:resp_id]
    return render json: 'SOMENTE_ADMIN', status: :unprocessable_entity if acompanhamento.user != user && !current_user.admin?
    acompanhamento.user = user
    if acompanhamento.user_id_changed? && !acompanhamento.user.nil?
      acompanhamento.create_activity(:responsavel, owner: current_user, recipient: acompanhamento , params: {responsavel: acompanhamento.user_id})
    end
    acompanhamento.save

    respond_to do |format|
      format.html { redirect_to acompanhamentos_path }
      format.json { head :no_content }
    end
  end

  def acompanhamentos_sem_agendamento_retorno
    connection = ActiveRecord::Base.connection
    lista = connection.select_all AcompanhamentosHelper.acompanhamentos_sem_retorno current_empresa.id

    lista = lista.to_hash
    lista.each do |empr|
      acompanhamento = Acompanhamento.find empr['id'].strip
      if acompanhamento.present?
        empr['dias_sem_uso'] = acompanhamento.dias_sem_uso
      else
        empr['dias_sem_uso'] = 'Sem info.'
      end
    end

    render json: lista
  end

  def voltar_negociacao
    @acompanhamento = Acompanhamento.find(params[:id])
    cliente = @acompanhamento.cliente
    cliente.update(status_id: 7);
    @implantacao = cliente.implantacao
    user = User.find params[:responsavel] if params[:responsavel].present?    
    
    historico = HistImplAcomp.create(acomp_id: @acompanhamento.id, tipo:"Implantacao_old")
    cliente.update(hist_impl_id: historico.id)
    #deletar todo o historico da implantacao
    @activities = PublicActivity::Activity.where(recipient_id: @implantacao.id, recipient_type: "Implantacao")    
    @activities.each do |act|
      act.update(recipient_id: historico.id, recipient_type: historico.tipo)
    end
    @comentarios = Comentario.where(implantacao_id: @implantacao.id)   
    @comentarios.each do |comt|
      comt.update(implantacao_id: nil, historico_id: historico.id)
    end

    #@agendamentos = Agendamento.where(implantacao_id: @implantacao.id)
    #@agendamentos.each do |agd|
      #Comentario.where(agendamento_id: agd.id).delete_all
    #end
    Agendamento.where(implantacao_id: @implantacao.id).update_all(implantacao_id: nil, historico_id: historico.id)
    @retornos = AgendamentoRetorno.where(implantacao_id: @implantacao.id).delete_all    
    #@ligacao = cliente.ligacoes.where(status_cliente_id: 2).delete_all
    @implantacao.delete

    historico = HistImplAcomp.create(acomp_id: @acompanhamento.id, tipo:"Acompanhamento_old")
    cliente.update(hist_acomp_id: historico.id)
    #deletar todo o historico do acompanhamento
    @activities = PublicActivity::Activity.where(recipient_id: @acompanhamento.id, recipient_type: "Acompanhamento")    
    @activities.each do |act|
      act.update(recipient_id: historico.id, recipient_type: historico.tipo)
    end 

    @comentarios = Comentario.where(acompanhamento_id: @acompanhamento.id)
    @comentarios.each do |comt|
      comt.update(acompanhamento_id: nil, historico_id: historico.id)
    end
    @retornos = AgendamentoRetorno.where(acompanhamento_id: @acompanhamento.id).delete_all    
    @acompanhamento.delete

    #deleta o fechamento
    cliente.fechamento.delete
    
    #atualiza as ligacoes
    cliente.ligacoes.update_all(ligacao_old: true)

    negociacao = cliente.negociacao
    negociacao.update(data_fim: nil, status: 0, status_id: 7)
    if user.present?
      negociacao.update(user_id: user.id)
      negociacao.create_activity(:responsavel, owner: current_user, recipient: negociacao , params: {responsavel: user.id})
      AgendamentoRetorno.create(empresa: @acompanhamento.empresa, user: user, data_agendamento_retorno: params[:data_retorno], cliente: cliente, cancelado: false)
    end
    negociacao.create_activity(:voltou, owner: current_user, recipient: negociacao, params:{etapa_ant: 'acompanhamento', etapa_atual: 'negociação', comentario: params[:motivo]})
   
    render json: negociacao
  end

  def voltar_acomp_pra_impl
    @acompanhamento = Acompanhamento.find(params[:id])
    cliente = @acompanhamento.cliente    
    @implantacao = cliente.implantacao
    user = User.find params[:responsavel] if  params[:responsavel].present?    
    historico = HistImplAcomp.create(acomp_id: @acompanhamento.id, tipo:"Implantacao_old")
    cliente.update(hist_impl_id: historico.id)
    #Atualizar todo o historico da implantacao
    @activities = PublicActivity::Activity.where(recipient_id: @implantacao.id, recipient_type: "Implantacao")    
    @activities.each do |act|
      act.update(recipient_id: historico.id, recipient_type: historico.tipo)
    end
    @comentarios = Comentario.where(implantacao_id: @implantacao.id)   
    @comentarios.each do |comt|
      comt.update(implantacao_id: nil, historico_id: historico.id)
    end

    Agendamento.where(implantacao_id: @implantacao.id).update_all(implantacao_id: nil, historico_id: historico.id)
    @retornos = AgendamentoRetorno.where(implantacao_id: @implantacao.id).delete_all    
    #@ligacao = cliente.ligacoes.where(status_cliente_id: 2).delete_all

    #deixa implantacao sem responsável
    @implantacao.update(status: params[:status].to_i, data_fim: nil, user_id: nil)
    @implantacao.create_activity(:voltou, owner: current_user, recipient: @implantacao, params:{etapa_ant: 'acompanhamento', etapa_atual: 'implantação', comentario: params[:motivo]})
    
    historico = HistImplAcomp.create(acomp_id: @acompanhamento.id, tipo:"Acompanhamento_old")
    cliente.update(hist_acomp_id: historico.id)

    #atualizar todo o historico do acompanhamento
    @activities = PublicActivity::Activity.where(recipient_id: @acompanhamento.id, recipient_type: "Acompanhamento")      
    @activities.each do |act|
      act.update(recipient_id: historico.id, recipient_type: historico.tipo)
    end 
    
    @comentarios = Comentario.where(acompanhamento_id: @acompanhamento.id)
    @comentarios.each do |comt|
      comt.update(acompanhamento_id: nil, historico_id: historico.id)
    end

    @retornos = AgendamentoRetorno.where(acompanhamento_id: @acompanhamento.id).delete_all    
    @acompanhamento.delete
    
    #atualiza as ligacoes
    cliente.ligacoes.update_all(ligacao_old: true)

    #atualiza o vendedor
    fechamento = cliente.fechamento
    fechamento.update(user: user)  if  params[:responsavel].present?  
      
    #cria o agendamento para o vendedor
    AgendamentoRetorno.create(empresa: @acompanhamento.empresa, user: user, data_agendamento_retorno: params[:data_retorno], cliente: cliente, cancelado: false, implantacao_id: @implantacao.id)
    
    render json: @implantacao
  end

  def voltar_acomp_pra_acomp
    @acompanhamento = Acompanhamento.find(params[:id])
    cliente = @acompanhamento.cliente    
    #@implantacao = cliente.implantacao
    user = User.find params[:responsavel] if  params[:responsavel].present?    
    historico = HistImplAcomp.create(acomp_id: @acompanhamento.id, tipo:"Acompanhamento_old")
    cliente.update(hist_acomp_id: historico.id)
    #atualizar todo o historico do acompanhamento
    @activities = PublicActivity::Activity.where(recipient_id: @acompanhamento.id, recipient_type: "Acompanhamento")    
    @activities.each do |act|
      act.update(recipient_id: historico.id, recipient_type: historico.tipo)
    end 

    @comentarios = Comentario.where(acompanhamento_id: @acompanhamento.id)
    @comentarios.each do |comt|
      comt.update(acompanhamento_id: nil, historico_id: historico.id)
    end    
    @acompanhamento.update(data_fim: nil, status: params[:status])
    @acompanhamento.update(user_id: user.id) if params[:responsavel].present?
      
    #cria o agendamento para o vendedor
    AgendamentoRetorno.create(empresa: @acompanhamento.empresa, user: user, data_agendamento_retorno: params[:data_retorno], cliente: cliente, cancelado: false, acompanhamento_id: @acompanhamento.id)
    @acompanhamento.create_activity(:voltou, owner: current_user, recipient: @acompanhamento, params:{etapa_ant: 'concluida', etapa_atual: params[:status], comentario: params[:motivo]})
    
    render json: @acompanhamento
  end

  private
    def set_acompanhamento
      @acompanhamento = Acompanhamento.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def acompanhamento_params
      params.require(:acompanhamento).permit(:data_inicio, :data_fim, :cliente_id, :empresa_id, :user_id, :status, :proposta_id, :pausada, :observacao, :motivo)
    end

end
