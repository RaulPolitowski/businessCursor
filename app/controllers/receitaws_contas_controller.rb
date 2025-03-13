class ReceitawsContasController < ApplicationController
  before_action :set_receitaws_conta, only: [:show, :edit, :update, :destroy]

  def index
    @receitaws_contas = ReceitawsConta.all
  end

  def show
  end

  def new
    @receitaws_conta = ReceitawsConta.new
  end

  def edit
  end

  def create
    @receitaws_conta = ReceitawsConta.new(receitaws_conta_params)
    @receitaws_conta.qtd_usada = 0
    respond_to do |format|
      if @receitaws_conta.save
        format.html { redirect_to receitaws_contas_path, notice: 'Conta criada com sucesso.' }
        format.json { render action: 'show', status: :created, location: @receitaws_conta }
      else
        flash[:error] =  @receitaws_conta.errors.full_messages.to_sentence
        format.html { render action: 'new' }
        format.json { render json: @receitaws_conta.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @receitaws_conta.update(receitaws_conta_params)
        format.html { redirect_to receitaws_contas_path, notice: 'Conta alterada com sucesso.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit', :flash => { :error => @cliente.errors.full_messages.to_sentence } }
        format.json { render json: @receitaws_conta.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @receitaws_conta.destroy
    respond_to do |format|
      format.html { redirect_to receitaws_contas_url }
      format.json { head :no_content }
    end
  end

  private

    def set_receitaws_conta
      @receitaws_conta = ReceitawsConta.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def receitaws_conta_params
      params.require(:receitaws_conta).permit(:nome, :chave, :qtd_disponivel, :dia_renovacao)
    end
end
