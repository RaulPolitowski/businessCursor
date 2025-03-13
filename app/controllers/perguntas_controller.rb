class PerguntasController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_filter :authorize_admin, only: [:create, :new, :edit, :update, :index]
  before_action :set_pergunta, only: [:show, :edit, :update, :destroy, :desativar]

  def index
    @perguntas = Pergunta.where(ativo: true)
    @perguntas_inativas = Pergunta.where(ativo: false)
  end

  def new
    @pergunta = Pergunta.new
  end

  def edit
  end

  def create
    @pergunta = Pergunta.new(pergunta_params)

    respond_to do |format|
      if @pergunta.save
        flash[:success] = 'Pergunta criada com sucesso'
        format.html { redirect_to perguntas_path }
      else
        flash[:error] =  @pergunta.errors.full_messages.to_sentence
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @pergunta.update(pergunta_params)
        flash[:success] = 'Pergunta alterada com sucesso'
        format.html { redirect_to perguntas_path }
      else
        flash[:error] =  @pergunta.errors.full_messages.to_sentence
        format.html { render action: 'new' }
      end
    end
  end

  def destroy
    @pergunta.destroy
    respond_to do |format|
      format.html { redirect_to perguntas_url }
    end
  end

  def perguntas_fechamento
    perguntas = Pergunta.where(fechamento: true, ativo:true)

    render json: perguntas
  end

  def perguntas_fechamento_condicional
    pergunta = Pergunta.where(pergunta_gatilho_id: params[:pergunta_id], fechamento: true, ativo:true)

    render json: pergunta
  end

  def perguntas_implantacao
    perguntas = Pergunta.where(implantacao: true, ativo: true)

    render json: perguntas
  end

  def perguntas_implantacao_condicional
    pergunta = Pergunta.where(pergunta_gatilho_id: params[:pergunta_id], implantacao: true, ativo: true)

    render json: pergunta
  end

  def perguntas_acompanhamento
    perguntas = Pergunta.where(acompanhamento: true)

    render json: perguntas
  end

  def perguntas_acompanhamento_condicional
    pergunta = Pergunta.where(pergunta_gatilho_id: params[:pergunta_id], acompanhamento: true, ativo:true)

    render json: pergunta
  end

  def perguntas_pesquisa
    perguntas = Pergunta.where(pesquisa: true, ativo:true)

    render json: perguntas
  end

  def registrar_respostas_cliente
    cliente = Cliente.find params[:cliente_id]
    params[:perguntas].each do |pergunta|
      id = pergunta[0].gsub 'pergunta_', ''
      perg = Pergunta.find id
      if perg.tipo.eql? 'NORMAL'
        resp = PerguntaClienteResposta.where(cliente: cliente, pergunta: perg, tipo: params[:tipo].to_i).first
        if resp.nil?
          PerguntaClienteResposta.create(cliente: cliente, pergunta: perg, resposta: pergunta[1], tipo: params[:tipo].to_i)
        else
          resp.update(resposta: pergunta[1])
        end
      elsif perg.tipo.eql? 'TAGS'
        tags = JSON.parse pergunta[1].gsub('=>', ':')
        resposta = ''
        tags.each do |tag| resposta = resposta + ' ' + tag['value'].upcase end

        resp = PerguntaClienteResposta.where(cliente: cliente, pergunta: perg, tipo: params[:tipo].to_i).first
        if resp.nil?
          resp = PerguntaClienteResposta.create(cliente: cliente, pergunta: perg, resposta: resposta, tipo: params[:tipo].to_i)
        else
          resp.update(resposta: resposta)
          resp.pergunta_cliente_resposta_tags.destroy_all
        end

        tags.each do |tag|
          PerguntaClienteRespostaTag.create(pergunta_cliente_resposta: resp, tag: tag['value'].upcase)
        end
      elsif perg.tipo.eql? 'NOTA'

        resp = PerguntaPesquisaResposta.where(pesquisa: pesquisa, pergunta: perg).first
        if resp.nil?
          PerguntaPesquisaResposta.create(pesquisa: pesquisa, pergunta: perg, resposta: pergunta[1])
        else
          resp.update(resposta: pergunta[1])
        end
      else
        resp = PerguntaClienteResposta.where(cliente: cliente, pergunta: perg, tipo: params[:tipo].to_i).first
        if resp.nil?
          PerguntaClienteResposta.create(cliente: cliente, pergunta: perg, resposta: ApplicationHelper.human_boolean_con(ApplicationHelper.true? pergunta[1]), tipo: params[:tipo].to_i)
        else
          resp.update(resposta: ApplicationHelper.human_boolean_con(pergunta[1]))
        end
      end

    end
    render json: nil, status: 200
  end

  def registrar_respostas_pesquisa
    pesquisa = Pesquisa.find params[:pesquisa_id]

    params[:perguntas].each do |pergunta|
      id = pergunta[0].gsub 'pergunta_', ''
      perg = Pergunta.find id
      if perg.tipo.eql? 'NORMAL'
        resp = PerguntaPesquisaResposta.where(pesquisa: pesquisa, pergunta: perg).first
        if resp.nil?
          PerguntaPesquisaResposta.create(pesquisa: pesquisa, pergunta: perg, resposta: pergunta[1])
        else
          resp.update(resposta: pergunta[1])
        end
      elsif perg.tipo.eql? 'TAGS'
        tags = JSON.parse pergunta[1].gsub('=>', ':')
        resposta = ''
        tags.each do |tag| resposta = resposta + ' ' + tag['value'].upcase end

        resp = PerguntaPesquisaResposta.where(pesquisa: pesquisa, pergunta: perg).first
        if resp.nil?
          PerguntaPesquisaResposta.create(pesquisa: pesquisa, pergunta: perg, resposta: resposta)
        else
          resp.update(resposta: resposta)
        end
      elsif perg.tipo.eql? 'NOTA'

        resp = PerguntaPesquisaResposta.where(pesquisa: pesquisa, pergunta: perg).first
        if resp.nil?
          PerguntaPesquisaResposta.create(pesquisa: pesquisa, pergunta: perg, resposta: pergunta[1])
        else
          resp.update(resposta: pergunta[1])
        end
      else
        resp = PerguntaPesquisaResposta.where(pesquisa: pesquisa, pergunta: perg, tipo: params[:tipo].to_i).first
        if resp.nil?
          PerguntaPesquisaResposta.create(pesquisa: pesquisa, pergunta: perg, resposta: ApplicationHelper.human_boolean_con(ApplicationHelper.true? pergunta[1]))
        else
          resp.update(resposta: ApplicationHelper.human_boolean_con(pergunta[1]))
        end
      end
    end

    pesquisa.update(user: current_user, data_pesquisa: Time.now)

    pesquisa.cliente.registrar_proxima_pesquisa pesquisa.data_pesquisa

    render json: nil, status: 200
  end

  def get_tags
    tags = PerguntaClienteRespostaTag.all.distinct.pluck(:tag)

    render json: tags, status: 200
  end

  def desativar
    @pergunta.ativo = !@pergunta.ativo
    @pergunta.save

    redirect_to :back
  end

  private
    def set_pergunta
      @pergunta = Pergunta.find(params[:id])
    end

    def pergunta_params
      params.require(:pergunta).permit(:pergunta, :fechamento, :implantacao, :acompanhamento, :tipo, :pergunta_gatilho_id, :pesquisa)
    end
end
