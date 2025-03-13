class AbordagemIniciaisController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :new_instance, only: [:new, :render_form]
  before_action :set_abordagem_inicial, only: [:show, :update, :update, :deletar_abordagem, :desativar_abordagem, :ativar_abordagem, :render_form]
  before_action :total_by_tipo, only: [:render_form, :show, :new]
  # GET /abordagem_iniciais
  # GET /abordagem_iniciais.json
  def index
    @abordagem_ativa_captacao = AbordagemInicial.where(ativa: true, tipo: 'CAPTACAO').order(fila: :asc)
    @abordagem_ativa_resposta = AbordagemInicial.where(ativa: true, tipo: 'RESPOSTA').order(fila: :asc)
    @abordagem_ativa = AbordagemInicial.where(ativa: true).order(tipo: :asc, fila: :asc)
    @abordagem_iniciais = AbordagemInicial.where(ativa: false)
  end

  def show
    render partial: 'abordagem_iniciais/modal_abordagem', locals: {
      abordagem: @abordagem_inicial,
      total_abordagem_tipo: @total_abordagem_tipo
    }
  end

  def new
    @abordagem_inicial.tipo = params[:tipo] || 'CAPTACAO'

    render partial: 'abordagem_iniciais/modal_abordagem', locals: {
      abordagem: @abordagem_inicial,
      total_abordagem_tipo: @total_abordagem_tipo
    }
  end

  def edit
  end

  def render_form
    @abordagem_inicial ||= new_instance
    @abordagem_inicial.tipo = params[:tipo]

    render partial: 'abordagem_iniciais/form', locals: {
      abordagem: @abordagem_inicial,
      total_abordagem_tipo: @total_abordagem_tipo
    }
  end

  def create
    ActiveRecord::Base.transaction do
      respond_to do |format|
        begin
          attr = {
            texto: abordagem_inicial_params[:texto],
            tipo: abordagem_inicial_params[:tipo],
            ativa: true,
            fila: abordagem_inicial_params[:fila],
            intervalo_resposta_automatica: abordagem_inicial_params[:tipo] == 'RESPOSTA' ? abordagem_inicial_params[:intervalo_resposta_automatica] : nil,
            palavra_chave_validacao: abordagem_inicial_params[:palavra_chave_validacao]
          }

          @abordagem_inicial = AbordagemInicial.create!(attr)
          ajustar_filas_superiores

          flash[:success] = 'Abordagem criada com sucesso!'
          format.html { redirect_to abordagem_iniciais_path }
          format.json { render json: @abordagem_inicial, status: 200}
        rescue => exception
          flash[:error] = @abordagem_inicial.errors.full_messages.to_sentence
          raise ActiveRecord::Rollback
        end
      end
    end
  end

  def update
    return redirect_to abordagem_iniciais_path, alert: 'Não foi encontrada nenhuma abordagem' unless @abordagem_inicial.present?

    ActiveRecord::Base.transaction do
      respond_to do |format|
        begin
          ajustar_filas_superiores
          @abordagem_inicial.update!(abordagem_inicial_params)

          flash[:success] = 'Abordagem alterada com sucesso!'
          format.html { redirect_to abordagem_iniciais_path }
        rescue => exception
          flash[:error] = @abordagem_inicial.errors.full_messages.to_sentence
          raise ActiveRecord::Rollback
        end
      end
    end
  end

  def ativar_abordagem
    if @abordagem_inicial.tipo == 'CAPTACAO' || @abordagem_inicial.tipo == 'RESPOSTA'
      ultima_fila = AbordagemInicial.where(ativa: true, tipo: @abordagem_inicial.tipo).where.not(fila: nil).order(fila: :asc).last
      @abordagem_inicial.update!(ativa: true, fila: (ultima_fila.fila + 1))
    else
      @abordagem_inicial.update!(ativa: true, fila: nil)
    end
    render json: @abordagem_inicial, status: 200 if @abordagem_inicial.present?
    render json: 'Não foi possível localizar!', status: 422 unless @abordagem_inicial.present?
  end

  def desativar_abordagem
    if @abordagem_inicial.tipo == 'CAPTACAO' || @abordagem_inicial.tipo == 'RESPOSTA'
      filas_acima = AbordagemInicial.where('tipo = ? and id <> ? and fila > ?', @abordagem_inicial.tipo, @abordagem_inicial.id, @abordagem_inicial.fila)
      filas_acima.update_all("fila = fila - 1") unless filas_acima.empty?
    end
    @abordagem_inicial.update!(ativa: false, fila: nil)
    render json: @abordagem_inicial, status: 200 if @abordagem_inicial.present?
  end

  def deletar_abordagem
    tipo = @abordagem_inicial.tipo
    @abordagem_inicial.destroy

    if tipo.present?
      aux = AbordagemInicial.where(tipo: params[:tipo]).order(id: :desc).first
      aux.update(ativa: false) if aux.present?
    end

    render json: @abordagem_inicial, status: 200
  end

  def get_abordagem_tipo
    return head 404 if params[:tipo].nil?
    abordagem_ativa = AbordagemInicial.where(ativa: true, tipo: params[:tipo]).first

    render json: abordagem_ativa, status: 200
  end

  private

  def set_abordagem_inicial
    @abordagem_inicial = AbordagemInicial.find(params[:id]) if params[:id].present?
  end

  def abordagem_inicial_params
    params.require(:abordagem_inicial).permit(:texto, :ativa, :fila, :tipo, :intervalo_resposta_automatica, :palavra_chave_validacao)
  end

  def total_by_tipo
    tipo = params[:tipo] || @abordagem_inicial[:tipo] || 'CAPTACAO'
    @total_abordagem_tipo = AbordagemInicial.get_abordagens_tipo(tipo)
  end

  def ajustar_filas_superiores
    filas_acima = AbordagemInicial.where(
      'tipo = ? and id <> ? and fila >= ?',
      abordagem_inicial_params[:tipo], @abordagem_inicial.id, abordagem_inicial_params[:fila]
    )

    return unless filas_acima.length > 0

    filas_acima.update_all('fila = fila + 1')
  end

  def new_instance
    @abordagem_inicial = AbordagemInicial.new
  end
end
