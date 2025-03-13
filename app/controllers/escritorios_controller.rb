class EscritoriosController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_escritorio, only: [:edit, :update, :destroy, :show]

  def index
    @q = Escritorio.search params[:q]

    @q.empresa_id_eq = current_empresa.id

    if not params[:q]
      @q.created_at_gteq ||= Date.today.beginning_of_week().strftime("%d/%m/%Y")
      @q.created_at_lteq ||= Date.today.end_of_week().strftime("%d/%m/%Y")
    end

    session[:index_way] = request.env['REQUEST_URI']

    @escritorios = @q.result(distinct: true)
  end

  def todos
    @q = Escritorio.search params[:q]

    if not params[:q]
      @q.created_at_gteq ||= Date.today.beginning_of_week().strftime("%d/%m/%Y")
      @q.created_at_lteq ||= Date.today.end_of_week().strftime("%d/%m/%Y")
    end

    session[:index_way] = request.env['REQUEST_URI']

    @escritorios = @q.result(distinct: true)
  end

  def show
    render json: @escritorio
  end


  def new
    @escritorio = Escritorio.new
    @escritorio.possui_parceria = false
  end

  def edit
  end

  def create
    @escritorio = Escritorio.new(escritorio_params)
    @escritorio.empresa = current_empresa
    @escritorio.user = current_user
    respond_to do |format|
      if @escritorio.save
        flash[:success] = 'Escritório criado com sucesso'
        format.html { redirect_to escritorios_path }
      else
        flash[:error] =  @escritorio.errors.full_messages.to_sentence
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @escritorio.update(escritorio_params)
        flash[:success] = 'Escritório alterado com sucesso'
        format.html { redirect_to (session[:index_way].present? ? session[:index_way] : escritorios_path) }

      else
        flash[:error] =  @escritorio.errors.full_messages.to_sentence
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @escritorio.destroy
    respond_to do |format|
      format.html { redirect_to escritorios_url }
    end
  end

  def add_cliente
    @escritorio = Escritorio.find params[:escritorio_id]

    cliente = Cliente.find params[:cliente_id]

    if cliente.escritorio_id.eql? @escritorio.id
        render json: 'JA_EXISTE'.to_json
    else
      @escritorio.clientes << cliente

      @escritorio.save

      render json: cliente
    end
  end
  
  def remove_cliente
    cliente = Cliente.find params[:cliente_id]

    cliente.escritorio = nil

    cliente.save

    render json: cliente
  end

  def add_novo_telefone
    escritorio = Escritorio.find params[:escritorio_id]
    contato = escritorio.contatos.where(telefone: params[:telefone]).first
    if contato.present?
      contato = params[:telefone]
      contato.save
    else
      contato = Contato.create(escritorio: escritorio, telefone: params[:telefone], nome: 'Telefone adicional')
    end

    render json: contato
  end

  def find_escritorios
    @escritorios = Escritorio.where("upper(razao_social) LIKE upper('%#{params[:term]}%') or  upper(nome_fantasia) LIKE upper('%#{params[:term]}%')  and empresa_id = #{ current_empresa.id } ").order(:razao_social).limit(5)
    render json: @escritorios
  end

  def salvar_atualizar_cadastro
    if params[:id].present?
      @escritorio = Escritorio.find params[:id]
    else
      @escritorio = Escritorio.new
      @escritorio.user = current_user
    end

    @escritorio.update(escritorio_params)

    if params[:cliente_id].present?
      cliente = Cliente.find params[:cliente_id]
      if cliente.present? && !(@escritorio.clientes.include? cliente)
        @escritorio.clientes << cliente
      end
    end

    @escritorio.save

    render json: @escritorio
  end

  private
    def set_escritorio
      @escritorio = Escritorio.find(params[:id])
    end

    def escritorio_params
      params[:escritorio].permit(:razao_social, :nome_fantasia, :telefone, :responsavel,
                                 :possui_parceria, :empresa_parceira, :observacao,
                                 :tem_interesse_parceria, :motivo_sem_interesse, :parceria_obs,
                                 :cidade_id, :status_id, :passa_contato,
                                 contatos_attributes: [:id, :nome, :telefone, :email, :funcao, :_destroy])
    end
end
