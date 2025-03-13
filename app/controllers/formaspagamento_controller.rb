class FormaspagamentoController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_filter :authorize_admin, only: [:create, :new, :edit, :update, :index]
  before_action :set_formapagamento, only: [:edit, :update, :destroy, :show]

  def index
    @formapagamentos = Formapagamento.where(empresa: current_empresa)
  end

  def new
    @formapagamento = Formapagamento.new
  end

  def edit
  end

  def show
    respond_to do |format|
      format.html {render nothing: true}
      format.json {render json: @formapagamento}
    end
  end

  def create
    @formapagamento = Formapagamento.new(formapagamento_params)
    @formapagamento.empresa = current_empresa
    respond_to do |format|
      if @formapagamento.save
        flash[:success] = 'Forma de Pagamento criado com sucesso'
        format.html { redirect_to formaspagamento_index_path }
      else
        flash[:error] =  @formapagamento.errors.full_messages.to_sentence
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @formapagamento.update(formapagamento_params)
        flash[:success] = 'Forma de Pagamento alterado com sucesso'
        format.html { redirect_to formaspagamento_index_path }
      else
        flash[:error] =  @sistema.errors.full_messages.to_sentence
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @formapagamento.destroy
    respond_to do |format|
      format.html { redirect_to formaspagamento_url }
      format.json { head :no_content }
    end
  end

  private
    def set_formapagamento
      @formapagamento = Formapagamento.find(params[:id])
    end

    def formapagamento_params
      params.require(:formapagamento).permit(:descricao, :parcelado)
    end
end
