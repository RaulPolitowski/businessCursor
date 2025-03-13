class ClientesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_cliente, only: [:show, :edit, :update, :destroy, :desativar, :show, :cancelar_atendimento, :get_fechamento_cliente, :novo_contato]
  skip_before_action :authenticate_user!, only: [:find_cliente_cnpj]

  def index
    @q = Cliente.search params[:q]

    @q.empresa_id_eq = current_empresa.id

    @cidade = Cidade.find_by(id: params[:q]["cidade_id_eq"]) unless params[:q].nil?

    @clientes = @q.result(distinct: true).includes(:contatos, :cidade, :cnae).order(razao_social: :asc).limit(500)
  
  end

  def new
    @cliente = Cliente.new
  end

  def show
    render json: @cliente
  end

  def edit
  end

  def create
    @cliente = Cliente.new(cliente_params)
    @cliente.empresa = current_empresa
    @cliente.cpf = params['cliente']['cpf'].gsub(/[^0-9]/, '') if !params['cliente']['cpf'].nil?

    respond_to do |format|
      if @cliente.save

        verificar_contatos params[:contato_id], params[:contato], @cliente
        verificar_contatos params[:contato1_id], params[:contato1], @cliente

        format.html { redirect_to clientes_path, notice: 'Cliente criado com sucesso.' }
        format.json { render json: @cliente, status: 200 }
      else
        flash[:error] = @cliente.errors.full_messages.to_sentence 
        format.html { render action: 'new' }
        format.json { render json: { errors: @cliente.errors }, status: 422 }
      end
    end
  end

  def update
    update_data = cliente_params
    update_data['cpf'] = params['cliente']['cpf'].gsub(/[^0-9]/, '') if !params['cliente']['cpf'].nil?
    respond_to do |format|
      if @cliente.update(update_data)

        verificar_contatos params[:contato_id], params[:contato], @cliente
        verificar_contatos params[:contato1_id], params[:contato1], @cliente

        #Caso passado parametro em_tendimento, seta o usuario que está fazendo isso
        @cliente.update(user_atendimento: current_user) if cliente_params[:em_atendimento].present?

        format.html { redirect_to clientes_path, notice: 'Cliente alterado com sucesso.' }
        format.json { render json: @cliente, status: 200 }
      else
        format.html { render action: 'edit', :flash => { :error => @cliente.errors.full_messages.to_sentence } }
        format.json { render json: { errors: @cliente.errors }, status: 422 }
      end
    end
  end

  def destroy
    @cliente.destroy
    respond_to do |format|
      format.html { redirect_to clientes_url }
    end
  end

  def desativar
    @cliente.ativo = !@cliente.ativo
    @cliente.save


    redirect_to :back, notice: 'Empresa desativada com sucesso!' if !@cliente.ativo
    redirect_to :back, notice: 'Empresa ativada com sucesso!' if @cliente.ativo
  end

  def find_cidades
    @cidades = Cidade.select("cidades.*, estados.sigla").joins(:estado).where("upper(unaccent(cidades.nome)) LIKE upper((?)) OR cidades.id::varchar = ?", "%#{params[:term]}%", params[:term]).order(:nome).limit(5)
    respond_to do |format|
      format.html {render nothing: true}
      format.json {render json: @cidades}
    end
  end

  def find_cliente_id
    @cliente = Cliente.find params[:id]
    render json: @cliente, each_serializer: ClienteShortSerializer
  end

  def find_cliente
    @clientes = Cliente.where("(upper(unaccent(razao_social)) LIKE upper((?)) OR (upper(unaccent(cnpj)) LIKE  upper((?)))) and empresa_id = ?", "%#{params[:term]}%","%#{params[:term]}%", current_empresa.id).where(ativo: true).order(:razao_social).limit(5)
    render json: @clientes, each_serializer: ClienteShortSerializer
  end

  def find_cliente_all_empresa
    @clientes = Cliente.where("(upper(unaccent(razao_social)) LIKE upper((?)) OR (upper(unaccent(cnpj)) LIKE  upper((?))))", "%#{params[:term]}%","%#{params[:term]}%").where(ativo: true).order(:razao_social).limit(5)
    render json: @clientes, each_serializer: ClienteShortSerializer
  end

  def find_cliente_cnpj
    cliente = Cliente.find_by_cnpj params[:cnpj]
    render json: cliente
  end

  def find_cliente_financeiro
    @clientes = Financeiro::ClienteFornecedor.where("(upper(unaccent(razaosocial)) LIKE upper((?)) OR (upper(unaccent(cpfcnpj)) LIKE  upper((?))))", "%#{params[:term]}%","%#{params[:term]}%").order(:razaosocial).limit(5)
    render json: @clientes, each_serializer: Financeiro::ClienteFinanceiroShortSerializer
  end

  def find_cliente_params
    @clientes = Cliente.where(ativo: true, empresa: current_empresa)
    @clientes = @clientes.where(cnpj: params[:cnpj]) if params[:cnpj].present?
    @clientes = @clientes.where(email: params[:email]) if params[:email].present?
    @clientes = @clientes.distinct.telefone(params[:telefone]) if params[:telefone].present?

    render json: @clientes.first
  end

  def set_telefone_preferencial
    if params[:cliente_id].present?
      if params[:id] == 'telefone'
        cliente = Cliente.find params[:cliente_id]
        cliente.update(telefone_preferencial: params[:preferencial])

        return render json: cliente, each_serializer: ClienteShortSerializer
      elsif params[:id] == 'telefone2'
        cliente = Cliente.find params[:cliente_id]
        cliente.update(telefone2_preferencial: params[:preferencial])

        return render json: cliente, each_serializer: ClienteShortSerializer
      elsif params[:id].include? "contato"
        id = params[:id].split('-')
        contato = Contato.find id[1]
        contato.telefone_preferencial = params[:preferencial]
        contato.save
        return render json: contato
      else
        id = params[:id].split('-')
        telefone = Telefone.find id[1]
        telefone.update(preferencial: params[:preferencial])

        return render json: telefone
      end
    else
      return render json: 'SEM_CLIENTE'.to_json, :status => 422
    end
  end

  def set_telefone_whatsapp
    if params[:cliente_id].present?
      if params[:id] == 'telefone'
        cliente = Cliente.find params[:cliente_id]
        cliente.update(telefone_enviado_whats: params[:enviado_whats])
        cliente.update(telefone_respondeu_whats: false) if params[:enviado_whats] == false

        return render json: cliente, each_serializer: ClienteShortSerializer
      elsif params[:id] == 'telefone2'
        cliente = Cliente.find params[:cliente_id]
        cliente.update(telefone2_enviado_whats: params[:enviado_whats])
        cliente.update(telefone2_respondeu_whats: false) if params[:enviado_whats] == false

        return render json: cliente, each_serializer: ClienteShortSerializer
      elsif params[:id].include? "contato"
        id = params[:id].split('-')
        contato = Contato.find id[1]
        contato.telefone_whats = params[:enviado_whats]
        contato.save
        return render json: contato
      else
        id = params[:id].split('-')
        telefone = Telefone.find id[1]
        telefone.enviado_whats = params[:enviado_whats]
        telefone.respondeu_whats = false if !telefone.enviado_whats
        telefone.save

        return render json: telefone
      end
    else
      return render json: 'SEM_CLIENTE'.to_json, :status => 422
    end
  end

  def set_respondeu_whats
    return render json: 'SEM_CLIENTE'.to_json, :status => 422 if params[:cliente_id].nil?

    if params[:id] == 'telefone'
      cliente = Cliente.find params[:cliente_id]
      cliente.update(telefone_respondeu_whats: params[:respondeu_whats])

      return render json: cliente, each_serializer: ClienteShortSerializer
    elsif params[:id] == 'telefone2'
      cliente = Cliente.find params[:cliente_id]
      cliente.update(telefone2_respondeu_whats: params[:respondeu_whats])

      return render json: cliente, each_serializer: ClienteShortSerializer
    else
      telefone = Telefone.find params[:id]
      telefone.update(respondeu_whats: params[:respondeu_whats])

      return render json: telefone
    end
  end

  def desativar_telefone
    telefone = Telefone.find params[:id]
    telefone.update(ativo: false)

    render json: telefone
  end

  def cancelar_atendimento
    @cliente.em_atendimento = false
    @cliente.user_atendimento = nil

    if @cliente.numero_fila.present?
      fila = FilaEmpresa.new(empresa: current_empresa, cliente: @cliente, numero_fila: @cliente.numero_fila)
      @cliente.numero_fila = nil
      fila.save
    end
    @cliente.save
    current_user.create_activity(:cancelou_atendimento, owner: current_user, recipient: @cliente)
    current_user.update(em_atendimento: false)
    flash[:success] = 'Atendimento cancelado!'

    render json: @cliente, each_serializer: ClienteShortSerializer
  end

  def get_fechamento_cliente
    render json: @cliente.fechamento
  end

  def novo_contato
    contato = @cliente.contatos.build(nome: params[:novo_contato_nome], telefone: params[:novo_contato_telefone])

    if contato.save
      render json: contato, status: 200
    else
      render json: contato.errors , status: 422
    end
  end

  def assinar_contrato
    cliente = Cliente.find params[:cliente_id]
    cliente.update(assinou_contrato: params[:info])
    render json: cliente
  end

  private
    def set_cliente
      @cliente = Cliente.find params[:id]
    end

    def cliente_params
      params.require(:cliente).permit(:cnpj, :inscricao_estadual, :data_licenca, :situacao, :cidade_id, :cnae_id, :importacao_id,
                                      :nire, :razao_social, :endereco, :numero_endereco, :complemento, :cep, :bairro, :email, :telefone,
                                      :telefone2, :observacao, :status_id, :escritorio_id, :nome_fantasia, :data_fechamento, :user_negociacao_id,
                                      :em_atendimento, :user_atendimento, :tempo_inerte, :proxima_pesquisa, :socio_admin, :email_backup, :senha_backup,
                                      :cpf, contatos_attributes: [:id, :nome, :telefone, :email, :funcao, :_destroy])
    end

  def verificar_contatos(contato_id, nome, cliente)
    if !contato_id.blank?
      contato = cliente.contatos.find_by_id contato_id
      contato.update(nome: nome) if contato.present?
    elsif !nome.blank?
      cliente.contatos.create(nome: nome)
    end
  end
end
