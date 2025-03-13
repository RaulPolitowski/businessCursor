class EmpresasController < ApplicationController
  before_action :set_empresa, only: [:show, :edit, :update, :destroy]

  def index
    @q = Empresa.search params[:q]
    @empresas = @q.result(distinct: true).order(:id)
    respond_to do |format|
      format.html
      format.json { render json: @empresas, status: 200 }
    end

  end

  def new
    @empresa = Empresa.new

    @cnaes = Cnae.all
    @cidades = Cidade.all
  end

  def edit
  end

  def create
    @empresa = Empresa.new(empresa_params)

    respond_to do |format|
      if @empresa.save
        @empresa.criar_registros_necessarios
        format.html { redirect_to empresas_path, notice: 'Empresa criada com sucesso.' }
      else
        flash[:error] =  @empresa.errors.full_messages.to_sentence
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @empresa.update(empresa_params)
        format.html { redirect_to empresas_path, notice: 'Empresa alterada com sucesso.' }
      else
        flash[:error] =  @empresa.errors.full_messages.to_sentence
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @empresa.destroy
    respond_to do |format|
      format.html { redirect_to empresas_url }
    end
  end

  def find_cidades
    @cidades = Cidade.select("cidades.*, estados.sigla").joins(:estado).where("upper(unaccent(cidades.nome)) LIKE upper(('%#{params[:term]}%')) OR cidades.id::varchar = '#{params[:term]}'").order(:nome).limit(5)
    respond_to do |format|
      format.html {render nothing: true}
      format.json
    end
  end

  def exportar_listas_job
    empresa = Empresa.find params[:empresa_id]
    csv = FilaEmpresa.exportar_lista_job params[:empresa_id], params[:numero_job], params[:quantidade], params[:abordagem_id], params[:abordagem_texto], params[:abordagem_tipo]

    send_data csv, filename: "exportacao-job-#{params[:numero_job]}-empresa#{empresa.cidade.estado.sigla}.csv"
  end

  def empresa_logada
    render json: current_empresa, status:200
  end

  def get_empresa_by_sigla_estado
    empresa = Empresa.find_by estado: params[:sigla]
    render json: empresa, status: 200
  end

  def get_estado_by_empresa
    empresa = Empresa.find params[:empresa_id]
    estado = Estado.find_by sigla: empresa.estado
    render json: estado, status: 200
  end

  private

    def set_empresa
      @empresa = Empresa.find(params[:id])
    end

    def empresa_params
      params.require(:empresa).permit(:cnpj, :cidade_id, :razao_social, :nome_fantasia, :ativo, :estado)
    end
end
