class ParametrosController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_filter :authorize_admin, only: [:update, :editar_parametros]
  before_action :set_parametro, only: [:update, :editar_parametros]

  def editar_parametros
  end

  def update
    respond_to do |format|
      if @parametro.update(parametro_params)
        @parametro.update(senha_master: params[:parametro][:senha_master]) if params[:parametro][:senha_master].present?
        flash[:success] = 'Parâmetros alterados com sucesso'
        format.html { redirect_to root_path }
      else
        flash[:error] =  @parametro.errors.full_messages.to_sentence
        format.html { render action: 'editar_parametros' }
      end
    end
  end

  def senha_master_valida
    valida = (parametros_vigente.senha_master == params[:senha_master])
    render json: valida.to_json
  end

  private
    def set_parametro
      @parametro = parametros_vigente
    end

    def parametro_params
      params.require(:parametro).permit(:msg_whats, :tempo_inerte)
    end
end
