class LigacoesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_ligacao, only: %i[show update finalizar_ligacao_escritorio set_status_ligacao finalizar_ligacao]

  def ligacao
    @cliente = Cliente.find params[:cliente_retorno_id] if params[:cliente_retorno_id].present?
    @anexos = Anexo.where(cliente_id: @cliente.id) if @cliente.present?
  end

  def index
    @q = Ligacao.search params[:q]

    unless params[:q]
      @q.data_inicio_gteq ||= Time.now.beginning_of_day.strftime('%d/%m/%Y %H:%M')
      @q.data_inicio_lteq ||= Time.now.end_of_day.strftime('%d/%m/%Y %H:%M')
      @q.empresa_id_eq ||= current_empresa.id
    end

    @cliente = Cliente.find_by(id: params[:q]['cliente_id_eq']) unless params[:q].nil?
    @ligacoes = @q.result(distinct: true).where(tipo: 0, ligacao_old: nil).order(data_inicio: :desc)
    @anexos = Anexo.where(cliente_id: @cliente.id) if @cliente.present?

    respond_to do |format|
      format.html
      format.json { render json: @ligacoes, status: 200 }
    end
  end

  def ligacoes_por_estado
    @q = Ligacao.search params[:q]

    unless params[:q]
      @q.data_inicio_gteq ||= Time.now.beginning_of_day.strftime('%d/%m/%Y %H:%M')
      @q.data_inicio_lteq ||= Time.now.end_of_day.strftime('%d/%m/%Y %H:%M')
      @q.empresa_id_eq ||= current_empresa.id
    end

    @cliente = Cliente.find_by(id: params[:q]['cliente_id_eq']) unless params[:q].nil?

    @ligacoes = @q.result(distinct: true).where(tipo: 0).order(data_inicio: :desc)
    historico = []
    @ligacoes.each do |ligacao|
      aux = { id: ligacao.id }
      aux['razaosocial'] = ligacao.cliente.razao_social unless ligacao.cliente.nil?
      aux['razaosocial'] = ' ' unless ligacao.cliente.present?

      aux['descricao'] = ligacao.cliente.cidade.descricao_completa unless ligacao.cliente.cidade.nil?
      aux['descricao'] = ' ' unless ligacao.cliente.cidade.present?

      aux['responsavel'] = ligacao.cliente.responsavel unless ligacao.cliente.nil?

      aux['data_inicio'] = ligacao.data_inicio.strftime('%d/%m/%Y %H:%M:%S') unless ligacao.data_inicio.nil?
      aux['data_inicio'] = ' ' unless ligacao.data_inicio.present?

      aux['data_fim'] = ligacao.data_fim.strftime('%d/%m/%Y %H:%M:%S') unless ligacao.data_fim.nil?
      aux['data_fim'] = ' ' unless ligacao.data_fim.present?

      aux['tempo'] = ligacao.tempo_ligacao

      aux['status_ligacao'] = ligacao.status_ligacao.descricao unless ligacao.status_ligacao.nil?
      aux['status_ligacao'] = '' unless ligacao.status_ligacao.present?

      aux['status_cliente'] = ligacao.status_cliente.descricao unless ligacao.status_cliente.nil?
      aux['status_cliente'] = ' ' unless ligacao.status_cliente.present?

      aux['observacao'] = ligacao.observacao unless ligacao.observacao.nil?
      aux['observacao'] = ' ' unless ligacao.observacao.present?

      aux['usuario'] = ligacao.user.name unless ligacao.user.nil?
      aux['usuario'] = ' ' unless ligacao.user.present?
      historico.push(aux)
    end

    render json: historico
  end

  def atualizar_cidades
    estado = Estado.find_by(sigla: estado_sigla)
    @cidades = Cidade.where(estado_id: estado).pluck(:nome, :id)
  end

  def show
    render json: @ligacao
  end

  def update
    respond_to do |format|
      if @ligacao.update(ligacao_params)
        format.json { render json: @ligacao, status: 200 }
      else
        format.json { render json: { errors: @ligacao.errors }, status: 422 }
      end
    end
  end

  def create
    @ligacao = Ligacao.new(ligacao_params)
    @ligacao.update(user: current_user, data_inicio: Time.now, empresa: @ligacao.cliente.empresa, tipo: 0)

    if @ligacao.agendamento_retorno_id.nil?
      retorno = AgendamentoRetorno.where(cliente: @ligacao.cliente, data_efetuado_retorno: nil, cancelado: false).first
      @ligacao.agendamento_retorno = retorno if retorno.present?
    end

    respond_to do |format|
      if @ligacao.save
        FilaEmpresa.where(cliente_id: @ligacao.cliente_id).destroy_all

        format.json { render json: @ligacao }
      else
        format.json { render json: { errors: @ligacao.errors }, status: 422 }
      end
    end
  end

  def get_proximo_cliente
    cliente = Cliente.where(user_atendimento: current_user, em_atendimento: true, empresa: current_empresa).order(id: :asc).limit(1).first

    if cliente.present?
      FilaEmpresa.where(cliente_id: cliente.id).destroy_all
      return render json: cliente, status: 200
    end

    cont = 0
    begin
      cliente = LigacoesHelper.find_next_cliente(current_empresa.id, current_user.id)

      if cliente.present? && cliente.fechamento.present?
        FilaEmpresa.where(cliente_id: cliente.id).destroy_all
        cliente = nil
      end

      cont += 1
    end until cliente.present? || cont == 6

    if cliente.present?
      FilaEmpresa.where(cliente_id: cliente.id).destroy_all

      session[:empresa_id] = cliente.empresa_id
      render json: cliente, status: 200
    else
      render json: { nothing: true, status: 204 }
    end
  end

  def user_em_atendimento
    if current_empresa.present?
      @cliente = Cliente.where(user_atendimento: current_user, em_atendimento: true, empresa_id: current_empresa.id).limit(1).first
      render json: @cliente
    end
  end

  def ligacao_em_andamento
    cliente = Cliente.find params[:cliente_id]
    @ligacao = cliente.ligacoes.where(data_fim: nil, user: current_user, is_captacao_coletiva: false).limit(1).first

    render json: @ligacao
  end

  def set_status_ligacao
    if @ligacao.nil? || params[:status].blank?
      return render json: { success: false }, status: 422
    end

    unless @ligacao.agendamento_retorno.nil?
      retorno = @ligacao.agendamento_retorno
      retorno.update(user_retorno: current_user, data_efetuado_retorno: Time.now)
    end

    @ligacao.status_ligacao = StatusLigacao.find params[:status].to_i
    @ligacao.observacao = params[:ligacao_observacoes]

    FilaEmpresa.where(cliente_id: @ligacao.cliente_id).destroy_all
    if params[:status].to_i < 5
      @ligacao.data_fim = Time.now

      cliente = @ligacao.cliente
      cliente.reload

      if cliente.fechamento.nil?
        if @ligacao.status_ligacao.is_nao_atende?
          @ligacao.status_cliente_id = 5
        else
          @ligacao.status_cliente_id = if @ligacao.status_ligacao.is_numero_errado?
                                         8
                                       else
                                         params[:status_cliente_id].to_id
                                       end
        end
      else
        @ligacao.status_cliente_id = cliente.status_id
      end

      numero_fila = cliente.numero_fila
      cliente.update(em_atendimento: false, user_atendimento: nil, status_id: @ligacao.status_cliente_id, status_empresa: @ligacao.status_cliente.status_empresa, numero_fila: nil)

      if numero_fila.present? && cliente.status_id == 5
        fila = FilaEmpresa.new(empresa: cliente.empresa, cliente: cliente)

        fila.numero_fila = LigacoesHelper.buscar_numero_fila(cliente.empresa_id, numero_fila, cliente)

        fila.save
      end
      current_user.update(em_atendimento: false)
      flash[:success] = 'Ligação finalizada!'
    end

    @ligacao.save

    render json: @ligacao
  end

  def finalizar_ligacao
    @ligacao.data_fim = Time.now
    @ligacao.observacao = params[:ligacao_observacoes] if params[:ligacao_observacoes].present?
    # @ligacao.observacao = params[:ligacao_observacoes] if params[:ligacao_observacoes].present? && @ligacao.observacao.nil?
    @ligacao.status_cliente_id = params[:status_cliente_id] if params[:status_cliente_id].present?
    @ligacao.status_ligacao_id = params[:status_id] if params[:status_id].present?

    if @ligacao.status_cliente.nil?
      return render json: { success: false }, status: 422
    end

    cliente = @ligacao.cliente
    cliente.reload
    cliente.update(em_atendimento: false, user_atendimento: nil, numero_fila: nil)

    cliente.update(status: @ligacao.status_cliente, status_empresa: @ligacao.status_cliente.status_empresa) if @ligacao.status_cliente.present?
    cliente.reload
    UpdateStatusNegociacaoClosed.new(@ligacao, cliente, params[:negociador_id], current_user).call

    if cliente.fechamento.nil?
      if @ligacao.status_cliente.fechamento? && cliente.fechamento.nil? && params[:tipo_fechamento_id].present?
        registrarFechamento(@ligacao.data_inicio, params[:tipo_fechamento_id], current_user, cliente, cliente.propostas.where(ativa: true).first)
      end
    else
      @ligacao.status_cliente_id = cliente.status_id
    end

    if !@ligacao.agendamento_retorno.nil? && @ligacao.agendamento_retorno.data_efetuado_retorno.nil?
      @ligacao.agendamento_retorno.update(user_retorno: current_user, data_efetuado_retorno: Time.now)
    end

    FilaEmpresa.where(cliente_id: cliente.id).destroy_all

    @ligacao.save
    flash[:success] = 'Ligação finalizada com sucesso!'
    current_user.update(em_atendimento: false)

    render json: @ligacao
  end

  def finalizar_ligacao_escritorio
    @ligacao.data_fim = Time.now
    @ligacao.observacao = ligacao_params[:observacoes] if ligacao_params[:observacoes].present?
    @ligacao.status_ligacao_id = 6

    status = Status.find 21
    cliente = @ligacao.cliente
    cliente.reload
    cliente.update(em_atendimento: false, user_atendimento: nil, numero_fila: nil, status: status, status_empresa: status.status_empresa)

    FilaEmpresa.where(cliente_id: cliente.id).destroy_all

    @ligacao.save

    UpdateStatusNegociacaoClosed.new(@ligacao, cliente, params[:negociador_id], current_user).call

    current_user.update(em_atendimento: false)

    render json: @ligacao
  end

  def cadastrar_sistema_terceiro
    @sistema = if params[:sistema_id].blank?
                 SistemaTerceiro.new
               else
                 SistemaTerceiro.find params[:sistema_id]
               end

    @sistema.update(sistema_terceiros_params)
    @sistema.update(user: current_user)

    render json: @sistema
  end

  def sistema_especifico
    @cliente = Cliente.where(id: params[:cliente_id]).first

    if @cliente.present?
      @cliente.update(status_id: 9, em_atendimento: false, user_atendimento: nil, numero_fila: nil, status_empresa: 3)

      observacao = params[:obs]
      observacao = 'SISTEMA ESPEFICICO' if observacao.nil?

      ligacao = @cliente.ligacoes.last
      if ligacao.present?
        ligacao.update(data_fim: Time.now, observacao: observacao, status_cliente_id: 9)

        UpdateStatusNegociacaoClosed.new(@ligacao, @cliente, params[:negociador_id], current_user).call
      end

      current_user.update(em_atendimento: false)
      render json: @cliente, each_serializer: ClienteShortSerializer
    else
      return render json: { success: false }, status: 422
    end
  end

  def cancelar_atendimentos_usuario
    clientes = Cliente.where(user_atendimento: current_user, em_atendimento: true, empresa: current_empresa).order(id: :asc)

    clientes.each do |cliente|
      cliente.update(user_atendimento: nil, em_atendimento: false)

      Ligacao.where(cliente: cliente, user: current_user, data_fim: nil).destroy_all
    end

    head 204
  end

  def enviado_whats
    @cliente = Cliente.where(id: params[:cliente_id]).first

    if @cliente.present?
      @cliente.update(status_id: 31, em_atendimento: false, user_atendimento: nil, numero_fila: nil, status_empresa: 2)

      observacao = params[:obs]
      observacao = 'ENVIADO WHATSAPP' if observacao.blank?

      ligacao = @cliente.ligacoes.last
      if ligacao.present?
        ligacao.update(data_fim: Time.now, observacao: observacao, status_cliente_id: 31)

        UpdateStatusNegociacaoClosed.new(@ligacao, @cliente, params[:negociador_id], current_user).call
      end

      FilaEmpresa.where(cliente_id: @cliente.id).destroy_all

      current_user.update(em_atendimento: false)
      render json: @cliente, each_serializer: ClienteShortSerializer
    else
      return render json: { success: false }, status: 422
    end
  end

  def ligacoes_old
    cliente = Cliente.find params[:cliente]
    @ligacoes = cliente.ligacoes.where(ligacao_old: true).order(data_inicio: :desc)

    render json: @ligacoes
  end

  def mostrar_ligacoes_filtradas
    params[:captacao][:cnae] = params[:captacao][:cnae].split(',')
    @captacoes = LigacaoEmMassa::BuscarFilaPrincipal.new(params[:captacao]).call
    render partial: 'ligacoes/tabela_captacao', locals: {
      captacoes: @captacoes
    }
  end

  def redirect_to_whats
    ligacao = Ligacao.find params[:id]
    link_completo = ligacao.link_whats.to_s

    redirect_to link_completo
  end

  def enviar_captacao_em_massa
    ActiveRecord::Base.transaction do
      begin
        captacao = params['captacao']
        captacao['cnae'] = captacao['cnae'].reject(&:blank?)

        filas = LigacaoEmMassa::BuscarFilaPrincipal.new(captacao).call
        cliente_ids = filas.pluck(:cliente_id)

        usuarios = captacao[:responsavel].reject(&:blank?)
        ligacoes_separadas = LigacaoEmMassa::DistribuicaoUsuarios.new(cliente_ids, usuarios).call
        return render json: { success: false, message: 'Existe usuário cadastrado sem telefone!' }, status: 500 if ligacoes_separadas.any?{ |e| e.nil? }

        GerarLigacaoEmMassaWorker.perform_async(ligacoes_separadas)
        return render json: { success: false }, status: 500 unless ligacoes_separadas.present?
        render json: { message: 'Captação em massa enviada com sucesso!' }, status: :ok
      rescue StandardError => exception
        puts exception
        render json: { message: "Ocorreu um erro: #{exception}" }, status: 500
        raise ActiveRecord::Rollback
      end
    end
  end

  private

  def sistema_terceiros_params
    params.require(:sistema_terceiro).permit(:cliente_id, :empresa, :nome, :mensalidade, :observacao)
  end

  def ligacao_params
    params.require(:ligacao).permit(:observacao, :data_inicio, :data_fim, :status_cliente_id, :status_ligacao_id, :cliente_id, :agendamento_retorno_id)
  end

  def set_ligacao
    @ligacao = Ligacao.find params[:id]
  end

  def registrarFechamento(data_inicio, tipo_fechamento_id, user, cliente, proposta)
    Fechamento.where(cliente_id: cliente.id, empresa_id: cliente.empresa_id).update_or_create(data_fechamento: data_inicio, tipo_fechamento_id: tipo_fechamento_id, user: user, proposta: proposta, cliente: cliente, status: cliente.status, empresa: cliente.empresa)
    NotificacoesHelper.registrar_fechamento(cliente.empresa_id, @ligacao.cliente, current_user.id, @ligacao.status_cliente, proposta)
  end
end
