class ContratosController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_contrato, only: [:show, :edit, :update, :desativar, :ativar]
  before_filter :authorize_admin, only: [:create, :new, :edit, :update, :index, :show]

  def index
    @q = Contrato.search params[:q]
    @contratos = @q.result(distinct: true)
  end

  def show
  end

  def new
    @contrato = Contrato.new
    @opcoes = ContratosHelper.contrato_tags
  end

  def edit
    @opcoes = ContratosHelper.contrato_tags
  end

  def create
    @contrato = Contrato.new(contrato_params)
    @opcoes = ContratosHelper.contrato_tags
    respond_to do |format|
      if @contrato.save
        format.html { redirect_to contratos_path, notice: 'Contrato criado com sucesso.' }
        format.json { render json: @contrato, status: 201 }
      else
        format.html { render action: 'new', :flash => { :error => @contrato.errors.full_messages.to_sentence } }
        format.json { render json: { errors: @contrato.errors }, status: 422 }
      end
    end
  end

  def update
    respond_to do |format|
      if @contrato.update(contrato_params)
        format.html { redirect_to contratos_path, notice: 'Contrato alterado com sucesso.' }
        format.json { render json: @contrato, status: 200 }
      else
        format.html { render action: 'edit', :flash => { :error => @contrato.errors.full_messages.to_sentence } }
        format.json { render json: { errors: @contrato.errors }, status: 422 }
      end
    end
  end

  def desativar
    @contrato.ativo = false
    @contrato.save

    redirect_to :back
  end

  def ativar
    @contrato.ativo = true
    @contrato.save

    redirect_to :back
  end

  def destroy
    @contrato.destroy
    respond_to do |format|
      format.html { redirect_to contratos_url }
    end
  end
  
  def emitir_contrato
    @local = params[:local]
    if @local == 'acompanhamento'
      @info = Acompanhamento.find_by_id params[:id]
    elsif @local == 'fechamento'
        @info = Fechamento.find params[:id]
    else
      @info= Implantacao.find_by_id params[:id]
    end
    @cliente = Cliente.find_by_id @info.cliente
    @proposta = Proposta.find_by_id @info.proposta_id
    @cidade = Cidade.find_by_id @cliente.cidade_id
    @estado = Estado.find_by_id @cidade.estado_id
  end

  def emitir
    if params[:local] == 'acompanhamento'
      info = Acompanhamento.find_by_id params[:i]
    elsif @local == 'fechamento'
      info = Fechamento.find params[:id]
    else
      info= Implantacao.find_by_id params[:i]
    end
    cliente = Cliente.find_by_id info.cliente_id
    proposta = Proposta.find_by_id info.proposta_id
    mapa = ContratosHelper.conversao(cliente,proposta)
    contrato = Contrato.find_by_id params[:contrato_id]
    textoContrato = Mustache.render(contrato.texto,mapa)
    textoContrato = "<html><head></head><body>#{textoContrato}</body></html>"
      
    # if params[:formato] == 'doc'
    #   file_path = "#{Rails.root.join('tmp').to_s}/contratos/contrato_"+ cliente.id.to_s+".docx"
    #   document = Htmltoword::Document.create(textoContrato)
    #   FileUtils.mkdir_p("#{Rails.root.join('tmp').to_s}/contratos") unless File.directory?("#{Rails.root.join('tmp').to_s}/contratos")
   
    #   File.open(file_path, "wb") do |out|
    #     out << document
      
    #   send_file(file_path, :type => 'application/docx', :disposition => 'attachment')
    #   end
    # else
    path="#{Rails.root.join('tmp').to_s}/contratos/contrato_"+cliente.id.to_s+".pdf"
    FileUtils.mkdir_p("#{Rails.root.join('tmp').to_s}/contratos") unless File.directory?("#{Rails.root.join('tmp').to_s}/contratos")
    kit = PDFKit.new(textoContrato)

    contrato = kit.to_file(path)

    send_file(contrato, :type => 'application/pdf', :disposition => 'attachment')
    
  end

  private
    def set_contrato
      @contrato = Contrato.find(params[:id])
    end

    def contrato_params
      params.require(:contrato).permit(:nome, :descricao, :texto, :sistema_id)
    end
end
