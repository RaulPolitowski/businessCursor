class ComentariosController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    @comentario = Comentario.new(comentario_params)
    @comentario.user = current_user
    respond_to do |format|
      if @comentario.save
        @comentario.create_activity(:comentario, owner: current_user, recipient: @comentario.agendamento) if @comentario.agendamento.present?
        #@comentario.create_activity(:comentario, owner: current_user, recipient: @comentario.negociacao) if @comentario.negociacao.present?
        
        if params[:is_acordo].present?
          @comentario.update(isAcordo: true) if params[:is_acordo].eql? 'true'
          @comentario.update(isAcordo: false) if params[:is_acordo].eql? 'false'
        end
        
        if @comentario.acompanhamento.present?
          @comentario.create_activity(:comentario, owner: current_user, recipient: @comentario.acompanhamento, params: { data_retorno: params[:data_retorno]})
          AgendamentoRetorno.criarRetornoAcompanhamento params[:data_retorno], @comentario.acompanhamento, (params[:usuario_id].present? && params[:usuario_id] != 'undefined' ? params[:usuario_id] : current_user.id)
        end

        if @comentario.implantacao.present?
          @comentario.create_activity(:comentario, owner: current_user, recipient: @comentario.implantacao, params: { data_retorno: params[:data_retorno]})
          AgendamentoRetorno.criarRetornoImplantacao params[:data_retorno], @comentario.implantacao, (params[:usuario_id].present? && params[:usuario_id] != 'undefined' ? params[:usuario_id] : current_user.id)
        end

        if (params['comentario']['implantacao_id'].eql? '') && (params['comentario']['negociacao_id'].present? )
          negociacao = @comentario.negociacao
          @comentario.create_activity(:comentario, owner: current_user, recipient: negociacao, params: { data_retorno: params[:data_retorno]})
          AgendamentoRetorno.create(empresa: negociacao.empresa, user_id: params[:usuario_id].present? && params[:usuario_id] != 'undefined' ? params[:usuario_id].to_i : current_user.id, data_agendamento_retorno: params[:data_retorno], cliente: negociacao.cliente, cancelado: false)
        end
        
        if @comentario.solicitacao_desistencia_id.present?
          valor_param = true if params[:is_acordo].eql? 'true'
          valor_param = false if params[:is_acordo].eql? 'false'
          @comentario.create_activity(:comentario, owner: current_user, recipient: @comentario.solicitacao_desistencia, params: { data_retorno: params[:data_retorno], acordo: valor_param }) if params[:data_retorno].present?
          @comentario.create_activity(:comentario, owner: current_user, recipient: @comentario.solicitacao_desistencia, params: { acordo: valor_param }) unless params[:data_retorno].present?
          AgendamentoRetorno.criarRetornoSolicitacaoDesistencia params[:data_retorno], @comentario.solicitacao_desistencia, (params[:usuario_id].present? && params[:usuario_id] != 'undefined' ? params[:usuario_id] : current_user.id) if params[:data_retorno].present?
        end
        current_user.update(em_atendimento: false)

        format.json { render json: @comentario, status: 200 }
      else
        format.json { render json: { errors: @comentario.errors }, status: 422 }
      end
    end
  end

  def historico
    @comentario = Comentario.new(comentario_params)
    @comentario.user = current_user

    if @comentario.save
      @comentario.create_activity(:comentario, owner: current_user, recipient: @comentario.cliente) if @comentario.cliente.present?
      render json: @comentario, status: 200
    else
      render json: {errors: @comentario.errors}, status:422
    end
  end

  def destroy
    @comentario = Comentario.find params[:id]
    @comentario.activities.destroy_all
    @comentario.destroy

    head 200
  end

  private
  def set_comentario
    @comentario = Comentario.find(params[:id])
  end

  def comentario_params
    params.require(:comentario).permit(:comentario, :implantacao_id, :acompanhamento_id, :negociacao_id, :agendamento_id, :cliente_id, :solicitacao_desistencia_id)
  end

end
