class WhatsappNumerosController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_filter :authorize_admin
  skip_before_filter :authorize_admin, only: [:desconectar_numero]
  before_action :set_whatsapp_numero, only: [:show, :edit, :update, :destroy, :set_numero_conectado, :desconectar_numero_manualmente, :conectar_numero]
  skip_before_action :authenticate_user!, only: [:desconectar_numero]
  include NumeroConexao

  NumeroGzap = Struct.new(:numero, :nome, :chat_pro, :instancia_id, :token_chat_pro, :isNotificacao)

  def index
    @numeros = WhatsappNumero
      .includes(:user, :loja_item)
      .where(banido: false)
      .joins('left join loja_itens li on li.numero = whatsapp_numeros.numero')
      .where("li.status = 'COMPRADO' OR (li.id IS NUll AND li.status IS NULL)")
    @banidos = WhatsappNumero.includes(:user, :loja_item).where(banido: true)
    WhatsappBotService.new.update_number_status(@numeros, true)
  end

  def show
    respond_to do |format|
      format.html { render nothing: true }
      format.json { render json: @numero }
    end
  end

  def new
    @numero = WhatsappNumero.new
  end

  def edit
  end

  def conectar_numero
    nome = params[:nome] || (@numero.nome if @numero.present?) || 'NOTIFICACAO'
    numero_gzap = NumeroGzap.new(
      params[:numero],
      nome,
      nil,
      nil,
      nil,
      ApplicationHelper.true?(params[:isNotificacao]) || false
    )
    conectar_numero_gzap(numero_gzap)
  end

  def create
    @numero = WhatsappNumero.new(whatsapp_numero_params)

    respond_to do |format|
      if @numero.save
        flash[:success] = 'Número criado com sucesso'
        format.html { redirect_to whatsapp_numeros_path }
      else
        flash[:error] = @numero.errors.full_messages.to_sentence
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @numero.update(whatsapp_numero_params)
        if @numero.banido?
          @numero.update!(data_banimento: DateTime.now());
          WhatsappBotService.new(numero: @numero).disconnect
          campanhas_em_andamento = Campanha.where(numero: @numero.numero, status:['ANDAMENTO', 'ENVIADA', 'NAO ENVIADA'])
          campanhas_em_andamento.update_all(status: 'FINALIZADO', updated_at: DateTime.now())
        end
        flash[:success] = 'Número alterado com sucesso'
        format.html { redirect_to whatsapp_numeros_path }
      else
        flash[:error] = @numero.errors.full_messages.to_sentence
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @numero.destroy
    respond_to do |format|
      format.html { redirect_to whatsapp_numeros_path }
      format.json { head :no_content }
    end
  end

  def qrcode
    numero_gzap = NumeroGzap.new(params[:numero], params[:nome] ||= 'NOTIFICACAO')
    response = WhatsappBotService.new(numero: numero_gzap).qrcode
    render json: response, status: 200
  end

  def set_numero_conectado
    @numero.update!(status: 'CONECTADO')
    render json: @numero, status: 200
  end

  def desconectar_numero
    return render json:{error: 'Informe um número'}, status: 422 if params[:numero].nil?
    numero = WhatsappNumero.find_by_numero! params[:numero]
    numero.update!(status: 'DESCONECTADO')
    dias = TimeDifference.between(Time.now, numero.created_at).in_days
    Notificacao.criar_notificacao_numero_desconectado(params[:numero], numero.nome, dias)
    render json: {}, status: 202
  end

  def desconectar_numero_manualmente
    response = desconectar_numero_gzap(@numero)
    @numero.update!(status: 'DESCONECTADO')
    render json: response, status: 200
  end

  def ativar_numero_ocultado
    WhatsappNumero.ativar_numero_ocultado(params[:id])
    redirect_to campanhas_path
  end

  private

  def set_whatsapp_numero
    query = params[:id] ? { id: params[:id] } : { numero: params[:numero]}
    @numero = WhatsappNumero.find_by(query)
  end

  def whatsapp_numero_params
    params.require(:whatsapp_numero).permit(:nome, :user_id, :banido, :numero, :chat_pro, :instancia_id, :token_chat_pro, :is_ocultado)
  end
end
