class NumeroNotificacoesController < ApplicationController
  before_action :set_numero_notificacao, only: [:edit, :update, :desconectar_numero]
  include NumeroConexao

  NumeroGzap = Struct.new(:numero, :nome, :chat_pro, :instancia_id, :token_chat_pro, :isNotificacao)

  def index
    @numero_notificacoes = NumeroNotificacao.where(banido: false)
    WhatsappBotService.new.update_number_status(@numero_notificacoes, true)
  end

  def new
    @numero_notificacao = NumeroNotificacao.new
  end

  def edit
  end

  def create
    @numero_notificacao = NumeroNotificacao.new(numero_notificacao_params)
    
    respond_to do |format|
      if @numero_notificacao.save
        flash[:success] = 'Número criado com sucesso'
        format.html { redirect_to numero_notificacoes_path }
      else
        flash[:error] = @numero_notificacao.errors.full_messages.to_sentence
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @numero_notificacao.update(numero_notificacao_params)
        format.html { redirect_to numero_notificacoes_path, notice: 'Numero de notificacão foi alterado com sucesso!' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @numero_notificacao.errors, status: :unprocessable_entity }
      end
    end
  end

  def desconectar_numero
    response = desconectar_numero_gzap(@numero_notificacao)
    @numero_notificacao.update!(status: 'DESCONECTADO')
    render json: response, status: 200
  end
  
  private
    def set_numero_notificacao
      @numero_notificacao = params[:id] ? NumeroNotificacao.find(params[:id]) : NumeroNotificacao.find_by(numero: params[:numero])
    end

    def numero_notificacao_params
      params.require(:numero_notificacao).permit(:numero, :nome, :banido, :qrcode, :status)
    end
end
