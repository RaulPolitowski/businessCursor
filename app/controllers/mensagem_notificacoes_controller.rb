# frozen_string_literal: true

class MensagemNotificacoesController < ApplicationController
  before_action :new_instance, only: %i[new]
  before_action :set_mensagem_notificacao, only: %i[edit update destroy ativar_desativar render_form]
  before_action :cast_destinatarios_to_array, only: %i[create update]
  before_action :set_variaveis_notificacao, only: %i[new edit create render_form]

  def index
    @mensagem_notificacoes = MensagemNotificacao.where(ativo: true)
    @mensagem_notificacoes_desativados = MensagemNotificacao.where(ativo: false)
  end

  def new
  end

  def edit
  end

  def create
    @mensagem_notificacao = MensagemNotificacao.new(mensagem_notificacao_params)
    respond_to do |format|
      if @mensagem_notificacao.save
        flash[:success] = 'Notificação whatsapp foi criado com sucesso'
        format.html { redirect_to mensagem_notificacoes_path }
      else
        flash[:error] = @mensagem_notificacao.errors.full_messages.to_sentence
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @mensagem_notificacao.update!(mensagem_notificacao_params)
        format.html { redirect_to mensagem_notificacoes_path, notice: 'Notificação whatsapp foi atualizado com sucesso' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @mensagem_notificacao.errors, status: :unprocessable_entity }
      end
    end
  end

  def ativar_desativar
    respond_to do |format|
      if @mensagem_notificacao.update!(ativo: !@mensagem_notificacao.ativo)
        @mensagem_notificacao.gzap_usuarios_mensagem_notificacoes.each { |notify| notify.send_changes_to_api_gzap ativo: @mensagem_notificacao.ativo?} if @mensagem_notificacao.interesse?
        numero = @mensagem_notificacao.numero_notificacao.numero
        tipo = @mensagem_notificacao.tipo
        message = @mensagem_notificacao.ativo? ? "A notificação de #{tipo} do número #{numero} foi ativada!" : "A notificação de #{tipo} do número #{numero} foi desativada!"
        format.html { redirect_to mensagem_notificacoes_path, notice: message }
        format.json { head :no_content }
      else
        format.html { render action: 'index' }
        format.json { render json: @mensagem_notificacao.errors, status: :unprocessable_entity }
      end
    end
  end

  def render_form
    @mensagem_notificacao ||= new_instance
    @mensagem_notificacao.tipo = params[:tipo]
    render partial: 'mensagem_notificacoes/form', locals: {
      tipo: params[:tipo]
    }
  end

  private

  def set_mensagem_notificacao
    @mensagem_notificacao = MensagemNotificacao.find(params[:id]) if params[:id]
  end

  def set_variaveis_notificacao
    @variaveis_mensagem =
      if params[:tipo] == 'INTERESSE' || @mensagem_notificacao&.tipo == 'INTERESSE'
        MensagemNotificacao.new.variaveis_interesse.keys.map(&:to_s).join(', ')
      elsif params[:tipo] == 'VENDAS' || @mensagem_notificacao&.tipo == 'VENDAS'
        MensagemNotificacao.new.variaveis_vendas.keys.map(&:to_s).join(', ')
      else
        MensagemNotificacao.new.variaveis_lista_captacao.keys.map(&:to_s).join(', ')
      end
  end

  def cast_destinatarios_to_array
    destinatarios = params[:mensagem_notificacao][:destinatarios]
    params[:mensagem_notificacao][:destinatarios] = destinatarios.split(',').map(&:strip) unless destinatarios.nil?
  end

  def mensagem_notificacao_params
    parametros = params.require(:mensagem_notificacao).permit(:numero_notificacao_id, :mensagem, :tipo, :ativo, { gzap_usuario_ids: [] }, :gzap_usuario_ids, { destinatarios: [] } )
    parametros[:gzap_usuario_ids] = parametros[:gzap_usuario_ids].reject { |p| p.empty? } if parametros[:gzap_usuario_ids]
    parametros
  end

  def new_instance
    @mensagem_notificacao = MensagemNotificacao.new
  end
end
