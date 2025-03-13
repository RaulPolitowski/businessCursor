class SolicitacaoBancosController < ApplicationController
  before_action :set_solicitacao_banco, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user!, only: [:get_parceiro_financeiro]

  def index
    @solicitacao_bancos = SolicitacaoBanco.where(ativo: true).order(created_at: :desc)
  end

  def solicitacoes_bancos
    params[:q]["status_eq"] = "" if params[:q]["status_eq"].eql? "-1"
    @q = SolicitacaoBanco.search params[:q]
    
    @cliente = Cliente.find_by(id: params[:q]["cliente_id_eq"]) unless params[:q]["cliente_id_eq"].nil?

    if params[:q]["created_at_lteq"].present?
      @solicitacoes = @q.result(distinct: true).where(ativo: params[:ativo]).order(created_at: :desc)
    else
      @solicitacoes = @q.result(distinct: true).where(ativo: params[:ativo]).where('created_at between ? and ?', Time.now.beginning_of_month, Time.now.end_of_month).order(created_at: :desc)
    end

    render json: @solicitacoes
  end

  def show
    @activities = PublicActivity::Activity.where(recipient_id: @solicitacao_banco.id, recipient_type: "SolicitacaoBanco").order("created_at desc")
  end

  # GET /solicitacao_bancos/new
  def new
    @solicitacao_banco = SolicitacaoBanco.new
  end


  def create_banco
    @solicitacao_banco = SolicitacaoBanco.new(user_id: current_user.id, cliente_id: params[:cliente_id], tipo: params[:tipo], status: 'PENDENTE', ativo: true,
                                        responsavel_id: params[:responsavel], motivo_solicitacao: params[:motivo], local_banco: params[:local_banco],
                                        empresa_id: current_empresa.id)
    #atualizar socio adm
    cliente = Cliente.find params[:cliente_id]
    cliente.update(socio_admin: params[:socio_admin]) if cliente.present?

    if @solicitacao_banco.save
      if params[:motivo].present?
        @solicitacao_banco.create_activity(:solicitou_banco_avulso, owner: current_user, recipient: @solicitacao_banco , params: {responsavel: @solicitacao_banco.user_id, motivo: params[:motivo]})
      else
        @solicitacao_banco.create_activity(:solicitou_banco, owner: current_user, recipient: @solicitacao_banco , params: {responsavel: @solicitacao_banco.user_id})
      end
      render json: @solicitacao_banco
    else
      render json: @solicitacao_banco.errors, status: :unprocessable_entity
    end
    
  end

  def get_dados_modal
    @cliente = Cliente.find params[:cliente_id]
    fechamento = @cliente.fechamento
    if params[:solicitou].present?
      fechamento.update(solicitou_banco: true) 
    else
      fechamento.update(solicitou_banco: false)
    end
    
    render json:@cliente
  end

  def get_solicitacao
    @solicitacao_banco = SolicitacaoBanco.find params[:id]
    render json: @solicitacao_banco
  end

  def desativar_banco
    @solicitacao_banco = SolicitacaoBanco.find params[:id]
    @solicitacao_banco.update(motivo_desativacao: params[:motivo], ativo: false, data_desativado: Time.now, desativado_por: current_user)
    @solicitacao_banco.create_activity(:desativou_banco, owner: current_user, recipient: @solicitacao_banco , params: {responsavel: @solicitacao_banco.user_id, motivo_desativacao: params[:motivo]})
    render json: @solicitacao_banco
  end

  def editar_solicitacao
    @solicitacao_banco = SolicitacaoBanco.find params[:solicitacao_banco][:id]
    #Raul pediu pra sempre atualizar o usuario logado como responsavel
    if @solicitacao_banco.responsavel_id != current_user.id
      @solicitacao_banco.create_activity(:responsavel, owner: current_user, recipient: @solicitacao_banco , params: {responsavel: current_user.id})
    end
    @solicitacao_banco.assign_attributes(solicitacao_banco_update_params)
    @solicitacao_banco.update(responsavel_id: current_user.id)
    # @solicitacao_banco.create_activity(:atualizou_banco, owner: current_user, recipient: @solicitacao_banco , params: {responsavel: @solicitacao_banco.user_id, status: params[:status], observacao: params[:observacao]})

    render json: @solicitacao_banco
  end

  def get_parceiro_financeiro
    connectionFinanceiro = Financeiro::HonorarioMensal.connection
    
    cliente = connectionFinanceiro.select_all "select * from financeiro.clientefornecedorfinanceiro where cpfcnpj='#{params[:cnpj]}'"
 
    if cliente.present?
      render json: cliente, status: 200
    else
      return render json: 'Parceiro não localizado!', status: 422
    end
  end

  def gerar_database
    @solicitacao_banco = SolicitacaoBanco.find params[:id]

    if !@solicitacao_banco.nota_fiscal_modulo && !@solicitacao_banco.nota_fiscal_consumidor_modulo &&
      !@solicitacao_banco.conhecimento_transporte_modulo && !@solicitacao_banco.manifesto_eletronico_modulo &&
      !@solicitacao_banco.nota_fiscal_servico_modulo && !@solicitacao_banco.cupom_fiscal_modulo
      return render json:{error: 'Nenhum módulo selecionado'}, status: 422
    end

    if @solicitacao_banco.nome_usuario.blank? || @solicitacao_banco.username.blank? || @solicitacao_banco.password.blank?
      return render json:{error: 'Dados do usuário inválido'}, status: 422
    end

    return render json:{error: 'Cliente sem CEP'}, status: 422 if @solicitacao_banco.cliente.cep.blank?
    ibge = codigo_ibge_cidade(@solicitacao_banco.cliente.cep)
    return render json:{error: 'Cidade do CEP não localizada'}, status: 422 if ibge.nil?

    return render json:{error: 'Endereço do cliente é muito grande, limite 34 caracteres.'}, status: 422 if @solicitacao_banco.cliente.endereco.size > 34
    return render json:{error: 'Nome Fantasia do cliente é muito grande, limite 60 caracteres.'}, status: 422 if @solicitacao_banco.cliente.nome_fantasia.size > 60
    return render json:{error: 'Razão Social do cliente é muito grande, limite 60 caracteres.'}, status: 422 if @solicitacao_banco.cliente.razao_social.size > 60
    return render json:{error: 'Bairro do cliente é muito grande, limite 60 caracteres.'}, status: 422 if @solicitacao_banco.cliente.bairro.size > 60

    @solicitacao_banco.update(status: 'ANDAMENTO')

    GenerateDatabaseEcf.perform_async("ecf_#{@solicitacao_banco.id}", @solicitacao_banco.id, ibge)

    render json: @solicitacao_banco, status: 200
  end

  def download_database
    @solicitacao_banco = SolicitacaoBanco.find params[:id]

    send_file @solicitacao_banco.file.path, disposition: 'inline'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_solicitacao_banco
      @solicitacao_banco = SolicitacaoBanco.find(params[:id])
    end

    def solicitacao_banco_params
      params.require(:solicitacao_banco).permit(:user, :cliente, :tipo, :status, :finalizado, :motivo_solicitacao, :observacao, :motivo_desativacao, :ativo, :responsavel)
    end

    def solicitacao_banco_update_params
      params.require(:solicitacao_banco).permit(:observacao, :local_banco, :inscricao_estadual, :contribuinte_icms, :nota_fiscal_modulo, :nota_fiscal_consumidor_modulo,
                                                :conhecimento_transporte_modulo, :manifesto_eletronico_modulo,
                                                :nota_fiscal_servico_modulo, :cupom_fiscal_modulo, :nome_usuario, :username, :password)
    end

  def codigo_ibge_cidade(numero_cep)
    return if numero_cep.nil?

    cep = CepImporter.new(numero_cep).import
    return if cep.nil?
    
    cep[:ibge]
  end
end
