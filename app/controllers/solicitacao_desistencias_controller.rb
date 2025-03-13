# frozen_string_literal: true

class SolicitacaoDesistenciasController < ApplicationController
  before_action :set_solicitacao_desistencia, only: %i[show edit update destroy]
  skip_before_action :authenticate_user!, only: [:find_cliente]

  # GET /solicitacao_desistencias
  # GET /solicitacao_desistencias.json
  def index
    @solicitacao_desistencias = SolicitacaoDesistencia.sem_tags_troca_cnpj
  end

  # GET /solicitacao_desistencias/1
  # GET /solicitacao_desistencias/1.json
  def show
    @solicitacao_desistencia = @solicitacao_desistencia # coloquei pra usar nos anexos
    @cliente = @solicitacao_desistencia.cliente

    response = RestClient::Request.execute(method: :get, url: "http://api.gtech.site/companies/#{@solicitacao_desistencia.cnpj}",
                                           headers: { Accept: 'application/vnd.germantech.v2',
                                                      Authorization: Digest::MD5.hexdigest(Time.new.strftime('%Y11586637000128%m%-d')) },
                                           timeout: 300, open_timeout: 300, read_timeout: 300)

    resposta = JSON.parse(response)

    @ultimo_acesso = resposta['last_login'].to_time.strftime('%d/%m/%Y %H:%M') if resposta['last_login'].present?
    @dias_sem_uso = resposta['count_days_dont_access'].to_i if resposta['count_days_dont_access'].present?

    @status = nil
    if resposta['is_blocked'].eql? false
      @status = 'Ativo'
    elsif resposta['is_blocked'].eql? true
      @status = 'Bloqueado'
    elsif resposta['observation'].eql? 'Não há contrato e/ou honorario ativo para o CNPJ.'
      @status = 'Paralisado'
    end

    # @dias_cliente = (Date.today - resposta['installation_date'].to_date).to_i
    connectionFinanceiro = Financeiro::HonorarioMensal.connection
    @cliente_fin = connectionFinanceiro.select_all SolicitacaoDesistenciaExternoHelper.get_cliente_financeiro(@cliente.cnpj)
    @cliente_fin = @cliente_fin[0]

    connection = Api::Contacts.connection
    contatos = connection.select_all "select * from contacts where cnpj='#{@cliente.cnpj}'"

    # separar em 2 colunas
    @contatos1 = []
    @contatos2 = []
    metade = (contatos.count / 2).to_i
    metade.times do |i|
      @contatos1.push(contatos[i])
    end
    (metade..(contatos.count - 1)).each do |i|
      @contatos2.push(contatos[i])
    end

    @anexos = Anexo.where(solicitacao_desistencia_id: @solicitacao_desistencia.id)
    @activities = PublicActivity::Activity.where(recipient_id: @solicitacao_desistencia.id, recipient_type: 'SolicitacaoDesistencia').order('created_at desc')
    @acordos = @activities.where(" parameters like '%acordo: true%' ")
    @retornos = @activities.where(" parameters like '%acordo: false%' ")
    # @retornos = PublicActivity::Activity.where(recipient_id: @solicitacao_desistencia.id, recipient_type: "SolicitacaoDesistencia").where.not(parameters: nil).order("created_at desc")

    tags = @solicitacao_desistencia.tags
    @tags = []
    if tags.present?
      tags.each do |item|
        aux = TagsSolicitacaoDesistencia.find item
        @tags.push(aux.descricao) if aux.present?
      end
    end

    # debitos pagos
    @debitos_pagos = connectionFinanceiro.select_all SolicitacaoDesistenciasHelper.get_debitos_pagos(@cliente.cnpj)
    @debitos_pagos = @debitos_pagos.to_hash
    @total_recebido = @debitos_pagos.sum { |h| h['total'].to_d }
    @total_debitos = @debitos_pagos.sum { |h| h['valor'].to_d }
    @total_descontos = @debitos_pagos.sum { |h| h['desconto'].to_d }
    @total_juros = @debitos_pagos.sum { |h| h['juro'].to_d }
    @total_multa = @debitos_pagos.sum { |h| h['multa'].to_d }

    # debitos pendentes
    @debitos_pendentes = connectionFinanceiro.select_all SolicitacaoDesistenciasHelper.get_debitos_pendentes(@cliente.cnpj)
    @debitos_pendentes = @debitos_pendentes.to_hash
    @total_debitos_pdt = @debitos_pendentes.sum { |h| h['valor'].to_d }
    @total_multa_pdt = @debitos_pendentes.sum { |h| h['multa'].to_d }
    @total_juros_pdt = @debitos_pendentes.sum { |h| h['juro'].to_d }
    @total_saldo_pdt = @debitos_pendentes.sum { |h| h['saldo'].to_d }
  end

  # GET /solicitacao_desistencias/new
  def new
    @solicitacao_desistencia = SolicitacaoDesistencia.new
  end

  # GET /solicitacao_desistencias/1/edit
  def edit; end

  # POST /solicitacao_desistencias
  # POST /solicitacao_desistencias.json
  def create
    @solicitacao_desistencia = SolicitacaoDesistencia.new(solicitacao_desistencia_params)
    @solicitacao_desistencia.empresa = current_empresa
    @solicitacao_desistencia.user = current_user
    @solicitacao_desistencia.status = 'AGUARDANDO'
    desistencias = SolicitacaoDesistencia.where(cliente_id: solicitacao_desistencia_params[:cliente_id], status: %w[AGUARDANDO ANDAMENTO]).first

    respond_to do |format|
      if desistencias.present? && (Time.now.to_date - desistencias.data_solicitacao.to_date).to_i < 30
        flash[:error] = 'Já existe uma solicitação de desistência para esse cliente'
        format.html { render action: 'new' }
      else
        if @solicitacao_desistencia.cliente.nil?
          format.json { render json: 'Cliente não pode ser vazio', status: :unprocessable_entity }
        else
          if @solicitacao_desistencia.save
            connectionFinanceiro = Financeiro::HonorarioMensal.connection
            @cliente_fin = connectionFinanceiro.select_all SolicitacaoDesistenciaExternoHelper.get_cliente_financeiro(@solicitacao_desistencia.cliente.cnpj)
            @cliente_fin = @cliente_fin.first
            if @cliente_fin.present?
              Notificacao.criar_notificacoes_desistencia(@solicitacao_desistencia, current_user, @cliente_fin)
            end
            format.html { redirect_to @solicitacao_desistencia, notice: 'Solicitacao desistencia was successfully created.' }
            format.json { render action: 'show', status: :created, location: @solicitacao_desistencia }
          else
            format.html { render action: 'new' }
            format.json { render json: @solicitacao_desistencia.errors, status: :unprocessable_entity }
          end
        end
      end
    end
   end

  # PATCH/PUT /solicitacao_desistencias/1
  # PATCH/PUT /solicitacao_desistencias/1.json
  def update
    respond_to do |format|
      if @solicitacao_desistencia.update(solicitacao_desistencia_params)
        format.html { redirect_to @solicitacao_desistencia, notice: 'Solicitacao desistencia was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @solicitacao_desistencia.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /solicitacao_desistencias/1
  # DELETE /solicitacao_desistencias/
  def deletar_solicitacao
    solicitacao_desistencia = SolicitacaoDesistencia.find params[:id]

    if solicitacao_desistencia.status.eql? 'AGUARDANDO'
      solicitacao_desistencia.destroy

      render json: solicitacao_desistencia, status: 200
    else
      render json: 'Solicitação não esta com status AGUARDANDO.', status: 422
    end
  end

  def find_cliente
    @clientes = Cliente.where('(upper(unaccent(razao_social)) LIKE upper((?)) OR (upper(unaccent(cnpj)) LIKE  upper((?))))', "%#{params[:term]}%", "%#{params[:term]}%").where(ativo: true).order(:razao_social).limit(5)
    render json: @clientes, each_serializer: ClienteShortSerializer
  end

  def get_cliente_api
    response = RestClient::Request.execute(method: :get, url: "http://api.gtech.site/companies/#{params[:cnpj]}",
                                           headers: { Accept: 'application/vnd.germantech.v2',
                                                      Authorization: Digest::MD5.hexdigest(Time.new.strftime('%Y11586637000128%m%-d')) },
                                           timeout: 300, open_timeout: 300, read_timeout: 300)

    resposta = JSON.parse(response)

    resposta['ultimo_acesso'] = resposta['last_login'].to_time.strftime('%d/%m/%Y %H:%M')
    if resposta['is_blocked'].eql? false
      resposta['status'] = 'Ativo'
    elsif resposta['is_blocked'].eql? true
      resposta['status'] = 'Bloqueado'
    elsif resposta['observation'].eql? 'Não há contrato e/ou honorario ativo para o CNPJ.'
      resposta['status'] = 'Paralisado'
    end

    # resposta['dias_cliente'] = (Date.today - resposta['installation_date'].to_date).to_i if resposta['installation_date'].present?

    render json: resposta
  end

  def get_contatos_api
    connection = Api::Contacts.connection
    contatos = connection.select_all "select * from contacts where cnpj='#{params[:cnpj]}'"

    render json: contatos
  end

  def create_tag
    tag = TagsSolicitacaoDesistencia.create(descricao: params[:descricao])

    render json: tag
  end

  def finalizar
    solicitacao = SolicitacaoDesistencia.find params[:solicitacao_id]

    if params[:flag].eql? 'DESISTENTE'
      solicitacao.motivo_desistencia = params[:motivo]
      solicitacao.tags = [params[:tags].to_s]
      solicitacao.status = 'DESISTENTE'
      solicitacao.data_desistencia = Time.now
    else
      solicitacao.motivo_ficou = params[:motivo]
      solicitacao.status = 'RECUPERADO'
      solicitacao.data_recuperado = Time.now
    end

    solicitacao.save

    render json: solicitacao
  end

  def get_solicitacoes_status
    solicitacoes = SolicitacaoDesistencia.sem_tags_troca_cnpj.ransack(params[:q]).result

    if params[:data_inicio].present?
      solicitacoes = solicitacoes.where('data_solicitacao::date >= ?', params[:data_inicio].to_date)
    end

    if params[:data_fim].present?
      solicitacoes = solicitacoes.where('data_solicitacao::date <= ?', params[:data_fim].to_date)
    end

    solicitacoes = if params[:q]['status_eq'].eql? 'ANDAMENTO'
                     solicitacoes.order('data_inicio desc')
                   elsif params[:q]['status_eq'].eql? 'RECUPERADO'
                     solicitacoes.order('data_recuperado desc')
                   elsif params[:q]['status_eq'].eql? 'DESISTENTE'
                     solicitacoes.order('data_desistencia desc')
                   else
                     solicitacoes.order('created_at desc')
                   end

    render json: solicitacoes
  end

  def activities
    @solicitacao_desistencia = SolicitacaoDesistencia.find params[:id]
    @activities = PublicActivity::Activity.where(recipient_id: @solicitacao_desistencia.id, recipient_type: 'SolicitacaoDesistencia').order('created_at desc')

    render partial: 'solicitacao_desistencias/modals/activities_solicitacao_desistencia'
  end

  def alterar_status
    solicitacao = SolicitacaoDesistencia.find params[:id]
    if params[:painel].eql? 'painel0'
      solicitacao.update(status: 'AGUARDANDO')
    elsif params[:painel].eql? 'painel1'
      solicitacao.update(status: 'ANDAMENTO', data_inicio: Time.now)
    elsif params[:painel].eql? 'painel2'
      solicitacao.update(status: 'RECUPERADO', data_recuperado: Time.now)
    elsif params[:painel].eql? 'painel3'
      solicitacao.update(status: 'DESISTENTE', data_desistencia: Time.now)
    end

    render json: solicitacao
  end

  def montar_msg
    cliente = Cliente.find params[:cliente_id]
    is_cpf = cliente.razao_social.last(11)
    empresa = cliente.razao_social

    empresa = empresa[0..empresa.size - 13] if string_is_number? is_cpf

    abordagem = AbordagemInicial.find_by(ativa: true, tipo: params[:tipo], fila: 1)
    texto = AbordagemInicial.ajuste_saudacao(abordagem.texto)
    texto = AbordagemInicial.ajuste_empresa(texto, empresa)
    texto = AbordagemInicial.ajuste_usuario(texto, current_user.name)
    abordagem.texto = texto.sub '*', "\n"

    render json: abordagem
  end

  def iniciar_solicitacao
    solicitacao = SolicitacaoDesistencia.find params[:id]
    solicitacao.update(status: 'ANDAMENTO', data_inicio: Time.now)

    render json: solicitacao
  end

  def painel_desistencias; end

  def get_estatisticas_tags
    solicitacoes = SolicitacaoDesistencia.sem_tags_troca_cnpj

    if params[:data_inicio].present?
      solicitacoes = solicitacoes.where('data_solicitacao::date >= ?', params[:data_inicio].to_date)
      solicitacoes = solicitacoes.where('data_solicitacao::date <= ?', params[:data_fim].to_date) if params[:data_fim].present?
    else
      inicio = (Date.today - 1.month).beginning_of_month
      fim = (Date.today - 1.month).end_of_month
      solicitacoes = solicitacoes.where('data_solicitacao::date >= ?', inicio)
      solicitacoes = solicitacoes.where('data_solicitacao::date <= ?', fim)
    end

    tags = []
    solicitacoes.each do |item|
      next unless item.tags.present?

      item.tags.each do |tag|
        tags.push(tag.to_i)
      end
    end

    dados = []
    cont_tags = tags.each_with_object(Hash.new(0)) { |o, h| h[o] += 1 } # hash com count {1=>4, 3=>3, 6=>4}
    if tags.present?
      tags_distintas = tags.uniq
      tags_distintas.each do |item|
        aux = {}
        descricao = (TagsSolicitacaoDesistencia.find item).descricao
        aux['descricao'] = descricao
        aux['qtd'] = cont_tags[item]
        dados.push(aux)
      end
    end

    render json: dados
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_solicitacao_desistencia
    @solicitacao_desistencia = SolicitacaoDesistencia.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def solicitacao_desistencia_params
    params.require(:solicitacao_desistencia).permit(:cliente_id, :empresa_id, :user_id, :status, :data_solicitacao, :motivo_solicitacao, :motivo_desistencia, :solicitante, :telefone, :cnpj)
  end
end
