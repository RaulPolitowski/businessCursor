class PacotesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_pacote, only: [:edit, :update, :destroy, :show]
  before_filter :authorize_admin, only: [:create, :new, :edit, :update, :index]

  def index
    @pacotes = Pacote.where(empresa: current_empresa)
  end

  def new
    @pacote = Pacote.new
  end

  def edit
  end

  def show
    respond_to do |format|
      format.html {render nothing: true}
      format.json {render json: @pacote}
    end
  end

  def create
    @pacote = Pacote.new(pacote_params)
    @pacote.empresa = current_empresa

    respond_to do |format|
      if @pacote.save
        @pacote.replicar_pacote_todas_empresas(@pacote.empresa_id)
        flash[:success] = 'Pacote criado com sucesso'
        format.html { redirect_to pacotes_path }
      else
        flash[:error] =  @pacote.errors.full_messages.to_sentence
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      @pacote.sistema_id = pacote_params[:sistema_id]
      @pacote.mensalidade = parse_valor_rails pacote_params[:mensalidade]
      @pacote.mensalidade_promocional = parse_valor_rails pacote_params[:mensalidade_promocional]
      @pacote.implantacao = parse_valor_rails pacote_params[:implantacao]
      @pacote.implantacao_promocional = parse_valor_rails pacote_params[:implantacao_promocional]
      @pacote.implantacao_remota = parse_valor_rails pacote_params[:implantacao_remota]
      @pacote.implantacao_remota_promocional = parse_valor_rails pacote_params[:implantacao_remota_promocional]

      if @pacote.save
        flash[:success] = 'Pacote alterado com sucesso'
        format.html { redirect_to pacotes_path }
      else
        flash[:error] =  @pacote.errors.full_messages.to_sentence
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @pacote.destroy
    respond_to do |format|
      format.html { redirect_to pacotes_url }
    end
  end

  def find_pacotes
    @pacotes = Pacote.where("upper(nome) LIKE upper('%#{params[:term]}%') and empresa_id = #{ current_empresa.id } ").order(:nome).limit(5)
    respond_to do |format|
      format.html {render nothing: true}
      format.json
    end
  end

  private

    def set_pacote
      @pacote = Pacote.find(params[:id])
    end

    def pacote_params
      params.require(:pacote).permit(:sistema_id, :mensalidade, :mensalidade_promocional, :implantacao, :implantacao_promocional, :implantacao_remota, :implantacao_remota_promocional)
    end

  def parse_valor_rails(value)
    value.gsub('R$', '').gsub('.', '').gsub(',', '.').to_d
  end
end
