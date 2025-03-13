class AgendamentosController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_agendamento, only: [:show]

  def index
    
    @agendamento = Agendamento.where(empresa: current_empresa)
  end

  def show

    render json: @agendamento
  end

  def salvar
    is_novo = false
    if params[:id].present?
      @agendamento = Agendamento.find params[:id]
    else
      @agendamento = Agendamento.new(empresa: current_empresa, user_registro: current_user, confirmado: false, ativo: true)
      is_novo = true
    end

    dataAntiga = @agendamento.data_inicio
    return render json: 'Não é possivel alterar o horário, favor reagendar compromisso!'.to_json, :status => 422 if dataAntiga.present? && TimeDifference.between(dataAntiga, Time.parse(params[:data_inicio])).in_hours > 1

    #Se datas estiverem incorretas
    return render json: 'HORARIO_INICIO_MAIOR'.to_json, :status => 422 if Time.parse(params[:data_inicio]) >= Time.parse(params[:data_fim])
    return render json: 'Nenhum cliente informado!'.to_json, :status => 422 if !params[:cliente_id].present?

    #Verifica se cliente tem implantacao
    cliente = Cliente.find params[:cliente_id]
    cliente.update(telefone_preferencial: params[:telefone_preferencial], telefone2_preferencial: params[:telefone_preferencial2], telefone_enviado_whats: params[:telefone_whats], telefone2_enviado_whats: params[:telefone_whats2])
    @agendamento.implantacao = cliente.implantacao if cliente.implantacao.present?

    @agendamento.attributes = {titulo: params[:titulo], observacao: params[:observacao], data_inicio: Time.parse(params[:data_inicio]),
                               data_fim: Time.parse(params[:data_fim]), user_id: params[:user_id], tipo_agendamento_id: params[:tipo_agendamento_id],
                               cliente_id: cliente.id, contato: params[:contato], telefone: params[:telefone], responsavel2: params[:contato2],
                               telefone2: params[:telefone2], confirmado: params[:confirmacao],
                               telefone_preferencial: params[:telefone_preferencial],telefone_preferencial2: params[:telefone_preferencial2],
                               telefone_whats: params[:telefone_whats],telefone_whats2: params[:telefone_whats2]}

    #verifica se houve alteracao de confirmacao
    confirmado_changed =  @agendamento.confirmado_changed? && @agendamento.id.present?

    @agendamento.empresa = cliente.empresa

    user_changed = @agendamento.user_id_changed? && @agendamento.id.present? && @agendamento.implantacao.present?

    if @agendamento.save
      verificarImplantacao(@agendamento, params[:implantacao], params[:motivo], params[:acompanhamento], is_novo)

      if dataAntiga.present? && dataAntiga != Time.parse(params[:data_inicio])
        Notificacao.chrome.where(modelo_id: @agendamento.id).destroy_all
        if @agendamento.implantacao.present?
          @agendamento.create_activity(:alteracao_horario, owner: current_user, recipient: @agendamento.implantacao, params: {horario: @agendamento.data_inicio})
        end
      end

      if user_changed
        @agendamento.create_activity(:alteracao_responsavel, owner: current_user, recipient: @agendamento.implantacao, params: {usuario: @agendamento.user_id})
      end

      @agendamento.cliente.atualizarTelefoneContatos(@agendamento.telefone, @agendamento.contato) if @agendamento.contato.present?
      @agendamento.cliente.atualizarTelefoneContatos(@agendamento.telefone2, @agendamento.responsavel2) if @agendamento.responsavel2.present?

      #se houve alteracao cria uma atividade
      if confirmado_changed
        if @agendamento.confirmado?
          @agendamento.update(data_confirmacao: Time.now, user_confirmacao_id: current_user.id)
          @agendamento.create_activity(:confirmado, owner: current_user, recipient: @agendamento)
        else
          @agendamento.update(data_confirmacao: nil, user_confirmacao_id: nil)
          @agendamento.create_activity(:desconfirmado, owner: current_user, recipient: @agendamento)
        end
      end

      render json: @agendamento
    else
      render json: @agendamento.errors
    end
  end

  def alterar_contato
    @agendamento = Agendamento.find params[:id]

    if @agendamento.update(alterar_contato_params)
       render json: @agendamento, status: 200
    else
       render json: @agendamento.errors, status: :unprocessable_entity
    end
  end

  def reagendar
    agenda_cancelar = Agendamento.find params[:id]

    @agendamento = Agendamento.new(empresa: agenda_cancelar.empresa, user_registro: current_user, confirmado: false, ativo: true)
    is_novo = true

    #Se datas estiverem incorretas
    return render json: 'HORARIO_INICIO_MAIOR'.to_json, :status => 422 if Time.parse(params[:data_inicio]) >= Time.parse(params[:data_fim])

    #Verifica se cliente tem implantacao
    @agendamento.implantacao = agenda_cancelar.implantacao if agenda_cancelar.implantacao.present?

    @agendamento.attributes = {titulo: params[:titulo], observacao: params[:observacao], data_inicio: Time.parse(params[:data_inicio]),
                               data_fim: Time.parse(params[:data_fim]), user_id: params[:user_id], tipo_agendamento_id: params[:tipo_agendamento_id],
                               cliente_id: agenda_cancelar.cliente.id, contato: params[:contato], telefone: params[:telefone], responsavel2: params[:contato2],
                               telefone2: params[:telefone2], confirmado: params[:confirmacao],
                               telefone_preferencial: params[:telefone_preferencial],telefone_preferencial2: params[:telefone_preferencial2],
                               telefone_whats: params[:telefone_whats],telefone_whats2: params[:telefone_whats2]}


    #cancela a agenda original
    Agendamento.cancelar agenda_cancelar, params[:motivo_reagendamento], current_user.id

    if @agendamento.save
      verificarImplantacao(@agendamento, params[:implantacao], params[:motivo], params[:acompanhamento], is_novo)

      render json: @agendamento
    else
      render json: @agendamento.errors
    end
  end

  def destroy
    agendamento = Agendamento.find params[:id]

    Agendamento.cancelar agendamento, params[:motivo], current_user.id
    
    if agendamento.implantacao.present? && params[:retorno].present?
      retorno = AgendamentoRetorno.criarRetornoImplantacao params[:retorno], agendamento.implantacao, params[:user_id]
      agendamento.implantacao.create_activity(:retorno_reagendado, owner: current_user, recipient: agendamento.implantacao, params: { data: retorno.data_agendamento_retorno, motivo: params[:motivo]})
    elsif params[:retorno].present?
      novo_retorno = AgendamentoRetorno.create(empresa_id: agendamento.empresa_id, user_id: params[:user_id], data_agendamento_retorno: params[:retorno], cliente_id: agendamento.cliente_id, ligacao: nil, cancelado: false)
    end

    render json: agendamento.id
  end

  def agenda
      @empresas = Empresa.ativas
  end

  def get_agenda
    @agendamentos = Array.new

    if params[:sem_tecnico].eql? 'false'
      users = User.joins(:empresas, :permissao).where("empresas_users.empresa_id" => current_empresa.id, "permissoes.agenda" => true)
      users.each do |user|
        @agendamentos += user.agendamentos.where("(? = '0' or ativo = ?) and (? = '0' or confirmado = ?) and data_inicio between ? and ?", params[:status], params[:status], params[:confirmacao], params[:confirmacao], Time.at(params[:start].to_i), Time.at(params[:end].to_i))
      end
    end

    agendaSemUser = Agendamento.where("(? = '0' or ativo = ?) and (? = '0' or confirmado = ?) and data_inicio between ? and ?", params[:status], params[:status], params[:confirmacao], params[:confirmacao], Time.at(params[:start].to_i), Time.at(params[:end].to_i)).where(user: nil)

    if [5].include? current_empresa.id
      agendaSemUser = agendaSemUser.where(empresa_id: current_empresa.id)
    else
      agendaSemUser = agendaSemUser.where('empresa_id  in (?)', Empresa.ativas.pluck(:id))
    end

    agendaSemUser.each do |ag|
      @agendamentos << ag
    end

    render json: @agendamentos
  end

  def get_users_agenda
    @users = User.joins(:empresas, :permissao).where("empresas_users.empresa_id" => current_empresa.id, "permissoes.agenda" => true).where(active: true)

    render json: @users
  end

  def get_legenda
    @tipos = TipoAgendamento.where(ativo: true)

    render json: @tipos
  end

  def find_cliente_agenda
    @clientes = Cliente.select("distinct clientes.*").joins("inner join agendamentos on agendamentos.cliente_id = clientes.id").where("(upper(unaccent(clientes.razao_social)) LIKE upper(('%#{params[:term]}%')) OR (upper(unaccent(clientes.cnpj)) LIKE  upper(('%#{params[:term]}%')))) and clientes.empresa_id = #{ current_empresa.id }").where(ativo: true).order(:razao_social).limit(5)
    render json: @clientes, each_serializer: ClienteShortSerializer
  end

  def activities
    agenda = Agendamento.find params[:id]

    @act = Array.new

    activities = PublicActivity::Activity.where(recipient_id: agenda.id, recipient_type: "Agendamento").order("created_at desc")
    activities.each do |activity|
      @act << activity
    end

    acti = Cliente.get_all_activities(agenda.cliente_id)
    @activities = (acti<<  @act ).flatten!
    @activities = @activities.sort_by(&:created_at).reverse

    return render :partial => 'agendamentos/activities_agendamento'
  end

  def agendamento_nao_confirmado
    connection = ActiveRecord::Base.connection

    sql = AgendamentosHelper.get_sql_agendamentos_nao_confirmados params[:periodo], Time.parse(params[:data_comentario]),
                                                                  current_empresa.id, current_user.id

    @agendamentos = connection.select_all sql

    render json: @agendamentos.first
  end

  def nao_confimado_avisado
    @agendamento = Agendamento.find params[:id]

    if @agendamento.update(aviso_nao_confirmado: true)
      render json: @agendamento, status: 200
    else
      render json: @agendamento.errors, status: :unprocessable_entity
    end
  end

  def find_agendamento_by_fechamento
    cliente = Cliente.find params[:cliente_id]

    return render json: 'Cliente não localizado!', status: 422 if cliente.nil?
    return render json: 'Implantação não localizado!', status: 422 if cliente.implantacao.nil?

    agenda = Agendamento.where(cliente: cliente, implantacao: cliente.implantacao).order(id: :desc).first

    return render json: 'Agenda não localizado', status: 422 if agenda.nil?

    render json: agenda, status: 200
  end

  private

  def set_agendamento
    @agendamento = Agendamento.find(params[:id])
  end

  def agendamento_params
    params.require(:agendamento).permit(:titulo, :observacao, :data_inicio, :data_fim, :user_id, :tipo_agendamento_id, :cliente_id,
                                        :contato, :telefone, :contato2, :telefone2, :confirmado)
  end

  def alterar_contato_params
    params.require(:agendamento).permit(:contato, :telefone, :responsavel2, :telefone2)
  end

  def verificarImplantacao(agendamento, is_implantacao, motivo, is_acompanhamento, is_novo)
    if is_implantacao == 'true'
      Implantacao.where(cliente: agendamento.cliente).update_or_create(cliente: agendamento.cliente, status: 0, proposta: agendamento.cliente.propostas.where(ativa: true).first, user_id: agendamento.user_id, empresa: agendamento.cliente.empresa)
      agendamento.update(implantacao: agendamento.cliente.implantacao)
      agendamento.create_activity(:agenda_criada, owner: current_user, recipient: agendamento.cliente.implantacao, params: {horario: agendamento.data_inicio, tipo: agendamento.tipo_agendamento.descricao })
    end
    if is_acompanhamento == 'true'
      acompanhamento = Acompanhamento.find agendamento.cliente.acompanhamento_id
      agendamento.create_activity(:agenda_criada, owner: current_user, recipient: acompanhamento, params: {horario: agendamento.data_inicio, tipo: agendamento.tipo_agendamento.descricao })
    end
    if agendamento.implantacao.present? && is_novo
      implantacao = agendamento.implantacao
      if motivo.present?
        agendamento.create_activity(:reagendamento, owner: current_user, recipient: implantacao, params: {horario: agendamento.data_inicio, motivo: motivo, tipo: agendamento.tipo_agendamento.descricao})
        Agendamento.where('ativo is true and cliente_id = ? and id != ?', agendamento.cliente_id, agendamento.id).update_all(ativo: false)
      else
        agendamento.create_activity(:agenda_criada, owner: current_user, recipient: implantacao, params: {horario: agendamento.data_inicio})
      end
    end
  end

end
