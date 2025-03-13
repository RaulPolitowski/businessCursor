class SolicitacaoDesistenciaExternoController < ApplicationController
  layout "layout_externo"
  skip_before_action :authenticate_user!, only: [:get_dados_cliente, :criar_desistencia, :get_cliente_api, :get_cliente_financeiro_ativo]

  def lancar_desistencia
  end

  def criar_desistencia
    cliente = Cliente.where(cnpj: params[:cnpj]).first
    desistencias = SolicitacaoDesistencia.where(cliente_id: cliente.id, status:['AGUARDANDO','ANDAMENTO']).first
    if(desistencias.present?) && (Time.now.to_date - desistencias.data_solicitacao.to_date).to_i < 30
      render json: 'Já existe uma solicitação de cancelamento para esse cliente', status: :unprocessable_entity
    else
      telefone = params[:telefone].size > 11 && params[:telefone].start_with?('55') ? params[:telefone][2..-1] : params[:telefone]
     solicitacao = SolicitacaoDesistencia.new(cnpj: params[:cnpj], nome_solicitante: params[:nome_solicitante], email_solicitante: params[:email_solicitante],
     solicitante: params[:solicitante], telefone: telefone, motivo_solicitacao: params[:motivo], status: 'AGUARDANDO', data_solicitacao: Time.now)

     solicitacao.cliente_id = cliente.id if cliente.present?
     solicitacao.empresa_id = cliente.empresa_id if cliente.present?
     solicitacao.save
     SolicitacaoDesistenciaMailer.new_solitacao_desistencia(solicitacao.nome_solicitante, solicitacao.email_solicitante, cliente.razao_social, cliente.cnpj).deliver

     render json: solicitacao
    end
  end

  def get_dados_cliente
    cliente = Cliente.find params[:id]

    render json: cliente
  end

  def get_cliente_api
    response = RestClient::Request.execute(method: :get,  url: "http://api.gtech.site/companies/#{params[:cnpj]}",
      headers: { Accept: 'application/vnd.germantech.v2',
                 Authorization: Digest::MD5.hexdigest(Time.new.strftime('%Y11586637000128%m%-d')) },
      timeout: 300, open_timeout: 300, read_timeout: 300)

    resposta = JSON.parse(response)

    render json: resposta
  end

  def get_cliente_financeiro_ativo
    connectionFinanceiro = Financeiro::HonorarioMensal.connection
    
    cliente = connectionFinanceiro.select_all SolicitacaoDesistenciaExternoHelper.get_cliente_financeiro_ativo(params[:cnpj])
 
    if cliente.present?
      render json: cliente, status: 200
    else
      return render json: 'Cliente não localizado!', status: 422
    end
  end

  def get_cliente_financeiro
    connectionFinanceiro = Financeiro::HonorarioMensal.connection
    
    cliente = connectionFinanceiro.select_all SolicitacaoDesistenciaExternoHelper.get_cliente_financeiro(params[:cnpj])
 
    if cliente.present?
      render json: cliente, status: 200
    else
      return render json: 'Cliente não localizado!', status: 422
    end
  end

end
