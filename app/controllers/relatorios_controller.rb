class RelatoriosController < ApplicationController

  def resumo_comercial

  end

  def ligacoes

  end

  def primeira_mensalidade

  end

  def projecao_clientes_novos

  end

  def negociacoes

  end

  def pesquisa_satisfacao

  end

  def periodo_inertes

  end

  def analise_vendedor

  end

  def analise_pci

  end

  def analise_cliente

  end

  def contratos_assinados
  end

  def analise_pci_print
    data_inicial = Date.strptime(params[:data_inicio],  "%d/%m/%Y")
    data_final = Date.strptime(params[:data_fim],  "%d/%m/%Y")

    if data_inicial > data_final
      flash[:error] = 'Competência inicial não pode ser maior que competência final!'
      return redirect_to :back
    end

    if params[:limit].nil? || params[:limit].to_i < 1
      flash[:error] = 'Limite deve ser maior que zero'
      return redirect_to :back
    end

    param = Hash.new
    param[:data_inicial] = data_inicial.strftime("%Y-%m-%d")
    param[:data_final] = data_final.strftime("%Y-%m-%d")
    param[:estado] = params[:estado_id] if params[:estado_id].present?
    param[:cidade] = params[:cidade_id] if params[:cidade_id].present?
    param[:vendedor] = params[:vendedor_id] if params[:vendedor_id].present?
    param[:implantador] = params[:implantador_id] if params[:implantador_id].present?
    param[:empresa_id] = params[:empresa_id] if params[:empresa_id].present?
    param[:vendas] = (params[:vendas].present? ? true : false)
    param[:implantacoes] = (params[:implantacoes].present? ? true : false)
    param[:acompanhamentos] = (params[:acompanhamentos].present? ? true : false)
    param[:financeiro] = (params[:financeiro].present? ? true : false)
    param[:ordem] = params[:ordem]
    param[:limit] = params[:limit]

    # render json: param.to_json
    response = RestClient.post "http://127.0.0.1:3000/generate_pdf",
                               {name: 'analise_pci', connection: 'analise_pci',
                                parameters: param}.to_json,
                               {cache_control: "no-cache", content_type: "application/json"}

    send_data response.body, filename: "analise_pci.pdf", type: :pdf, disposition: 'inline'
  end


  def analise_pci_json
    connection = ActiveRecord::Base.connection

    lista = connection.select_all RelatoriosHelper.ranking_cnaes_etapas params[:data_inicial], params[:data_final],
                                                                        params[:estado], params[:cidade],
                                                                        params[:empresa_id], params[:vendedor],
                                                                        params[:implantador], params[:vendas],
                                                                        params[:implantacoes], params[:acompanhamentos],
                                                                        params[:ordem], params[:limit]
    lista = lista.to_hash
    if params[:financeiro].eql? "true"
      acomp = connection.select_all RelatoriosHelper.acompanhamentos_ranking_cnaes(params[:data_inicial], params[:data_final],
                                                                                   params[:estado], params[:cidade],
                                                                                   params[:empresa_id], params[:vendedor], params[:implantador])

      connecFinanceiro = Financeiro::HonorarioMensal.connection

      acomp = acomp.to_hash
      pagamentos = Array.new
      acomp.each do |acompanhamento|
        primeiraMensalidade = connecFinanceiro.select_all DashboardsFunilHelper.get_primeira_parcela_paga acompanhamento['cnpj'], params[:empresa_id]
        pagamentos << acompanhamento if primeiraMensalidade.present? && (primeiraMensalidade[0]['status'].eql? 'PAGO')
      end

      hash_pagamentos = Hash.new
      pagamentos.each do |pagamento|
        if hash_pagamentos[pagamento['codigo']].present?
          value = hash_pagamentos[pagamento['codigo']]
          hash_pagamentos[pagamento['codigo']] = {tipo: 3, id: pagamento['id'], codigo: pagamento['codigo'], descricao: pagamento['descricao'], qtd: (value[:qtd].to_i + 1), total: pagamento['total'], indice: (((value[:qtd].to_d + 1)*100)/ (pagamento['total'].to_d)).round(2)}
        else
          hash_pagamentos[pagamento['codigo']] = {tipo: 3, id: pagamento['id'], codigo: pagamento['codigo'], descricao: pagamento['descricao'], qtd: 1, total: pagamento['total'], indice: ((100)/pagamento['total'].to_d).round(2)}
        end
      end

      pagamentos = Array.new
      hash_pagamentos.each do |key, value|
        pagamentos << value
      end

      if params[:ordem].eql? 'QTD'
        pagamentos = pagamentos.sort_by{|obj| obj[:qtd]}.reverse!
      else
        pagamentos = pagamentos.sort_by{|obj| obj[:indice]}.reverse!
      end

      pagamentos.each_with_index do |pag, index|
        if index < params[:limit].to_i
          lista << pag
        end
      end
    end

    render json: lista
  end

  def pesquisa_print
    data_inicial = Date.strptime(params[:data_inicio],  "%d/%m/%Y")
    data_final = Date.strptime(params[:data_fim],  "%d/%m/%Y")

    if data_inicial > data_final
      flash[:error] = 'Competência inicial não pode ser maior que competência final!'
      return redirect_to :back
    end
    # response = RestClient.post "http://localhost:3000/generate_pdf",
    response = RestClient.post "http://127.0.0.1:3000/generate_pdf",
                               {name: 'pesquisa_satisfacao', connection: 'pesquisa_satisfacao',
                                parameters: {data_inicial: data_inicial.strftime("%Y-%m-%d"),
                                             data_final: data_final.strftime("%Y-%m-%d"),
                                             estado: (params[:estado_id].present? ? params[:estado_id] : nil),
                                             cidade: (params[:cidade_id].present? ? params[:cidade_id] : nil),
                                             sistema: (params[:sistema_id].present? ? params[:sistema_id] : nil),
                                             tipo_avaliacao: (params[:tipo_avaliacao].present? ? params[:tipo_avaliacao] : nil) ,
                                             empresa_id: (params[:empresa_id].present? ? params[:empresa_id] : nil)
                                             }}.to_json,
                               {cache_control: "no-cache", content_type: "application/json"}

    send_data response.body, filename: "pesquisa_satisfacao.pdf", type: :pdf, disposition: 'inline'
  end

  def periodo_inertes_print
    data_inicial = Date.strptime(params[:data_inicio],  "%d/%m/%Y")
    data_final = Date.strptime(params[:data_fim],  "%d/%m/%Y")

    if data_inicial > data_final
      flash[:error] = 'Competência inicial não pode ser maior que competência final!'
      return redirect_to :back
    end
    # response = RestClient.post "http://localhost:3000/generate_pdf",
    response = RestClient.post "http://127.0.0.1:3000/generate_pdf",
                               {name: 'periodo_inertes', connection: 'periodo_inertes',
                                parameters: {data_inicial: data_inicial.strftime("%Y-%m-%d"),
                                             data_final: data_final.strftime("%Y-%m-%d"),
                                             estado: (params[:estado_id].present? ? params[:estado_id] : nil),
                                             cidade: (params[:cidade_id].present? ? params[:cidade_id] : nil),
                                             sistema: (params[:sistema_id].present? ? params[:sistema_id] : nil),
                                             tipo_avaliacao: (params[:tipo_avaliacao].present? ? params[:tipo_avaliacao] : nil) ,
                                             empresa_id: (params[:empresa_id].present? ? params[:empresa_id] : nil)
                                }}.to_json,
                               {cache_control: "no-cache", content_type: "application/json"}

    send_data response.body, filename: "periodo_inertes.pdf", type: :pdf, disposition: 'inline'
  end

  def ligacoes_print
    data_inicial = Date.strptime(params[:data_inicio],  "%d/%m/%Y")
    data_final = Date.strptime(params[:data_fim],  "%d/%m/%Y")

    if data_inicial > data_final
      flash[:error] = 'Competência inicial não pode ser maior que competência final!'
      return redirect_to :back
    end

    empresa = params[:empresa_id].join(', ')

    # response = RestClient.post "http://localhost:3000/generate_pdf",
    response = RestClient.post "http://127.0.0.1:3000/generate_pdf",
                               {name: 'ligacoes', connection: 'business',
                                parameters: {data_inicial: data_inicial.strftime("%Y-%m-%d"),
                                             data_final: data_final.strftime("%Y-%m-%d"),
                                             status: (params[:status_id].present? ? params[:status_id] : nil) ,
                                             empresa: ApplicationHelper.get_empresas_by_codigo(empresa) ,
                                             operador: (params[:user_id].present? ? params[:user_id] : nil),
                                             estado: (params[:estado_financeiro_id].present? ? ApplicationHelper.get_estado_by_codigo(params[:estado_financeiro_id]) : nil)}}.to_json,
                               {cache_control: "no-cache", content_type: "application/json"}

    send_data response.body, filename: "ligacoes.pdf", type: :pdf, disposition: 'inline'
  end

  def negociacoes_print
    data_inicial = Date.strptime(params[:data_inicio], "%d/%m/%Y")
    data_final = Date.strptime(params[:data_fim], "%d/%m/%Y")

    tipos = "{"

    tipos = tipos + params[:em_aberto] + "," if params[:em_aberto].present?
    tipos = tipos + params[:criadas] + "," if params[:criadas].present?
    tipos = tipos + params[:fechadas] + "," if params[:fechadas].present?
    tipos = tipos + params[:canceladas] + "," if params[:canceladas].present?
    tipos = tipos[0..-2]
    tipos = tipos + "}"

    empresa = params[:empresa_id].join(', ')

    if params[:group_by].present? && params[:resumo] == 'true'
      # response = RestClient.post "http://localhost:3000/generate_pdf",
      response = RestClient.post "http://127.0.0.1:3000/generate_pdf",
                                 {name: 'negociacoes_agrupado', connection: 'business',
                                  parameters: {data_inicial: data_inicial.strftime("%Y-%m-%d"),
                                               data_final: data_final.strftime("%Y-%m-%d"),
                                               group: params[:group_by],
                                               prospectador: nil,
                                               negociador: (params[:operador].present? ? "{ #{params[:operador].join(',') } }" : nil) ,
                                               empresa: (params[:empresa_id].present? ? ApplicationHelper.get_empresas_by_codigo(empresa) : nil),
                                               resumo: params[:resumo],
                                               tipos: tipos,
                                               estado: (params[:estado_financeiro_id].present? ? ApplicationHelper.get_estado_by_codigo(params[:estado_financeiro_id]) : nil)}}.to_json,
                                 {cache_control: "no-cache", content_type: "application/json"}
    else
      # response = RestClient.post "http://localhost:3000/generate_pdf",
      response = RestClient.post "http://127.0.0.1:3000/generate_pdf",
                                 {name: 'negociacoes', connection: 'business',
                                  parameters: {data_inicial: data_inicial.strftime("%Y-%m-%d"),
                                               data_final: data_final.strftime("%Y-%m-%d"),
                                               group: params[:group_by],
                                               prospectador: nil,
                                               negociador: (params[:operador].present? ? "{ #{params[:operador].join(',') } }" : nil) ,
                                               empresa: (params[:empresa_id].present? ? ApplicationHelper.get_empresas_by_codigo(empresa) : nil),
                                               resumo: params[:resumo],
                                               tipos: tipos,
                                               estado: (params[:estado_financeiro_id].present? ? ApplicationHelper.get_estado_by_codigo(params[:estado_financeiro_id]) : nil)}}.to_json,
                                 {cache_control: "no-cache", content_type: "application/json"}
    end

    send_data response.body, filename: "negociacoes.pdf", type: :pdf, disposition: 'inline'
  end

  def negociacoes_sp_print
    data_inicial = Date.strptime(params[:data_inicio], "%d/%m/%Y")    
    data_final = Date.strptime(params[:data_fim], "%d/%m/%Y")

    tipos = "{"

    tipos = tipos + params[:em_aberto] + "," if params[:em_aberto].present?
    tipos = tipos + params[:reagendadas] + "," if params[:reagendadas].present?
    tipos = tipos + params[:criadas] + "," if params[:criadas].present?
    tipos = tipos + params[:fechadas] + "," if params[:fechadas].present?
    tipos = tipos + params[:canceladas] + "," if params[:canceladas].present?
    tipos = tipos[0..-2]
    tipos = tipos + "}"
    
    empresa = params[:empresa_id].join(', ')
    
    if params[:group_by].present? && params[:resumo] == 'true'
      # response = RestClient.post "http://localhost:3000/generate_pdf",
      response = RestClient.post "http://127.0.0.1:3000/generate_pdf",
                                 {name: 'negociacoes_sp_agrupado', connection: 'business',
                                  parameters: {data_inicial: data_inicial.strftime("%Y-%m-%d"),
                                               data_final: data_final.strftime("%Y-%m-%d"),
                                               group: params[:group_by],
                                               prospectador: (params[:captador].present? ? "{ #{params[:captador].join(',') } }" : nil) ,
                                               negociador: (params[:negociador].present? ? "{ #{params[:negociador].join(',') } }" : nil) ,
                                               empresa: (params[:empresa_id].present? ? ApplicationHelper.get_empresas_by_codigo(empresa) : nil),
                                               resumo: params[:resumo],
                                               tipos: tipos,
                                               estado: (params[:estado_financeiro_id].present? ? ApplicationHelper.get_estado_by_codigo(params[:estado_financeiro_id]) : nil)}}.to_json,
                                 {cache_control: "no-cache", content_type: "application/json"}
    else
      # response = RestClient.post "http://localhost:3000/generate_pdf",
      response = RestClient.post "http://127.0.0.1:3000/generate_pdf",
                                 {name: 'negociacoes_sp', connection: 'business',
                                  parameters: {data_inicial: data_inicial.strftime("%Y-%m-%d"),
                                               data_final: data_final.strftime("%Y-%m-%d"),
                                               group: params[:group_by],
                                               prospectador: (params[:captador].present? ? "{ #{params[:captador].join(',') } }" : nil) ,
                                               negociador: (params[:negociador].present? ? "{ #{params[:negociador].join(',') } }" : nil) ,
                                               empresa: (params[:empresa_id].present? ? ApplicationHelper.get_empresas_by_codigo(empresa) : nil),
                                               resumo: params[:resumo],
                                               tipos: tipos,
                                               estado: (params[:estado_financeiro_id].present? ? ApplicationHelper.get_estado_by_codigo(params[:estado_financeiro_id]) : nil)}}.to_json,
                                 {cache_control: "no-cache", content_type: "application/json"}
    end
    send_data response.body, filename: "negociacoes.pdf", type: :pdf, disposition: 'inline'
  end

  def primeira_mensalidade_print
    data_inicial = Date.strptime(params[:data_inicio], "%d/%m/%Y")
    data_final = Date.strptime(params[:data_fim], "%d/%m/%Y")

    # response = RestClient.post "http://localhost:3000/generate_pdf",
    response = RestClient.post "http://127.0.0.1:3000/generate_pdf",
                               {name: 'recebimento_primeira_mensalidade', connection: 'recebimento_primeira_mensalidade',
                                parameters: {data_inicial: data_inicial.strftime("%Y-%m-%d"),
                                             data_final: data_final.strftime("%Y-%m-%d"),
                                             group_by: params[:group_by],
                                             vendedor: (params[:vendedor].present? ? params[:vendedor] : '') ,
                                             empresa: params[:empresas_financeiro_id],
                                             estado: (params[:estado_financeiro_id].present? ? params[:estado_financeiro_id] : ''),
                                             acompanhador: (params[:acompanhamento].present? ? params[:acompanhamento] : '') ,
                                             implantador: (params[:implantador].present? ? params[:implantador] : '')}}.to_json,
                               {cache_control: "no-cache", content_type: "application/json"}

    send_data response.body, filename: "recebimento_primeira_mensalidade.pdf", type: :pdf, disposition: 'inline'
  end

  def projecao_clientes_novos_print
    data_inicial = Date.strptime(params[:data_inicio], "%m/%Y")
    data_final = Date.strptime(params[:data_fim], "%m/%Y")

    #if data_inicial < Time.now.beginning_of_month.to_date
     # flash[:error] = 'Competência inicial não pode ser igual ou menor que a data atual!'
     # return redirect_to :back
    #end

    if data_inicial > data_final
      flash[:error] = 'Competência inicial não pode ser maior que competência final!'
      return redirect_to :back
    end
    response = RestClient.post "http://127.0.0.1:3000/generate_pdf",
    # response = RestClient.post "http://localhost:3000/generate_pdf",
                               {name: 'projecao_clientes_novos', connection: 'projecao_clientes_novos',
                                parameters: {data_inicial: data_inicial.beginning_of_month.strftime("%Y-%m-%d"),
                                             data_final: data_final.end_of_month.strftime("%Y-%m-%d"),
                                             group_by: params[:group_by],
                                             order_by: params[:order_by],
                                             vendedor: (params[:vendedor].present? ? params[:vendedor] : '') ,
                                             empresa: params[:empresas_financeiro_id],
                                             estado: (params[:estado_id].present? ? params[:estado_id] : nil),
                                             acompanhador: (params[:acompanhamento].present? ? params[:acompanhamento] : '') ,
                                             implantador: (params[:implantador].present? ? params[:implantador] : '')}}.to_json,
                               {cache_control: "no-cache", content_type: "application/json"}

    send_data response.body, filename: "projecao_clientes_novos.pdf", type: :pdf, disposition: 'inline'
  end

  def ligacoes_relatorio
    @data_inicial = Time.parse(params[:data_inicio])
    @data_final = Time.parse(params[:data_fim])
    @ligacoes = Ligacao.where(empresa_id: current_empresa.id).where('data_inicio::date between ? and ?', @data_inicial, @data_final)

    if params[:status_cliente_id].present?
      @ligacoes = @ligacoes.where(status_cliente_id: params[:status_cliente_id])
    end

    if params[:user_id].present?
      @ligacoes = @ligacoes.where(user_id: params[:user_id])
    end

    @totalStatus = @ligacoes.group(:status_cliente).order('count_id desc').count('id')

    if params[:user_id].present?
      @ligacoes = @ligacoes.order(:status_cliente_id)
    else
      @ligacoes = @ligacoes.order(:user_id)
    end

    respond_to do |format|
      format.pdf { render pdf: "Histórico",
                          orientation: 'Landscape',
                          header: {center: current_empresa.razao_social},
                          footer: { center: "[page] de [topage]" },
                          encoding: 'utf8'
      }
    end
  end

  def resumo_comercial_relatorio
    connection = ActiveRecord::Base.connection

    @data_inicial = Time.parse(params[:data_inicio])
    @data_final = Time.parse(params[:data_fim])

    sql = RelatoriosHelper.resumo_comercial_concluidas_teste params[:data_inicio], params[:data_fim], params[:empresa_id], params[:vendedor_id], params[:implantador_id], params[:sistema_id], params[:cidade_id], params[:estado_financeiro_id]

    @concluidasTeste = connection.select_all sql
    @totalMensalidadeConcluidasTeste = 0.0

    sql = RelatoriosHelper.resumo_comercial_concluidas_efetivo params[:data_inicio], params[:data_fim], params[:empresa_id], params[:vendedor_id], params[:implantador_id], params[:sistema_id], params[:cidade_id], params[:estado_financeiro_id]
    @concluidasEfetivo = connection.select_all sql
    @totalMensalidadeConcluidasEfetivo = 0.0

    sql = RelatoriosHelper.resumo_comercial_em_andamento params[:data_inicio], params[:data_fim], params[:empresa_id], params[:vendedor_id], params[:implantador_id], params[:sistema_id], params[:cidade_id], params[:estado_financeiro_id]
    @andamento = connection.select_all sql
    @totalMensalidadeAndamento = 0.0

    sql = RelatoriosHelper.resumo_comercial_efetivadas params[:data_inicio], params[:data_fim], params[:empresa_id], params[:vendedor_id], params[:implantador_id], params[:sistema_id], params[:cidade_id], params[:estado_financeiro_id]
    @efetivadas = connection.select_all sql
    @totalMensalidadeEfetivadas = 0.0

    sql = RelatoriosHelper.resumo_comercial_desistente_pre params[:data_inicio], params[:data_fim], params[:empresa_id], params[:vendedor_id], params[:implantador_id], params[:sistema_id], params[:cidade_id], params[:estado_financeiro_id]
    @desistentes_pre = connection.select_all sql
    @totalMensalidadeDesistentePre = 0.0

    sql = RelatoriosHelper.resumo_comercial_desistente_durante params[:data_inicio], params[:data_fim], params[:empresa_id], params[:vendedor_id], params[:implantador_id], params[:sistema_id], params[:cidade_id], params[:estado_financeiro_id]
    @desistentes_durante = connection.select_all sql
    @totalMensalidadeDesistenteDurante = 0.0

    sql = RelatoriosHelper.resumo_comercial_desistente_acompanhamento params[:data_inicio], params[:data_fim], params[:empresa_id], params[:vendedor_id], params[:implantador_id], params[:sistema_id], params[:cidade_id], params[:estado_financeiro_id]
    @desistentes_acompanhamento = connection.select_all sql
    @totalMensalidadeDesistenteAcompanhamento = 0.0

    respond_to do |format|
      format.pdf { render pdf: "Resumo",
                          orientation: 'Landscape',
                          header: { center: "RELATÓRIO RESUMO COMERCIAL"},
                          footer: { center: "[page] de [topage]" },
                          encoding: 'utf8'
        # show_as_html:   true
      }
    end
  end

  def recebimento_primeira_mensalidade_json
    connection = Financeiro::HonorarioMensal.connection
    lista = connection.select_all RelatoriosHelper.pagamento_primeira_mensalidade_financeiro params[:data_inicial], params[:data_final], params[:empresa], params[:estado], false
    hash = lista.to_hash
    hash.each do |empr|
      processar_informacoes_business(empr)
      cliente = Cliente.find_by_cnpj empr['cpfcnpj'].strip
      if cliente.present?
        if cliente.fechamento.present?
          empr['tipo'] = 1
        else
          empr['tipo'] = 2
        end
      else
        empr['tipo'] = 3
      end
    end

    hash = hash.select { |key, value| params[:vendedor] == key['vendedor_id'].to_s } if params[:vendedor].present?
    hash = hash.select { |key, value| params[:implantador] == key['implantador_id'].to_s } if params[:implantador].present?
    hash = hash.select { |key, value| params[:acompanhador] == key['acompanhador_id'].to_s } if params[:acompanhador].present?

    render json: hash
  end

  def projecao_clientes_novos_json
    connection = Financeiro::HonorarioMensal.connection
    lista = connection.select_all RelatoriosHelper.projecao_clientes_novos params[:data_inicial], params[:data_final], params[:empresa], params[:estado], params[:group_by], params[:order_by]
    
    hash = lista.to_hash
    hash.each do |empr|
      processar_informacoes_business(empr)
      cliente = Cliente.find_by_cnpj empr['cpfcnpj'].strip
      if cliente.present? && cliente.fechamento.present?
          proposta = cliente.fechamento.proposta
          empr['mensalidade'] = proposta.present? ? sprintf("%.2f", proposta.valor_mensalidade) : ''
          empr['data_fechamento'] = cliente.fechamento.data_fechamento.strftime("%d/%m%Y")
          empr['telefone'] = Importacao.telefone_converter(cliente.telefone)
      end
    end

    hash = hash.select { |key, value| params[:vendedor] == key['vendedor_id'].to_s } if params[:vendedor].present?
    hash = hash.select { |key, value| params[:implantador] == key['implantador_id'].to_s } if params[:implantador].present?
    hash = hash.select { |key, value| params[:acompanhador] == key['acompanhador_id'].to_s } if params[:acompanhador].present?

    if params[:totalizado].present?
      valorTotal = hash.sum { |value| value['valor'].to_f }
      pagos = hash.select { |value| value['pago'] == 't' }
      valorTotalPago = pagos.sum{ |value| value['valordebito'].to_f}
      render json: {'total': hash.count, 'valor': valorTotal, 'totalpago': pagos.count, 'valortotalpago': valorTotalPago }
    else
      render json: hash
    end
  end

  include ActionView::Helpers::NumberHelper
  def pesquisa_satisfacao_json

    connection = ActiveRecord::Base.connection
    lista = connection.select_all RelatoriosHelper.get_pesquisas_satisfacao params[:data_inicial], params[:data_final],
                                                                            params[:empresa_id], params[:tipo_avaliacao],
                                                                            params[:estado], params[:cidade]

    hash = lista.to_hash
    hash.each do |empr|
      cliente = Cliente.find_by_cnpj empr['cnpj'].strip

      clienteFi = Financeiro::ClienteFornecedor.where(cpfcnpj: empr['cnpj']).first
      if clienteFi.nil?
        empr['mensalidade'] = 'Sem info.'
        empr['cliente_tempo']= 'Sem info.'
      else
        honorario = Financeiro::HonorarioMensal.where(clifor_id: clienteFi.id, tipo_id: 16, ativo: true).first
        
        
        if honorario.nil?
          empr['mensalidade'] = 'Sem info.'
          empr['cliente_tempo']= 'Sem info.'
        else
         
          empr['mensalidade'] = number_to_currency(honorario.valor)
          empr['cliente_tempo']= honorario.datavencimento.strftime("%m/%Y")
        end
      end

      system = cliente.sistema_api
      empr['sistema'] = system
    end
    if params[:sistema].present? && !(params[:sistema].eql? "null")
      sistema = Sistema.find params[:sistema]
      hash = hash.select { |key, value| ( key['sistema'].upcase.include? sistema.nome.upcase) }
    end

    render json: hash
  end


  def analise_vendedor_print
    data_inicial = Date.strptime(params[:data_inicio], "%d/%m/%Y")
    data_final = Date.strptime(params[:data_fim], "%d/%m/%Y")

    # response = RestClient.post "http://localhost:3000/generate_pdf",
    response = RestClient.post "http://127.0.0.1:3000/generate_pdf",
                               {name: 'analise_vendedor', connection: 'analise_vendedor',
                                parameters: {data_inicial: data_inicial.strftime("%Y-%m-%d"),
                                             data_final: data_final.strftime("%Y-%m-%d"),
                                             group_by: params[:group_by],
                                             vendedor: (params[:vendedor].present? ? params[:vendedor] : '') ,
                                             acompanhador: (params[:acompanhamento].present? ? params[:acompanhamento] : '') ,
                                             implantador: (params[:implantador].present? ? params[:implantador] : ''),
                                             estado: (params[:estado_financeiro_id].present? ? params[:estado_financeiro_id] : ''),
                                             empresa: params[:empresas_financeiro_id]}}.to_json,
                               {cache_control: "no-cache", content_type: "application/json"}

    send_data response.body, filename: "analise_vendedor.pdf", type: :pdf, disposition: 'inline'
  end

  def analise_vendedor_json
    connection = Financeiro::HonorarioMensal.connection
    lista = connection.select_all RelatoriosHelper.pagamento_primeira_mensalidade_financeiro params[:data_inicial], params[:data_final], params[:empresa], params[:estado], false

    response = Array.new

    hash = lista.to_hash
    hash.each do |empr|
      processar_informacoes_business(empr)
      empr['tipo'] = 1
      response << empr
    end

    lista = connection.select_all RelatoriosHelper.pagamento_primeira_parcela_implantacao params[:data_inicial], params[:data_final], params[:empresa], params[:estado]
    hash = lista.to_hash
    hash.each do |empr|
      processar_informacoes_business(empr)
      empr['tipo'] = 2
      response << empr
    end

    lista = connection.select_all RelatoriosHelper.pagamento_demais_parcelas_implantacao params[:data_inicial], params[:data_final], params[:empresa], params[:estado]
    hash = lista.to_hash
    hash.each do |empr|
      processar_informacoes_business(empr)
      empr['tipo'] = 3
      response << empr
    end

    response = response.select { |key, value| params[:vendedor] == key['vendedor_id'].to_s } if params[:vendedor].present?
    response = response.select { |key, value| params[:implantador] == key['implantador_id'].to_s } if params[:implantador].present?
    response = response.select { |key, value| params[:acompanhador] == key['acompanhador_id'].to_s } if params[:acompanhador].present?

    render json: response
  end

  def analise_cliente_print
    competencia = Date.strptime(params[:competencia], "%m/%Y")

    response = RestClient::Request.execute(method: :post,  url: "http://127.0.0.1:3000/generate_pdf",
                                           payload: {name: 'analise_cliente', connection: 'analise_cliente',
                                                  parameters: {competencia: competencia.end_of_month.strftime("%Y-%m-%d"),
                                                               empresa: params[:empresa_id],
                                                               filtro: params[:filtro],
                                                               order: params[:order],
                                                               agrupar: params[:agrupar] ,
                                                               hora_comercial: params[:hora_comercial],
                                                               hora_sabado: params[:hora_sabado],
                                                               hora_domingo: params[:hora_domingo],
                                                               ainda_cliente: params[:ainda_cliente],
                                                               sistema: (params[:sistema_id].present? ? params[:sistema_id] : '') ,
                                                               cidade: (params[:cidade_id].present? ? params[:cidade_id] : ''),
                                                               estado: (params[:estado_id].present? ? params[:estado_id] : ''),
                                                               cliente: (params[:cliente_id].present? ? params[:cliente_id] : '')}}.to_json,
                                           headers: {cache_control: "no-cache", content_type: "application/json"},
                                           timeout: 360, read_timeout: 360, open_timeout: 360)

    send_data response.body, filename: "analise_cliente.pdf", type: :pdf, disposition: 'inline'
  end

  def analise_cliente_json
    connection = Financeiro::HonorarioMensal.connection
    lista = connection.select_all RelatoriosHelper.analise_clientes params[:empresa], params[:competencia], params[:filtro], params[:cidade], params[:estado], params[:cliente],params[:ainda_cliente], params[:agrupar].to_i

    hash_tempo = RelatoriosHelper.buscar_tempo_chamados params[:competencia], params[:agrupar].to_i
    hash_system = Api::Company.all_cnpj_system

    lista.each do |empr|
      systemArray = hash_system.select{|key, value| key[:cnpj] == empr["cpfcnpj"]}
      systemArray.each do |sistema|
        empr['sistema'] = sistema[:system]
      end

      tempo = hash_tempo.select{|key, value| key["cnpj"] == empr["cpfcnpj"]}
      tempo.each do |tipo|
        if tipo['data'] == empr['data_controle']
          empr['tempo_comercial'] = tipo["seconds"] if tipo["tipo"].eql? "NORMAL"
          empr['tempo_sabado'] = tipo["seconds"] if tipo["tipo"].eql? "SABADO"
          empr['tempo_domingo'] = tipo["seconds"] if tipo["tipo"].eql? "DOMINGO"
        end
      end

      empr['tempo_comercial'] = 0 if empr['tempo_comercial']
      empr['tempo_sabado'] = 0 if empr['tempo_sabado'].nil?
      empr['tempo_domingo'] = 0 if empr['tempo_domingo'].nil?

      honorario = empr['valor'].to_d
      empr['valor'] = number_to_currency(honorario)

      comercial = empr['tempo_comercial'].to_d / 3600
      sabado = empr['tempo_sabado'].to_d / 3600
      domingo = empr['tempo_domingo'].to_d / 3600

      valor_comercial = comercial * parse_valor_rails(params[:hora_comercial])
      valor_sabado = sabado * parse_valor_rails(params[:hora_sabado])
      valor_domingo = domingo * parse_valor_rails(params[:hora_domingo])

      empr['total_comercial'] = valor_comercial
      empr['total_sabado'] = valor_sabado
      empr['total_domingo'] = valor_domingo
      empr['total_comercial_desc'] = number_to_currency(valor_comercial)
      empr['total_sabado_desc'] = number_to_currency(valor_sabado)
      empr['total_domingo_desc'] = number_to_currency(valor_domingo)

      valor_lucro = honorario - (valor_comercial + valor_sabado + valor_domingo)
      empr['valor_lucro'] = valor_lucro
      empr['valor_lucro_desc'] = number_to_currency(valor_lucro)
      if valor_lucro >= 0
        empr['lucro'] = 'Lucro'
      else
        empr['lucro'] = 'Prejuízo'
      end
    end
    if params[:sistema].present? && !(params[:sistema].eql? "null")
      sistema = Sistema.find params[:sistema]
      lista = lista.select { |key, value| ( key['sistema'].upcase.include? sistema.nome.upcase) }
    end

    #Filtrar prejuizo
    lista = lista.select { |key, value| ( key['valor_lucro'] < 0) } if params[:filtro] == '2'


    render json: lista, status: 200
  end


  include ActionView::Helpers::NumberHelper
  def periodo_inertes_json

    connection = ActiveRecord::Base.connection
    lista = connection.select_all RelatoriosHelper.periodo_inertes params[:data_inicial], params[:data_final],
                                                                            params[:empresa_id], params[:tipo_avaliacao],
                                                                            params[:estado], params[:cidade]

    hash = lista.to_hash
    hash.each do |empr|
      cliente = Cliente.find_by_cnpj empr['cnpj'].strip

      clienteFi = Financeiro::ClienteFornecedor.where(cpfcnpj: empr['cnpj']).first
      if clienteFi.nil?
        empr['mensalidade'] = 'Sem info.'
        empr['cliente_tempo']= 'Sem info.'
        empr['contato']= 'Sem info.'
      else
        empr['contato']= clienteFi.nomecontato

        honorario = Financeiro::HonorarioMensal.where(clifor_id: clienteFi.id, tipo_id: 16, ativo: true).first

        if honorario.nil?
          empr['mensalidade'] = 'Sem info.'
          empr['cliente_tempo']= 'Sem info.'
        else

          empr['mensalidade'] = number_to_currency(honorario.valor)
          empr['cliente_tempo']= honorario.datavencimento.strftime("%m/%Y")
        end
      end

      system = cliente.sistema_api
      empr['sistema'] = system
    end
    if params[:sistema].present? && !(params[:sistema].eql? "null")
      sistema = Sistema.find params[:sistema]
      hash = hash.select { |key, value| ( key['sistema'].upcase.include? sistema.nome.upcase) }
    end

    render json: hash
  end

  def comissionamento_mensalidades

  end

  def comissionamento_mensalidades_print
    data_inicial = Date.strptime(params[:data_inicio], "%m/%Y")
    data_final = Date.strptime(params[:data_fim], "%m/%Y")
  
    if [1,2].include? params[:tipo].to_i
      return redirect_to root_path, alert: 'Você não tem acesso a esse relatório' unless [1,4,27,99].include? current_user.id
    end
    
    vend = params[:vendedor]
    imp = params[:implantador]
    acomp = params[:acompanhador]
    
    if params[:tipo].eql? '6'
      vend = params[:vendedor_meta]
    elsif params[:tipo].eql? '7'
      vend = params[:estagio]
    elsif params[:tipo].eql? '8'
      imp = params[:implantador_meta]      
    end
    
    unless current_user.admin?
      if (params[:vendedor] != "" || params[:vendedor_meta] != "" || params[:estagio] != "") && vend.to_i != current_user.id
        return redirect_to root_path, alert: 'Você não tem acesso a esse relatório'
      elsif (params[:implantador] != "" || params[:implantador_meta] != "" ) && imp.to_i != current_user.id
        return redirect_to root_path, alert: 'Você não tem acesso a esse relatório'
      elsif params[:acompanhador] != "" && acomp.to_i != current_user.id
        return redirect_to root_path, alert: 'Você não tem acesso a esse relatório'
      end
    end
    colaborador = params[:tipo].eql?('11') ? params[:responsavel] : params[:colaborador]
    
    response = RestClient::Request.execute(method: :post,  url: "http://127.0.0.1:3000/generate_pdf",
                                           payload: {name: 'comissionamento', connection: 'comissionamento',
                                                     parameters: {data_inicial: data_inicial.beginning_of_month.strftime("%Y-%m-%d"),
                                                                  data_final: data_final.end_of_month.strftime("%Y-%m-%d"),
                                                                  tipo: params[:tipo],
                                                                  valor_local: parse_valor_rails(params[:valor_local]),
                                                                  valor_regional: parse_valor_rails(params[:valor_regional]),
                                                                  percentual_escritorios: parse_valor_rails(params[:percentual_escritorios]),
                                                                  vendedor: vend,
                                                                  acompanhador: acomp,
                                                                  colaborador: colaborador,
                                                                  colaborador_tipo10: params[:colaborador_tipo_10],
                                                                  implantador: imp,
                                                                  outros_clientes: params[:filtro_cliente_id]}}.to_json,
                                           headers: {cache_control: "no-cache", content_type: "application/json"},
                                           timeout: 120, read_timeout: 120, open_timeout: 240)

    send_data response.body, filename: "comissionamento_mensalidades.pdf", type: :pdf, disposition: 'inline'
  end

  def relatorio_atividades_ecf_json
    connection = Financeiro::HonorarioMensal.connection

    lista = connection.select_all FinanceiroHelper.get_sql_clientes_ativos
    @hash = lista.to_hash
    @hash.each do |empr|
      processar_api_informacoes(empr)
    end
    qtdTotal = @hash.length
    qtdUltimaSemana = @hash[0 .. -1]
    qtdUltimaSemana = qtdUltimaSemana.select { |key, value| ( key['ultimo_login_qtd'].to_i > 7) }.count
    qtdTresDias = @hash[0 .. -1]
    qtdTresDias = qtdTresDias.select { |key, value| ( key['ultimo_login_qtd'].to_i > 3 && key['ultimo_login_qtd'].to_i <= 7) }.count
    qtdDoisDias = @hash[0 .. -1]
    qtdDoisDias = qtdDoisDias.select { |key, value| ( key['ultimo_login_qtd'].to_i > 2 && key['ultimo_login_qtd'].to_i <= 3) }.count

    empresas = @hash.select { |key, value| ( key['ultimo_login_qtd'].to_i <= 7) }
    empresas.each do |empr|
      empr['qtdTotal'] = qtdTotal
      empr['qtdUltimaSemana'] = qtdUltimaSemana
      empr['percUltimaSemana'] = ((qtdUltimaSemana.to_d*100)/qtdTotal.to_d).round(2).to_s
      empr['qtdTresDias'] = qtdTresDias
      empr['percTresDias'] = ((qtdTresDias.to_d*100)/qtdTotal.to_d).round(2).to_s
      empr['qtdDoisDias'] = qtdDoisDias
      empr['percDoisDias'] = ((qtdDoisDias.to_d*100)/qtdTotal.to_d).round(2).to_s
    end

    empresas = empresas.sort_by{|obj| obj['ultimo_login_qtd'] }.reverse!

    render json: empresas, status: 200
  end

  def comissionamento_mensalidades_json
    connection = Financeiro::HonorarioMensal.connection
    # byebug
    @tipo = params[:tipo]
    if ['1','3', '4', '5', '6', '7', '8', '9', '10', '11'].include? @tipo
      lista = connection.select_all RelatoriosHelper.pagamento_primeira_mensalidade_financeiro params[:data_inicial], params[:data_final], '17,3253,3422', nil, true  
    elsif @tipo.eql? '2' #remover desconto
      lista = connection.select_all RelatoriosHelper.pagamento_primeira_mensalidade_financeiro params[:data_inicial], params[:data_final], '3422', nil, false 
    else
      lista = connection.select_all RelatoriosHelper.pagamento_primeira_mensalidade_financeiro params[:data_inicial], params[:data_final], '3422', nil, true
    end
    @hash = lista.to_hash

    if params[:outros_clientes].present?
      aux = params[:outros_clientes].split(',')
      aux.each do |cnpj|
        id_financeiro = connection.select_all "SELECT id FROM financeiro.clientefornecedorfinanceiro WHERE cpfcnpj = '#{cnpj}'"
        id_financeiro = id_financeiro[0]['id'].to_i
        add = nil
        if @tipo.eql? '2'
          add = connection.select_all RelatoriosHelper.pagamento_primeira_mensalidade_empresa '3422', id_financeiro 
        else
          add = connection.select_all RelatoriosHelper.pagamento_primeira_mensalidade_empresa '17,3253,3422', id_financeiro 
        end       
        add = add.to_hash
        @hash = @hash + add
      end
    end  

    @hash.each do |empr|
      empr[:tipo] = @tipo
      empr[:detail] = true
      processar_informacoes_business(empr)
      processar_informacoes_comissao_coordenardor(params, empr, @tipo) if ['1', '2'].include? @tipo
      processar_informacoes_comissao_vendedores(empr, params[:vendedor]) if @tipo.eql? '3'
      processar_informacoes_comissao_implantacao(params, empr) if @tipo.eql? '4'
      processar_informacoes_comissao_acompanhamento(params, empr) if @tipo.eql? '5'
      processar_informacoes_comissao_vendedor_meta(params, empr) if @tipo.eql? '6'
      processar_informacoes_comissao_estagio(params, empr) if @tipo.eql? '7'
      processar_informacoes_comissao_implantador_meta(params, empr) if @tipo.eql? '8'
      processar_informacoes_comissao_administrativo(params, empr) if ['9'].include? @tipo
      processar_informacoes_comissao_marketing(empr) if @tipo.eql? '11'
    end

    if ["1", "2"].include? @tipo
      @hash = @hash.select { |key, value| ( key['sistema'] != "ATHUS MANAGMENT SYSTEM") && ( key['sistema'] != "FISCAL/CONTÁBIL")}
      @hash = @hash.select { |key, value| ( key['tipo_comissao'] != "DESCONTO") || ( key['comissao'].to_d > 0.to_d ) }
    end
    
    if ["3", "7"].include? @tipo
      @hash = @hash.select { |key, value| ( key['vendedor_id'].to_i.eql? params[:vendedor].to_i) }
    end

    if @tipo.eql? "4"
      @hash = @hash.select { |key, value| ( key['implantador_id'].to_i.eql? params[:implantador].to_i) }
    end

    # acompanhamento
    if @tipo.eql? "5"
      @hash = @hash.select { |key, value| ( key['acompanhador_id'].to_i.eql? params[:acompanhador].to_i) }
      calcular_acompanhamento_comissao(@hash)
    end

    #consultor meta
    if @tipo.eql? "6"
      @hash = @hash.select { |key, value| ( key['vendedor_id'].to_i.eql? params[:vendedor].to_i) }
      total = calcularTotal(@hash)
      @hash.each do |item|
        if total <= 1500
          item['percentual_comissao'] = 0
          item['comissao'] =  format_value_without_simbol((item['mensalidade'].to_d * 0) / 100)
        elsif total >= 1501 && total <= 2200
          item['percentual_comissao'] = (item['tipo_comissao'].eql? "COMISSAO") ? 15 : 7.5
          item['comissao'] =  format_value_without_simbol((item['mensalidade'].to_d * 15) / 100) if item['tipo_comissao'].eql? "COMISSAO"
          item['comissao'] =  format_value_without_simbol((item['mensalidade'].to_d * 7.5) / 100) if item['tipo_comissao'].eql? "DESCONTO"
        elsif total >= 2201 && total <= 3000
          item['percentual_comissao'] = (item['tipo_comissao'].eql? "COMISSAO") ? 20 : 10
          item['comissao'] =  format_value_without_simbol((item['mensalidade'].to_d * 20) / 100) if item['tipo_comissao'].eql? "COMISSAO"
          item['comissao'] =  format_value_without_simbol((item['mensalidade'].to_d * 10) / 100) if item['tipo_comissao'].eql? "DESCONTO"
        elsif total >= 3001 && total <= 4500
          item['percentual_comissao'] = (item['tipo_comissao'].eql? "COMISSAO") ? 30 : 15
          item['comissao'] =  format_value_without_simbol((item['mensalidade'].to_d * 30) / 100) if item['tipo_comissao'].eql? "COMISSAO"
          item['comissao'] =  format_value_without_simbol((item['mensalidade'].to_d * 15) / 100) if item['tipo_comissao'].eql? "DESCONTO"
        elsif total > 4500
          item['percentual_comissao'] = (item['tipo_comissao'].eql? "COMISSAO") ? 40 : 20
          item['comissao'] =  format_value_without_simbol((item['mensalidade'].to_d * 40) / 100) if item['tipo_comissao'].eql? "COMISSAO"
          item['comissao'] =  format_value_without_simbol((item['mensalidade'].to_d * 20) / 100) if item['tipo_comissao'].eql? "DESCONTO"
        end
      end
    end
    
    #implantador meta
    if @tipo.eql? "8"
      @hash = @hash.select { |key, value| ( key['implantador_id'].to_i.eql? params[:implantador].to_i) }
      total = calcularTotal(@hash)
      @hash.each do |item|
        if total <= 2000
          item['percentual_comissao'] = 0
          item['comissao'] =  format_value_without_simbol((item['mensalidade'].to_d * 0) / 100)
        elsif total > 2000 && total <= 4000
          item['percentual_comissao'] = (item['tipo_comissao'].eql? "COMISSAO") ? 10 : 5
          item['comissao'] =  format_value_without_simbol((item['mensalidade'].to_d * 10) / 100) if item['tipo_comissao'].eql? "COMISSAO"
          item['comissao'] =  format_value_without_simbol((item['mensalidade'].to_d * 5) / 100) if item['tipo_comissao'].eql? "DESCONTO"
        elsif total > 4000 && total <= 5500
          item['percentual_comissao'] = (item['tipo_comissao'].eql? "COMISSAO") ? 15 : 7.5
          item['comissao'] =  format_value_without_simbol((item['mensalidade'].to_d * 15) / 100) if item['tipo_comissao'].eql? "COMISSAO"
          item['comissao'] =  format_value_without_simbol((item['mensalidade'].to_d * 7.5) / 100) if item['tipo_comissao'].eql? "DESCONTO"
        elsif total > 5500 && total <= 7000
          item['percentual_comissao'] = (item['tipo_comissao'].eql? "COMISSAO") ? 20 : 10
          item['comissao'] =  format_value_without_simbol((item['mensalidade'].to_d * 20) / 100) if item['tipo_comissao'].eql? "COMISSAO"
          item['comissao'] =  format_value_without_simbol((item['mensalidade'].to_d * 10) / 100) if item['tipo_comissao'].eql? "DESCONTO"
        elsif total > 7000 && total <= 8000
          item['percentual_comissao'] = (item['tipo_comissao'].eql? "COMISSAO") ? 25 : 12.5
          item['comissao'] =  format_value_without_simbol((item['mensalidade'].to_d * 25) / 100) if item['tipo_comissao'].eql? "COMISSAO"
          item['comissao'] =  format_value_without_simbol((item['mensalidade'].to_d * 12.5) / 100) if item['tipo_comissao'].eql? "DESCONTO"
        elsif total > 8000
          item['percentual_comissao'] = (item['tipo_comissao'].eql? "COMISSAO") ? 30 : 15
          item['comissao'] =  format_value_without_simbol((item['mensalidade'].to_d * 30) / 100) if item['tipo_comissao'].eql? "COMISSAO"
          item['comissao'] =  format_value_without_simbol((item['mensalidade'].to_d * 15) / 100) if item['tipo_comissao'].eql? "DESCONTO"
        end
      end
    end

    #marketing
    if @tipo.eql? "11"
      financeiro_cnpjs = @hash.map { |h| h["cpfcnpj"] }
      razao_social_clientes = @hash.map { |h| h["razaosocial"] }
      cnpj_fechamento = Fechamento.joins(:tipo_fechamento).joins('LEFT JOIN clientes ON clientes.id = fechamentos.cliente_id').where("tipo_fechamentos.descricao = 'CAMPANHA' AND (clientes.cnpj IN (?) OR clientes.razao_social IN (?))", financeiro_cnpjs, razao_social_clientes).pluck(:cnpj)
      @hash = @hash.select { |key, value| ( cnpj_fechamento.include? key['cpfcnpj'] ) }

      total = calcularTotal(@hash)
      @hash.each do |item|
        if total <= 5000
          item['percentual_comissao'] = (item['tipo_comissao'].eql? "COMISSAO") ? 7 : 3.50
          item['comissao'] =  format_value_without_simbol((item['mensalidade'].to_d * 7) / 100) if item['tipo_comissao'].eql? "COMISSAO"
          item['comissao'] =  format_value_without_simbol((item['mensalidade'].to_d * 3.50) / 100) if item['tipo_comissao'].eql? "DESCONTO"
        elsif total > 5000 && total <= 15000
          item['percentual_comissao'] = (item['tipo_comissao'].eql? "COMISSAO") ? 10 : 5
          item['comissao'] =  format_value_without_simbol((item['mensalidade'].to_d * 10) / 100) if item['tipo_comissao'].eql? "COMISSAO"
          item['comissao'] =  format_value_without_simbol((item['mensalidade'].to_d * 5) / 100) if item['tipo_comissao'].eql? "DESCONTO"
        elsif total > 15000
          item['percentual_comissao'] = (item['tipo_comissao'].eql? "COMISSAO") ? 12 : 6
          item['comissao'] =  format_value_without_simbol((item['mensalidade'].to_d * 12) / 100) if item['tipo_comissao'].eql? "COMISSAO"
          item['comissao'] =  format_value_without_simbol((item['mensalidade'].to_d * 6) / 100) if item['tipo_comissao'].eql? "DESCONTO"
        end
      end
    end

    if @tipo.eql? "9"
      vendas = Marshal.load(Marshal.dump(@hash))
      vendas = vendas.select { |key, value| ( key['vendedor_id'].to_i.eql? params[:colaborador].to_i) }
      implantacao = Marshal.load(Marshal.dump(@hash))
      implantacao = @hash.select { |key, value| ( key['implantador_id'].to_i.eql? params[:colaborador].to_i) }
      vendas.each do |item|
        item['tipo_venda'] = 'VENDA'
        item['percentual_comissao'] = (item['tipo_comissao'].eql? "COMISSAO") ? 15 : 7.5
        item['comissao'] =  format_value_without_simbol((item['mensalidade'].to_d * 15) / 100) if item['tipo_comissao'].eql? "COMISSAO"
        item['comissao'] =  format_value_without_simbol((item['mensalidade'].to_d * 7.5) / 100) if (item['tipo_comissao'].eql? "DESCONTO") && (item['tipo_venda'] != 'ADMINISTRATIVO')
      end
      implantacao.each do |item|
        item['tipo_venda'] = 'IMPLANTAÇÃO'
        item['percentual_comissao'] = (item['tipo_comissao'].eql? "COMISSAO") ? 15 : 7.5
        item['comissao'] =  format_value_without_simbol((item['mensalidade'].to_d * 15) / 100) if item['tipo_comissao'].eql? "COMISSAO"
        item['comissao'] =  format_value_without_simbol((item['mensalidade'].to_d * 7.5) / 100) if (item['tipo_comissao'].eql? "DESCONTO") && (item['tipo_venda'] != 'ADMINISTRATIVO')
      end
      @hash =  vendas + implantacao
      @hash = @hash.sort_by { |hsh| hsh['tipo_venda'] }
      #@hash =  @hash + administrativo
    end

    if @tipo.eql? "10"
      vendas = Marshal.load(Marshal.dump(@hash))
      vendas = vendas.select { |key, value| ( key['vendedor_id'].to_i.eql? params[:colaborador_tipo10].to_i) }
      vendas.each do |empr|
        processar_informacoes_comissao_vendedores(empr, params[:colaborador_tipo10])
        empr['tipo_venda'] = 'VENDA'
      end
      supervisao = Marshal.load(Marshal.dump(@hash))

      delete_list = []
      supervisao.each do |empr|
        if empr['tipo_comissao'].eql? "DESCONTO"
          if !empr['data_pagamento_desc'].nil? && TimeDifference.between(Time.now, empr['data_pagamento_desc']).in_days.to_i > 90
            delete_list.push(empr)
          end
        end
        colaborador = User.where(id: params[:colaborador_tipo10]).first
        empr['usuario'] = colaborador.name.upcase if colaborador.present?
        empr['tipo_venda'] = 'SUPERVISAO'
      end

      delete_list.each do | del | 
        supervisao.delete_at(supervisao.index(del))
      end

      calcular_supervisao_comissao(supervisao)

      @hash =  vendas + supervisao
      # @hash = @hash.sort_by { |hsh| hsh['tipo_venda'] }.reverse
    end
    
    if @hash.blank?
      if ["3", "6", "7"].include? @tipo
        vendedor = User.where(id: params[:vendedor]).first
        @hash << {"usuario" => vendedor ? vendedor.name.upcase : '', "tipo" => @tipo, "detail" => false}
      elsif ["4", "8"].include? @tipo
        implantador = User.where(id: params[:implantador]).first
        @hash << {"usuario" => implantador ? implantador.name.upcase : '', "tipo" => @tipo, "detail" => false}
      elsif @tipo.eql? "5"
        acompanhador = User.where(id: params[:acompanhador]).first
        @hash << {"usuario" => acompanhador ? acompanhador.name.upcase : '', "tipo" => @tipo, "detail" => false}
      elsif @tipo.eql? '10'
        acompanhador = User.where(id: params[:colaborador_tipo10]).first
        @hash << {"usuario" => acompanhador ? acompanhador.name.upcase : '', "tipo" => @tipo, "detail" => false}
      elsif @tipo.eql? '11'
        acompanhador = User.where(id: params[:colaborador]).first
        @hash << {"usuario" => acompanhador ? acompanhador.name.upcase : '', "tipo" => @tipo, "detail" => false}
      else
        @hash << {"usuario" => 'RAUL POLITOWSKI', "tipo" => @tipo, "detail" => false}
      end
    end
    
    respond_to do |format|
      format.xlsx {
        response.headers[
            'Content-Disposition'
        ] = "attachment; filename=comissoes.xlsx"
      }
      format.json { render json: @hash }
      format.html { render json: @hash }
    end
  end

  def analise_desistencias

  end

  def analise_desistencias_print
    data_inicial = Date.strptime(params[:data_inicio], "%d/%m/%Y")
    data_final = Date.strptime(params[:data_fim], "%d/%m/%Y")
    empresa = params[:empresa_id].join(', ')
    response = RestClient::Request.execute(method: :post,  url: "http://127.0.0.1:3000/generate_pdf",
                                           payload: {name: 'analise_desistencias', connection: 'analise_desistencias',
                                                     parameters: {data_inicial: data_inicial.strftime("%Y-%m-%d"),
                                                                  data_final: data_final.strftime("%Y-%m-%d"),
                                                                  tipo: params[:tipo],
                                                                  vendedor: (params[:vendedor].present? ? params[:vendedor] : '') ,
                                                                  empresa: empresa,
                                                                  acompanhador: (params[:acompanhamento].present? ? params[:acompanhamento] : '') ,
                                                                  implantador: (params[:implantador].present? ? params[:implantador] : '') ,
                                                                  dias_cliente: params[:dias_cliente],
                                                     }}.to_json,
                                           headers: {cache_control: "no-cache", content_type: "application/json"},
                                           timeout: 120, read_timeout: 120, open_timeout: 240)

    send_data response.body, filename: "analise_desistencias.pdf", type: :pdf, disposition: 'inline'
  end

  def analise_desistencias_json
    connection = Financeiro::HonorarioMensal.connection
    lista = connection.select_all RelatoriosHelper.analise_desistencias params[:data_inicial], params[:data_final], params[:dias_cliente], params[:tipo], params[:empresa]

    hash = lista.to_hash
    hash.each do |empr|
      processar_informacoes_business(empr)
    end

    hash = hash.select { |key, value| params[:vendedor] == key['vendedor_id'].to_s } if params[:vendedor].present?
    hash = hash.select { |key, value| params[:implantador] == key['implantador_id'].to_s } if params[:implantador].present?

    render json: hash
  end

  def analise_bloqueados_paralisados

  end

  def analise_bloqueados_paralisados_print
    empresa = params[:empresa_id].join(', ')
    response = RestClient::Request.execute(method: :post,  url: "http://127.0.0.1:3000/generate_pdf",
                                           payload: {name: 'analise_bloqueados_paralisados', connection: 'analise_bloqueados_paralisados',
                                                     parameters: {tipo: params[:tipo],
                                                                  empresa: empresa,
                                                                  dias_cliente: params[:dias_cliente],
                                                                  dias_bloqueado_min: params[:dias_bloqueado_min],
                                                                  dias_bloqueado_max: params[:dias_bloqueado_max],
                                                                  dias_paralizado: params[:dias_paralizado],
                                                                  detalhado: params[:detalhado],
                                                                  ordenar: params[:ordenar]
                                                     }}.to_json,
                                           headers: {cache_control: "no-cache", content_type: "application/json"},
                                           timeout: 120, read_timeout: 120, open_timeout: 240)

    send_data response.body, filename: "analise_bloqueados_paralisados.pdf", type: :pdf, disposition: 'inline'
  end

  def analise_bloqueados_paralisados_json
    connection = Financeiro::HonorarioMensal.connection
    lista = connection.select_all RelatoriosHelper.analise_bloqueados_paralisados params[:dias_cliente], params[:tipo], params[:empresa], params[:dias_paralizado], params[:detalhado]

    hash = lista.to_hash
    hash.each do |empr|
      processar_api_informacoes(empr)
      processar_informacoes_business(empr)
    end

    if params[:dias_bloqueado].present?
      hash = hash.select { |key, value|
        key['dias_bloqueado_qtd'].to_i >= params[:dias_bloqueado].to_i
      }
    end

    render json: hash
  end

  def cobranca_primeira_mensalidade

  end

  def cobranca_primeira_mensalidade_print
    empresa = params[:empresa_id].join(', ')
    response = RestClient::Request.execute(method: :post,  url: "http://127.0.0.1:3000/generate_pdf",
                                           payload: {name: 'cobranca_primeira_mensalidade', connection: 'cobranca_primeira_mensalidade',
                                                     parameters: {empresa: empresa,
                                                                  vendedor: params[:vendedor],
                                                                  ignorar_parceiro: (params[:ignorar_parceiro].present? ? params[:ignorar_parceiro] : "")
                                                     }}.to_json,
                                           headers: {cache_control: "no-cache", content_type: "application/json"},
                                           timeout: 120, read_timeout: 120, open_timeout: 240)

    send_data response.body, filename: "cobranca_primeira_mensalidade.pdf", type: :pdf, disposition: 'inline'
  end

  def cobranca_primeira_mensalidade_json
    connection = Financeiro::HonorarioMensal.connection
    lista = connection.select_all DashboardsResultadosTabelasHelper.table_primeira_parcela nil,
                                                                                           params[:empresa],
                                                                                           nil,
                                                                                           nil,
                                                                                           2
    hash = lista.to_hash
    hash.each do |empr|
      processar_api_informacoes(empr)
      processar_informacoes_business(empr)
      empr['vendedor'] = "Parceiro" if empr['vendedor_id'].blank?
    end
    
    hash = hash.select { |key, value| params[:vendedor] == key['vendedor_id'].to_s } if params[:vendedor].present?
    hash = hash.select { |key, value| key['vendedor_id'] != "" } if params[:ignorar_parceiro] != ""

    render json: hash
  end

  def contratos_assinados_print
    data_inicial = Date.strptime(params[:data_inicio], "%d/%m/%Y")
    data_final = Date.strptime(params[:data_fim], "%d/%m/%Y")
    response = RestClient::Request.execute(method: :post,  url: "http://127.0.0.1:3000/generate_pdf",
                                           payload: {name: 'contratos_assinados', connection: 'contratos_assinados',
                                                     parameters: {data_inicial: data_inicial.strftime("%Y-%m-%d"),
                                                                  data_final: data_final.strftime("%Y-%m-%d"),
                                                                  tipo: params[:tipo],
                                                                  vendedor: (params[:vendedor].present? ? params[:vendedor] : '') ,
                                                                  implantador: (params[:implantador].present? ? params[:implantador] : '') ,
                                                                  efetivos: params[:efetivos]
                                                     }}.to_json,
                                           headers: {cache_control: "no-cache", content_type: "application/json"},
                                           timeout: 120, read_timeout: 120, open_timeout: 240)

    send_data response.body, filename: "contratos_assinados.pdf", type: :pdf, disposition: 'inline'
  end

  def contratos_assinados_json
    connection = ActiveRecord::Base.connection
    efetivo = nil
    efetivo = 'true' if params[:efetivos].eql? "true"
    status = nil
    if params[:tipo].eql? '1' #aguardando
      status = [0,1,2,10]
    elsif params[:tipo].eql? '2' #em andamento
      status = [3,4,5,6]
    elsif params[:tipo].eql? '3' #concluido
      status = [9]
    else
      status = []
    end
    
    lista = connection.select_all RelatoriosHelper.relatorio_contratos_assinados params[:data_inicial], params[:data_final], efetivo, status
    hash = lista.to_hash
      
    hash = hash.select { |key, value| params[:vendedor] == key['vendedor_id'].to_s } if params[:vendedor].present?
    hash = hash.select { |key, value| params[:implantador] == key['implantador_id'].to_s } if params[:implantador].present?

    render json: hash
  end

  private

  def processar_informacoes_business(empresa)
    cliente = Cliente.find_by_cnpj empresa['cpfcnpj'].strip
    if cliente.present? && cliente.id == 4215599
      cliente = Cliente.find 4211343
    end
    if cliente.present? && cliente.id == 3280100
      cliente = Cliente.find 3277728
    end
    if cliente.present? && cliente.fechamento.present?
        proposta = cliente.fechamento.proposta
        implantacao = Implantacao.find_by_cliente_id cliente.id
        acompanhamento = Acompanhamento.find_by_cliente_id cliente.id

        empresa['sistema'] = (proposta.present? ? proposta.pacote.sistema.nome : '') unless empresa['sistema'].present?
        empresa['vendedor'] = cliente.fechamento.present? && cliente.fechamento.user.present? ? cliente.fechamento.user.name : ''
        empresa['vendedor_id'] = cliente.fechamento.present? && cliente.fechamento.user.present? ? cliente.fechamento.user.id : ''
        empresa['implantador'] = implantacao.present? && implantacao.user.present? ? implantacao.user.name : ''
        empresa['implantador_id'] = implantacao.present? && implantacao.user.present? ? implantacao.user.id : ''
        empresa['acompanhador'] = acompanhamento.present? && acompanhamento.user.present? ? acompanhamento.user.name : ''
        empresa['acompanhador_id'] = acompanhamento.present? && acompanhamento.user.present? ? acompanhamento.user.id : ''
      else
        empresa['sistema'] = '' unless empresa['sistema'].present?
        empresa['vendedor'] = ''
        empresa['vendedor_id'] = ''
        empresa['implantador'] = ''
        empresa['implantador_id'] = ''
        empresa['acompanhador'] = ''
        empresa['acompanhador_id'] = ''
      end
  end

  def parse_valor_rails(value)
    value.gsub('R$', '').gsub('.', '').gsub(',', '.').to_d unless value.nil?
  end

  def parse_valor_rails_string(value)
    value.gsub('R$', '').gsub('.', '').gsub(',', '.') unless value.nil?
  end

  def format_value_without_simbol(value)
    number_to_currency(value, separator: '.', delimiter: '', unit: '').to_s.strip
  end

  def processar_informacoes_comissao_coordenardor(params, empr, tipo_relatorio)
    empr['usuario'] = 'RAUL POLITOWSKI'
    if empr['sistema'].upcase.include? "FISCAL"
      if empr['vendedor_id'].eql? 4
        empr['regiao'] = '4'
      end
    end
    case empr['regiao']
      when '1'
        empr['regiao_desc'] = 'LOCAL'
        empr['percentual_comissao'] = 0
        empr['comissao'] =  params[:valor_local] if empr['tipo_comissao'].eql? "COMISSAO"
        empr['comissao'] =  (params[:valor_local].to_d/2.to_d) if empr['tipo_comissao'].eql? "DESCONTO"
      when '2'
        empr['regiao_desc'] = 'REGIONAL'
        empr['percentual_comissao'] = 0
        empr['comissao'] =  params[:valor_regional] if empr['tipo_comissao'].eql? "COMISSAO"
        empr['comissao'] =  "0" if empr['tipo_comissao'].eql? "DESCONTO"
      when '4'
        empr['regiao_desc'] = 'ESCRITORIOS'
        empr['comissao'] =  format_value_without_simbol((empr['mensalidade'].to_d * params[:percentual_escritorios].to_d) / 100)
        empr['percentual_comissao'] = params[:percentual_escritorios]
    end
  end

  def processar_informacoes_comissao_vendedores(empr, vendedor_id)
      vendedor = User.where(id: vendedor_id).first
      if vendedor && ([1,8].include? vendedor.tipo_comissao)
        empr['usuario'] = vendedor.name.upcase
        empr['comissao'] =  format_value_without_simbol((empr['mensalidade'].to_d * 40) / 100) if empr['tipo_comissao'].eql? "COMISSAO"
        empr['comissao'] =  format_value_without_simbol((empr['mensalidade'].to_d * 20) / 100) if empr['tipo_comissao'].eql? "DESCONTO"
        empr['percentual_comissao'] = (empr['tipo_comissao'].eql? "COMISSAO") ? 40 : 20
      end
  end

  def processar_informacoes_comissao_marketing(empr)
    responsavel = User.where(id: params[:colaborador]).first
    if responsavel && (responsavel.tipo_comissao.eql? 9)
      empr['usuario'] = responsavel.name.upcase
    end
  end

  def processar_informacoes_comissao_implantacao(params, empr)
    implantador = User.where(id: params[:implantador]).first
    if implantador && (implantador.tipo_comissao.eql? 2)
      empr['usuario'] = implantador.name.upcase
      empr['comissao'] =  format_value_without_simbol((empr['mensalidade'].to_d * 30) / 100) if empr['tipo_comissao'].eql? "COMISSAO"
      empr['comissao'] =  format_value_without_simbol((empr['mensalidade'].to_d * 15) / 100) if empr['tipo_comissao'].eql? "DESCONTO"
      empr['percentual_comissao'] = (empr['tipo_comissao'].eql? "COMISSAO") ? 30 : 15
    end
  end

  def processar_informacoes_comissao_acompanhamento(params, empr)
    acompanhador = User.where(id: params[:acompanhador]).first
    if acompanhador && (acompanhador.tipo_comissao.eql? 3)
      empr['usuario'] = acompanhador.name.upcase
    end
  end

  def processar_informacoes_comissao_vendedor_meta(params, empr)
    vendedor = User.where(id: params[:vendedor]).first
    if vendedor && (vendedor.tipo_comissao.eql? 4)
      empr['usuario'] = vendedor.name.upcase      
    end
  end

  def processar_informacoes_comissao_estagio(params, empr)
    colaborador = User.where(id: params[:vendedor]).first
    if colaborador && (colaborador.tipo_comissao.eql? 5)
      empr['usuario'] = colaborador.name.upcase
      empr['comissao'] =  format_value_without_simbol((empr['mensalidade'].to_d * 20) / 100)
      empr['percentual_comissao'] = 20
    end
  end

  def processar_informacoes_comissao_implantador_meta(params, empr)
    implantador = User.where(id: params[:implantador]).first
    if implantador && (implantador.tipo_comissao.eql? 6)
      empr['usuario'] = implantador.name.upcase      
    end
  end

  def processar_api_informacoes( empr )
    company = Api::Company.find_by_cnpj_and_system empr['cpfcnpj'], empr['sistema']
    company = Api::Company.find_by_cnpj empr['cpfcnpj'] if company.nil?

    if company.nil?
      empr['ultimo_login_qtd'] = 0
      empr['ultimo_login'] = nil
      empr['versao'] = nil
      empr['data_bloqueio'] = nil
      empr['dias_bloqueado'] = nil
      empr['dias_bloqueado_qtd'] = nil
      empr['data_ultimo_login'] = nil
    else
      if company.last_login.nil?
        qtdDias = 0
      else
        qtdDias = (TimeDifference.between(Time.now,  company.last_login).in_days).ceil
      end

      empr['ultimo_login_qtd'] = qtdDias
      empr['ultimo_login'] = qtdDias < 2 ? "#{qtdDias} dia" : "#{qtdDias} dias"
      empr['versao'] = company.version
      empr['data_bloqueio'] = company.lock_date.strftime("%d/%m/%Y") if company.lock_date.present?

      qtdDiasBloqueado = (TimeDifference.between(Time.now,  company.lock_date).in_days).ceil
      qtdDiasBloqueado =  company.lock_date > Time.now ? qtdDiasBloqueado * -1 : qtdDiasBloqueado
      empr['dias_bloqueado'] = qtdDiasBloqueado < 2 ? "#{qtdDiasBloqueado} dia" : "#{qtdDiasBloqueado} dias"
      empr['dias_bloqueado_qtd'] = qtdDiasBloqueado

      empr['data_ultimo_login'] = company.last_login.strftime("%d/%m/%Y") if company.last_login.present?
    end
  end
  
  def processar_informacoes_comissao_administrativo(params, empr)
    colaborador = User.where(id: params[:colaborador]).first
    if colaborador && (colaborador.tipo_comissao.eql? 7)
      empr['usuario'] = colaborador.name.upcase
    end
  end

  def calcularTotal(hash)
    total = 0
    hash.each {|h|
      if h['tipo_comissao'].eql? "COMISSAO"
        total += h['mensalidade'].to_d
      end
    }
    return total
  end

  def calcular_acompanhamento_comissao(hash)
    total = calcularTotal(hash)
    hash.each do |item|
      if total <= 12000
        item['percentual_comissao'] = (item['tipo_comissao'].eql? "COMISSAO") ? 10 : 5
        item['comissao'] =  format_value_without_simbol((item['mensalidade'].to_d * 10) / 100) if item['tipo_comissao'].eql? "COMISSAO"
        item['comissao'] =  format_value_without_simbol((item['mensalidade'].to_d * 5) / 100) if item['tipo_comissao'].eql? "DESCONTO"
      elsif total > 12000 && total <= 15000
        item['percentual_comissao'] = (item['tipo_comissao'].eql? "COMISSAO") ? 12 : 6
        item['comissao'] =  format_value_without_simbol((item['mensalidade'].to_d * 12) / 100) if item['tipo_comissao'].eql? "COMISSAO"
        item['comissao'] =  format_value_without_simbol((item['mensalidade'].to_d * 6) / 100) if item['tipo_comissao'].eql? "DESCONTO"
      elsif total > 15000 && total <= 21000
        item['percentual_comissao'] = (item['tipo_comissao'].eql? "COMISSAO") ? 15 : 7.5
        item['comissao'] =  format_value_without_simbol((item['mensalidade'].to_d * 15) / 100) if item['tipo_comissao'].eql? "COMISSAO"
        item['comissao'] =  format_value_without_simbol((item['mensalidade'].to_d * 7.5) / 100) if item['tipo_comissao'].eql? "DESCONTO"
      elsif total > 21000
        item['percentual_comissao'] = (item['tipo_comissao'].eql? "COMISSAO") ? 20 : 10
        item['comissao'] =  format_value_without_simbol((item['mensalidade'].to_d * 20) / 100) if item['tipo_comissao'].eql? "COMISSAO"
        item['comissao'] =  format_value_without_simbol((item['mensalidade'].to_d * 10) / 100) if item['tipo_comissao'].eql? "DESCONTO"
      end
    end
  end

  def calcular_supervisao_comissao(hash)
    total = calcularTotal(hash)
    hash.each do |item|
      if total <= 5000
        item['percentual_comissao'] = (item['tipo_comissao'].eql? "COMISSAO") ? 7 : 3.5
        item['comissao'] =  format_value_without_simbol((item['mensalidade'].to_d * 7) / 100) if item['tipo_comissao'].eql? "COMISSAO"
        item['comissao'] =  format_value_without_simbol((item['mensalidade'].to_d * 3.5) / 100) if item['tipo_comissao'].eql? "DESCONTO"
      elsif total > 5000 && total < 8000
        item['percentual_comissao'] = (item['tipo_comissao'].eql? "COMISSAO") ? 10 : 5
        item['comissao'] =  format_value_without_simbol((item['mensalidade'].to_d * 10) / 100) if item['tipo_comissao'].eql? "COMISSAO"
        item['comissao'] =  format_value_without_simbol((item['mensalidade'].to_d * 5) / 100) if item['tipo_comissao'].eql? "DESCONTO"
      elsif total >= 8000 && total < 10000
        item['percentual_comissao'] = (item['tipo_comissao'].eql? "COMISSAO") ? 12 : 6
        item['comissao'] =  format_value_without_simbol((item['mensalidade'].to_d * 12) / 100) if item['tipo_comissao'].eql? "COMISSAO"
        item['comissao'] =  format_value_without_simbol((item['mensalidade'].to_d * 6) / 100) if item['tipo_comissao'].eql? "DESCONTO"
      elsif total >= 10000
        item['percentual_comissao'] = (item['tipo_comissao'].eql? "COMISSAO") ? 14 : 7
        item['comissao'] =  format_value_without_simbol((item['mensalidade'].to_d * 14) / 100) if item['tipo_comissao'].eql? "COMISSAO"
        item['comissao'] =  format_value_without_simbol((item['mensalidade'].to_d * 7) / 100) if item['tipo_comissao'].eql? "DESCONTO"
      end
    end
  end
end

