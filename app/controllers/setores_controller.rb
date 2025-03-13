class SetoresController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_filter :authorize_admin, only: [:create, :new, :edit, :update, :index]
  before_action :set_setor, only: [:show, :edit, :update, :destroy, :desativar]

  # GET /setores
  # GET /setores.json
  def index
    @setores = Setor.where(ativo: true)
    @setores_inativas = Setor.where(ativo: false)
  end

  # GET /setores/1
  # GET /setores/1.json
  def show
    respond_to do |format|
      format.html {render nothing: true}
      format.json {render json: @setores}
    end
  end

  # GET /setores/new
  def new
    @setor = Setor.new
  end

  # GET /setores/1/edit
  def edit
  end

  # POST /setores
  # POST /setores.json
  def create
    @setor = Setor.new(setor_params)
    @setor.ativo = true
    respond_to do |format|
      if @setor.save
        flash[:success] = 'Setor criado com sucesso'
        format.html { redirect_to setores_path }
      else
        flash[:error] =  @setores.errors.full_messages.to_sentence
        format.html { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /setores/1
  # PATCH/PUT /setores/1.json
  def update
    respond_to do |format|
      if @setor.update(setor_params)
        flash[:success] = 'Setor alterado com sucesso'
        format.html { redirect_to setores_path }
      else
        flash[:error] =  @setores.errors.full_messages.to_sentence
        format.html { render action: 'edit' }
      end
    end
  end


  def desativar
    @setor.ativo = !@setor.ativo
    @setor.save

    redirect_to :back
  end

  # DELETE /setores/1
  # DELETE /setores/1.json
  def destroy
    @setor.destroy
    respond_to do |format|
      format.html { redirect_to setores_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_setor
      @setor = Setor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def setor_params
      params.require(:setor).permit(:nome_setor, :ordem, :setor_financeiro_id, :tipo_setor)
    end
end
