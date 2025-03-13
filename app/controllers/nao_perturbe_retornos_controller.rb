class NaoPerturbeRetornosController < ApplicationController
  before_action :set_nao_perturbe_retorno, only: [:show, :edit, :update, :destroy]

  # GET /nao_perturbe_retornos
  # GET /nao_perturbe_retornos.json
  def index
    @nao_perturbe_retornos = NaoPerturbeRetorno.all
  end

  # GET /nao_perturbe_retornos/1
  # GET /nao_perturbe_retornos/1.json
  def show
  end

  # GET /nao_perturbe_retornos/new
  def new
    @nao_perturbe_retorno = NaoPerturbeRetorno.new
  end

  # GET /nao_perturbe_retornos/1/edit
  def edit
  end

  # POST /nao_perturbe_retornos
  # POST /nao_perturbe_retornos.json
  def create
    @nao_perturbe_retorno = NaoPerturbeRetorno.new(nao_perturbe_retorno_params)

    respond_to do |format|
      if @nao_perturbe_retorno.save
        format.html { redirect_to @nao_perturbe_retorno, notice: 'Nao perturbe retorno was successfully created.' }
        format.json { render action: 'show', status: :created, location: @nao_perturbe_retorno }
      else
        format.html { render action: 'new' }
        format.json { render json: @nao_perturbe_retorno.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /nao_perturbe_retornos/1
  # PATCH/PUT /nao_perturbe_retornos/1.json
  def update
    respond_to do |format|
      if @nao_perturbe_retorno.update(nao_perturbe_retorno_params)
        format.html { redirect_to @nao_perturbe_retorno, notice: 'Nao perturbe retorno was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @nao_perturbe_retorno.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /nao_perturbe_retornos/1
  # DELETE /nao_perturbe_retornos/1.json
  def destroy
    @nao_perturbe_retorno.destroy
    respond_to do |format|
      format.html { redirect_to nao_perturbe_retornos_url }
      format.json { head :no_content }
    end
  end

  def fim_nao_perturbe
    fim = NaoPerturbeRetorno.where(user_id: current_user.id).last

    if current_user.ocupado == true && fim.data_fim <= Time.now
      current_user.update(ocupado: false)
      return render json: 1
    end
    return render json: 0
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_nao_perturbe_retorno
      @nao_perturbe_retorno = NaoPerturbeRetorno.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def nao_perturbe_retorno_params
      params.require(:nao_perturbe_retorno).permit(:user_id, :data_fim)
    end
end
