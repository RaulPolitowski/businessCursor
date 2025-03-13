class LojaItensController < ApplicationController
  before_action :set_loja_item, only: [:show, :edit, :update, :destroy, :conectar_qrcode]
  before_action :set_users, only: [:new, :edit]
  before_action :set_loja_itens, only: [:index, :get_loja_itens]

  def index
    numeros = WhatsappNumero.includes(:user, :loja_item).where(banido: false)
    WhatsappBotService.new.update_number_status(numeros, false)
  end

  def show
  end

  def new
    @loja_item = LojaItem.new
  end

  def edit
  end

  def create
    @loja_item = LojaItem.new(loja_item_params)
    respond_to do |format|
      if @loja_item.valid? && @loja_item.save
        format.html { redirect_to loja_itens_path, notice: "O número: #{@loja_item.numero} foi adicionado a loja!" }
        format.json { render action: 'index', status: :created, location: @loja_item }
      else
        flash[:error] = @loja_item.errors.full_messages.to_sentence
        format.html { redirect_to new_loja_item_path}
        format.json { render json: @loja_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @loja_item.update(loja_item_params)
        format.html { redirect_to loja_itens_path, notice: "O número #{@loja_item.numero} foi atualizado com sucesso!" }
        format.json { head :no_content }
      else
        flash[:error] = @loja_item.errors.full_messages.to_sentence
        format.html { redirect_to edit_loja_item_path(@loja_item.id) }
        format.json { render json: @loja_item.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    numero = WhatsappNumero.find_by(banido: false, numero: @loja_item.numero)
    response = WhatsappBotService.new(numero: @loja_item).disconnect
    if (response)
      numero.destroy! unless numero.nil?
      @loja_item.destroy!
    end

    respond_to do |format|
      format.html { redirect_to loja_itens_url }
      format.json { head :no_content }
    end
  end

  def comprar_numero
    loja_itens = LojaItem.where("id in (#{params[:numeroIds].join(', ')})") if params[:numeroIds].length > 0
    return render json: {errors: ['Não foi encontrado nenhum item na loja']}, status: 404 if loja_itens.nil?

    @numero = WhatsappNumero.find_by(numero: loja_itens.first.numero) if params[:numeroIds].length > 0
    return render json: {}, status: 404 if @numero.nil? && params[:numeroIds].length > 0

    loja_itens.update_all(status: 'COMPRADO')

    flash[:success] = "Número #{@numero.numero} comprado com sucesso!"
    render json: @numero ? @numero : {}, status: 200
  end

  def conectar_qrcode
    whatsapp_numero_params = {
      numero: @loja_item.numero,
      user_id: @loja_item.user_id,
      banido: false
    }

    @numero = WhatsappNumero.find_by(whatsapp_numero_params)
    @numero.update!(whatsapp_numero_params) if !@numero.nil? && @numero.loja_item_id != params[:id]

    if !!@numero.nil?
      whatsapp_numero_params = whatsapp_numero_params.merge(nome: @loja_item.apelido, loja_item_id: params[:id])
      @numero = WhatsappNumero.new(whatsapp_numero_params)
      @numero.save!
    end

    if !@numero.nil?
      whatsappBotService = WhatsappBotService.new(numero: @numero)
      whatsappBotService.disconnect if @numero.status === 'QRCODE'
      sleep(2)
      whatsappBotService.connect
      render json: @numero, status: 200
    else
      render json: {}, status: 404
    end
  end

  def get_loja_itens
    return render json: @loja_itens, status: 200 if !@loja_itens.nil?
  end

  def vendas_pendentes_vendedor
    connection = ActiveRecord::Base.connection
    response = connection.select_all LojaItensHelper.get_vendas_pendentes_vendedor()

    render json: response, status: 200
  rescue
    render json: {error: 'Ocorreu um erro'}, status: 500
  end

  private
    def set_loja_item
      @loja_item = LojaItem.find(params[:id])
    end

    def set_users
      @users = User.empresas_acesso(current_empresa.id)
    end

    def loja_item_params
      params.require(:loja_item).permit(:status, :numero, :user_id, :qrCode, :apelido)
    end

    def set_loja_itens
      @loja_itens = LojaItem.all.where.not(status: :COMPRADO)

      if params[:usuario_id] || params[:maturacao]
        @loja_itens = @loja_itens.where(user_id: [params[:usuario_id].split(',')]) if params[:usuario_id].present?
        isMinValue = params[:isMinValue] === 'true' ? true : false

        filtroData = isMinValue ? "<= CURRENT_DATE - interval '#{params[:maturacao]} days'" : "= '#{Time.now.to_date.days_ago(params[:maturacao].to_i)}'::date"

        @loja_itens = @loja_itens.where("created_at::date #{filtroData}") if params[:maturacao].to_i > 0
      end
    end
end
