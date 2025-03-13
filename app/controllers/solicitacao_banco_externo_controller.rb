class SolicitacaoBancoExternoController < ApplicationController
  layout "layout_externo"
  skip_before_action :authenticate_user!, only: [:criar_solicitacao, :solicitar_banco_externo]

  def solicitar_banco_externo
  end

  def criar_solicitacao
    cliente = Cliente.where(cnpj: params[:cnpj]).first
    solicitacao = SolicitacaoBanco.new(tipo: params[:tipo], observacao: params[:observacao], ativo: true, status: 'PENDENTE', 
                local_banco: params[:local], nome_solicitante: params[:nome_solicitante], telefone_parceiro: params[:telefone_parceiro],
                 cnpj_parceiro: params[:cnpj_parceiro], email_solicitante: params[:email_parceiro], email_cliente: params[:email_cliente],
                socio_admin: params[:socio], telefone1: params[:telefone1], telefone2: params[:telefone2], sistema: params[:sistema],
                valor_mensalidade: params[:mensalidade], data_vencimento: params[:data_vencimento], valor_implantacao: params[:implantacao],
                regime: params[:regime], data_implantacao: params[:data_implantacao])

    solicitacao.cliente_id = cliente.id if cliente.present?
    solicitacao.empresa_id = cliente.empresa_id if cliente.present?
    solicitacao.save
    SolicitacaoBancoMailer.new_solitacao_banco(solicitacao.nome_solicitante, solicitacao.email_solicitante, cliente.razao_social, cliente.cnpj).deliver
    
    render json: solicitacao
  end

end
