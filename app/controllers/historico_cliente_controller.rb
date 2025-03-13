class HistoricoClienteController < ApplicationController
  skip_before_action :verify_authenticity_token

  def show
    @cliente = Cliente.find_by_id params[:id]
    @negociacao = @cliente.negociacao
    @fechamento = @cliente.fechamento
    @implantacao = @cliente.implantacao
    @acompanhamento = @cliente.acompanhamento
    @activities = PublicActivity::Activity.where(recipient_id: @cliente.id, recipient_type: "Cliente").where('key <> ?', 'user.cancelou_atendimento').order("created_at desc")
    @activities_acompanhamento = PublicActivity::Activity.where(recipient_id: @acompanhamento.id, recipient_type: "Acompanhamento").order("created_at desc") if @acompanhamento.present?
    @activities_implantacao = PublicActivity::Activity.where(recipient_id: @implantacao.id, recipient_type: "Implantacao").order("created_at desc") if @implantacao.present?
    @activities_negociacao = PublicActivity::Activity.where(recipient_id: @negociacao.id, recipient_type: "Negociacao").order("created_at desc") if @negociacao.present?
    @ligacoes = @cliente.ligacoes.where(ligacao_old: nil).order(data_inicio: :desc)
    @propostas = @cliente.propostas.order(id: :desc)
    @agenda = @implantacao.agenda if @implantacao.present? && @implantacao.agenda.present?
    @inertes = PeriodoInerte.where(cliente_id: @cliente.id)
    @pesquisas = Pesquisa.where(cliente_id: @cliente.id)
    @ligacoes_old = @cliente.ligacoes.where(ligacao_old: true).order(data_inicio: :desc)       
    @activities_acomp = PublicActivity::Activity.where(recipient_id: @cliente.hist_acomp_id, recipient_type: "Acompanhamento_old").order("created_at desc")
    @activities_impl = PublicActivity::Activity.where(recipient_id: @cliente.hist_impl_id, recipient_type: "Implantacao_old").order("created_at desc")
    @anexos = Anexo.where(cliente_id: @cliente.id)
  end

  def get_periodos_inertes_cliente
    if params[:aguardando].eql? "true"
      inertes = PeriodoInerte.where(cliente_id: params[:cliente_id]).where.not(data_feedback: nil)
    else
      inertes = PeriodoInerte.where(cliente_id: params[:cliente_id]).where.not(data_avaliacao: nil)
    end

    render json: inertes, status: 200
  end

  def aguardando_inertes
    @q = PeriodoInerte.where('feedback is null and periodo_inertes.empresa_id in (1,2,3,4,7,8,9,13,14,15,16,17,18,19)').search params[:q]

    @empresas_inertes = @q.result(distinct: true).order(tempo_inerte: :asc)
  end

  def aguardando_pesquisa
    @q = Pesquisa.where('data <= ? and user_id is null and pesquisas.empresa_id in (1,2,3,4,7,8,9,13,14,15,16,17,18,19)', Time.now.to_date).search params[:q]

    @pesquisas = @q.result(distinct: true).order(tempo: :asc)
  end

  def avaliacao_inertes
    @q = PeriodoInerte.where('avaliacao is null and feedback is not null and periodo_inertes.empresa_id in (1,2,3,4,7,8,9,13,14,15,16,17,18,19)').search params[:q]

    @empresas_inertes = @q.result(distinct: true).order(:data_feedback, :tempo_inerte)
  end

  def avaliacao_pesquisa
    @q = Pesquisa.where('user_id is not null and data_avaliacao is null and pesquisas.empresa_id in (1,2,3,4,7,8,9,13,14,15,16,17,18,19)').search params[:q]

    @pesquisas = @q.result(distinct: true).order(:data_pesquisa)
  end

  def show_periodo_inerte
    @periodo = PeriodoInerte.find params[:periodo_id]

    if params[:validar].eql? "true"
      if @periodo.last_login.to_i != @periodo.cliente.ultimo_login.to_i
        @periodo.delete
        return head :no_content
      end
    end

    render json: @periodo
  end

  def show_pesquisa
    @pesquisa = Pesquisa.find params[:pesquisa_id]
    render json: @pesquisa
  end

  def registrar_feedback
    @periodo = PeriodoInerte.find params[:periodo_id]
    @periodo.feedback = params[:periodo_feedback]
    @periodo.data_feedback = Time.now
    @periodo.user_feedback_id = current_user.id
    
    if @periodo.save

      if params[:periodo_ignorar_inerte_ate].present?
        @periodo.cliente.update(sem_inerte_ate: params[:periodo_ignorar_inerte_ate])
      end

      render json: @periodo, status: 200
    else
      render json: @periodo.errors, status: 422
    end
  end

  def registrar_avaliacao
    @periodo = PeriodoInerte.find params[:periodo_id]
    @periodo.avaliacao = params[:periodo_avaliacao]
    @periodo.positivo = ApplicationHelper.true? params[:periodo_resultado]
    @periodo.data_avaliacao = Time.now
    @periodo.user_avaliacao_id = current_user.id
    if @periodo.save

      if params[:periodo_ignorar_inerte_ate].present?
        @periodo.cliente.update(sem_inerte_ate: params[:periodo_ignorar_inerte_ate])
      end

      render json: @periodo, status: 200
    else
      render json: @periodo.errors, status: 422
    end
  end

  def registrar_avaliacao_pesquisa
    @pesquisa = Pesquisa.find params[:pesquisa_id]
    @pesquisa.avaliacao = params[:pesquisa_avaliacao]
    @pesquisa.positivo = ApplicationHelper.true? params[:pesquisa_resultado]
    @pesquisa.data_avaliacao = Time.now
    @pesquisa.user_avaliacao_id = current_user.id
    if @pesquisa.save
      render json: @pesquisa, status: 200
    else
      render json: @pesquisa.errors, status: 422
    end
  end

  def reprocessar_inertes
    PeriodoInerte.verificar_empresas_inertes()

    flash[:success] = 'Reprocessado com sucesso!'
    redirect_to aguardando_inertes_historico_cliente_index_path
  end

  def reprocessar_pesquisas
    Pesquisa.registrar_pesquisas()

    flash[:success] = 'Reprocessado com sucesso!'
    redirect_to aguardando_pesquisa_historico_cliente_index_path
  end

  include ActionView::Helpers::NumberHelper
  def financeiro_cnpj
    connection = Financeiro::HonorarioMensal.connection
    lista = connection.select_all FinanceiroHelper.get_debitos_financeiro params[:cnpj]

    lista.each do |val|
      val['valor'] = number_to_currency(val['valor'])
    end

    render json: lista, status: 200
  end

  def pesquisa_respostas
    pesquisa = Pesquisa.find params[:pesquisa_id]

    render json: pesquisa.pergunta_pesquisa_respostas
  end

end
