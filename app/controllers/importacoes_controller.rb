class ImportacoesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @importacoes = Importacao.where(empresa: current_empresa).order(data_importacao: :desc).limit(15)
  end

  def importacoes_estado
    importacoes = Importacao.where(empresa: params[:empresa_id]).order(data_importacao: :desc).limit(15)

    render json: importacoes
  end

  def importar_receita
    cliente = Cliente.where(cnpj: params[:cnpj], empresa_id: params[:empresa_id]).first
    msg = Importacao.importar_dados_receita cliente
    flash[:success] = 'Dados importados com sucesso.' if msg.blank?
    flash[:error] = msg if !msg.blank?

    render :nothing => true
  end

  def importar_cnpj
    msg = Importacao.importar_dados_cnpj params[:cnpj]

    render json: msg
  end

  def download_csv_file
    importacao = Importacao.find params[:id]

    send_data importacao.generate_csv_file, filename: "importacao-#{importacao.id}.csv"
  end

  def importacao_em_massa
    qtd = params[:qtd].to_i
    Importacao.importacao_em_massa(qtd)
    render json: {'msg': 'Deu certo'}.to_json, status: 200
  end
    

  def reconsultar_empresas
    clientes = Cliente.where('reconsultado is false and razao_social is null and created_at between ? and ?', params[:data_inicio], params[:data_final]).where.not(cnpj: nil).order(created_at: :asc).limit(params[:qtd])
    total_invalidos = Importacao.reconsultar_empresas clientes
    render json: {'msg':'Deu certo', 'total': clientes.size, 'invalidos': total_invalidos}.to_json, status: 200
  end

  def ultima_data_importacao
    connection = ActiveRecord::Base.connection
    data = connection.select_all ImportacoesHelper.sql_ultima_data_importacao
    data = data.first
    render json: data.to_json, status: 200
  end

  def quantidade_empresas_reconsultar
    connection = ActiveRecord::Base.connection
    data = connection.select_all ImportacoesHelper.sql_quantidade_empresas_reconsultar(params[:data_inicio], params[:data_final])
    data = data.first
    render json: data.to_json, status: 200
  end

  def reimportar_empresas
    Importacao.reimportar_empresas
    render json: { 'msg': 'Deu certo' }.to_json, status: 200
  end

  def reajustar_filas
    FilaEmpresa.reajustar_filas
    qtd_fila_empresa = FilaEmpresa.count
    render json: { 'msg': "#{qtd_fila_empresa} Filas Reajustadas com Sucesso" }.to_json, status: 200
  end

  def saldo_atual_por_job
    saldo = FilaEmpresa.saldo_atual(params[:empresa_id], params[:job]) || 0
    render json: saldo, status: 200
  end
end
