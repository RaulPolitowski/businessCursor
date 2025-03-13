class PropostasController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    if params[:id].present?
      @proposta = Proposta.find params[:id]
    else
      @proposta = Proposta.new(proposta_params)
      @proposta.empresa = @proposta.cliente.empresa
      @proposta.user = current_user
      @proposta.data = Time.now
      @proposta.ativa = true
    end

    @proposta.attributes = proposta_params

    if @proposta.save
      if @proposta.ativa
        Proposta.where('ativa is true and cliente_id = ? and id != ?',@proposta.cliente_id, @proposta.id).update_all(ativa: false)
        @proposta.cliente.fechamento.update(proposta_id: @proposta.id) if @proposta.cliente.fechamento.present?
        @proposta.cliente.implantacao.update(proposta_id: @proposta.id) if @proposta.cliente.implantacao.present?
        @proposta.cliente.acompanhamento.update(proposta_id: @proposta.id) if @proposta.cliente.acompanhamento.present?
      end

      render json: @proposta
    else
      render json: @proposta.errors.full_messages.to_sentence
    end
end

def show
  @proposta = Proposta.find params[:id]

  render json: @proposta
end

def find_propostas
  @propostas = Proposta.where(cliente_id: params[:cliente_id]).order(data: :desc)

  render json: @propostas
end

private

def proposta_params
  params.require(:proposta).permit(:cliente_id, :pacote_id, :tipo_mensalidade, :valor_mensalidade, :tipo_implantacao, :valor_implantacao, :formas_pagamento_id,
    :qtde_parcela, :valor_parcelas, :observacao, :ativa, :qtd_maquinas, :data_primeira_mensalidade, :fidelidade, :meses_fidelidade)
end
end
