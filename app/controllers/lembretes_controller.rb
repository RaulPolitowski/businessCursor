class LembretesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_lembrete, only: [:finalizar]

  def index
    @q = Lembrete.search params[:q]

    @q.empresa_id_eq = current_empresa.id
    @q.finalizado_eq ||= false

    @lembretes = @q.result(distinct: true).where(' (user_lembrete_id = ? or privado is false) ', current_user.id).order(:data)
  end

  def get_lembretes
    @lembretes = Lembrete.where(user_lembrete: current_user, empresa: current_empresa, finalizado: false).order(:data)

    render json: @lembretes
  end

  def salvar
    if params[:id].present?
      @lembrete = Lembrete.find params[:id]
    else
      @lembrete = Lembrete.new()
      @lembrete.user_registro =  current_user
      @lembrete.empresa = current_empresa
    end

    dataAntiga = @lembrete.data
    @lembrete.data = Time.parse(params[:data])
    @lembrete.user_lembrete_id = params[:user_lembrete_id]
    @lembrete.observacao = params[:observacao]
    @lembrete.privado = params[:privado]

    @lembrete.save

    flash[:success] = 'Lembrete registrado.'

    render json: @lembrete
  end

  def finalizar
    @lembrete.finalizado = !@lembrete.finalizado
    @lembrete.save

    redirect_to lembretes_path
  end

  def find_lembrete
    @lembrete = Lembrete.find params[:id]

    render json: @lembrete
  end

  private

  def set_lembrete
    @lembrete = Lembrete.find(params[:id])
  end

end
