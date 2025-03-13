class ServicosController < ApplicationController
  before_action :set_servico, only: [:show, :edit, :update, :destroy, :desativar]

  # GET /servicos
  # GET /servicos.json
  def index
    @servicos = Servico.where(ativo: true)
    @servicos_inativas = Servico.where(ativo: false)
  end

  # GET /servicos/1
  # GET /servicos/1.json
  def show
    respond_to do |format|
      format.html {render nothing: true}
      format.json {render json: @servicos}
    end
  end

  # GET /servicos/new
  def new
    @servico = Servico.new
  end

  # GET /servicos/1/edit
  def edit
  end

  # POST /servicos
  # POST /servicos.json
  def create
    @servico = Servico.new(servico_params)
    @servico.ativo = true
    respond_to do |format|
      if @servico.save
        flash[:success] = 'Servico criado com sucesso'
        format.html { redirect_to servicos_path }
      else
        flash[:error] =  @servico.errors.full_messages.to_sentence
        format.html { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /servicos/1
  # PATCH/PUT /servicos/1.json
  def update
    respond_to do |format|
      if @servico.update(servico_params)
        flash[:success] = 'Servico alterado com sucesso'
        format.html { redirect_to servicos_path }
      else
        flash[:error] =  @servicos.errors.full_messages.to_sentence
        format.html { render action: 'edit' }
      end
    end
  end

  def desativar
    @servico.ativo = !@servico.ativo
    @servico.save

    redirect_to :back
  end

  # DELETE /servicos/1
  # DELETE /servicos/1.json
  def destroy
    @servico.destroy
    respond_to do |format|
      format.html { redirect_to servicos_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_servico
      @servico = Servico.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def servico_params
      params.require(:servico).permit(:nome_servico, :ordem, :tipocobranca_id)
    end
end
