class DashboardsController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def empresas
    importacao = Importacao.where(empresa: current_empresa).where('total > 0').order(data_importacao: :desc).limit(1).first
    @data = importacao.data_importacao if importacao.present?
    @data ||= Date.new
  end

  def implantacoes

  end

  def acompanhamentos

  end

  def funil

  end


  def get_ligacoes_dias
    connection = ActiveRecord::Base.connection
    sql = nil
    if params[:flag].eql? "true"
      sql = "with periodo as(
              select distinct a::date as dia
              from generate_series(current_date - interval '9 days', current_date, '24 hours') a
              order by dia
            ),
            sql as (
              select x.qtd, x.dia
                    from(
                  select l.data_inicio::date as dia, count(l.id) as qtd
                  from ligacoes l
                  left join clientes cliente on cliente.id = l.cliente_id
                  left join cidades cidade on cidade.id = cliente.cidade_id
                  where  l.empresa_id in (" + ApplicationHelper.get_empresas_by_codigo(params[:empresa_id]) + ")
                    and (#{ params[:estado_id].present? ? (ApplicationHelper.get_estado_by_codigo(params[:estado_id])) : 'null'} is null or cidade.estado_id = #{ params[:estado_id].present? ? (ApplicationHelper.get_estado_by_codigo(params[:estado_id])) : 'null'})
                    and l.data_fim is not null
                    and l.tipo = 0
                  group by dia
                  order by dia desc
                    ) x limit 7
            )
            select TO_CHAR(periodo.dia, 'DD/MM/YYYY') as dia, coalesce(sql.qtd, 0) as qtd
            from periodo
            left join sql on sql.dia = periodo.dia"
    else
      sql = "
      with periodo as(
              select distinct a::date as dia
              from generate_series(current_date - interval '9 days', current_date, '24 hours') a
              order by dia
      ),
      qtd_clientes_dias as (
              select l.data_inicio::date as dia, count(cliente_id), razao_social
              from ligacoes l
              left join clientes cliente on cliente.id = l.cliente_id
              left join cidades cidade on cidade.id = cliente.cidade_id
              where  l.empresa_id in (" + ApplicationHelper.get_empresas_by_codigo(params[:empresa_id]) + ")
                  and (#{ params[:estado_id].present? ? (ApplicationHelper.get_estado_by_codigo(params[:estado_id])) : 'null'} is null or cidade.estado_id = #{ params[:estado_id].present? ? (ApplicationHelper.get_estado_by_codigo(params[:estado_id])) : 'null'})
                  and l.data_fim is not null
                  and l.tipo = 0
              group by dia, razao_social
      ),
      qtd_ligacoes as (
              select dia, count(razao_social) as qtd
              from qtd_clientes_dias
              group by dia
              order by dia desc
              limit 7
      )
      select TO_CHAR(periodo.dia, 'DD/MM/YYYY') as dia, coalesce(qtd_ligacoes.qtd, 0) as qtd
      from periodo
      left join qtd_ligacoes on qtd_ligacoes.dia = periodo.dia
      "
    end

    @ligacoes = connection.select_all sql

    render json: @ligacoes
  end

  def get_ligacoes_dia
    connection = ActiveRecord::Base.connection
    sql = nil
    if params[:flag].eql? "true"
      sql = "select u.name as label, count(l.id) as value, u.id
            from ligacoes l
            inner join users u on l.user_id = u.id
            left join clientes cliente on cliente.id = l.cliente_id
            left join cidades cidade on cidade.id = cliente.cidade_id
            where data_inicio::date = '" +  params[:data] + "'
              and data_fim is not null
              and l.tipo = 0
              and l.empresa_id in (" + ApplicationHelper.get_empresas_by_codigo(params[:empresa_id]) + ")
              and (#{ params[:estado_id].present? ? (ApplicationHelper.get_estado_by_codigo(params[:estado_id])) : 'null'} is null or cidade.estado_id = #{ params[:estado_id].present? ? (ApplicationHelper.get_estado_by_codigo(params[:estado_id])) : 'null'})
              group by u.name, u.color, u.id
              order by count(l.id)
            "
    else
      sql = "
          with qtd_clientes_dias as (
            select l.user_id, count(cliente_id), razao_social
            from ligacoes l
            left join clientes cliente on cliente.id = l.cliente_id
            left join cidades cidade on cidade.id = cliente.cidade_id
            where  l.empresa_id in (" + ApplicationHelper.get_empresas_by_codigo(params[:empresa_id]) + ")
                and (#{ params[:estado_id].present? ? (ApplicationHelper.get_estado_by_codigo(params[:estado_id])) : 'null'} is null or cidade.estado_id = #{ params[:estado_id].present? ? (ApplicationHelper.get_estado_by_codigo(params[:estado_id])) : 'null'})
                and data_inicio::date = '" +  params[:data] + "'
                and l.data_fim is not null
            group by l.user_id, razao_social
          )
          select u.name as label, count(l.razao_social) as value, u.id
            from qtd_clientes_dias l
            inner join users u on l.user_id = u.id            
            group by u.name, u.color, u.id
            order by count(l.razao_social)
      "
    end

    @ligacoes = connection.select_all sql

    render json: @ligacoes
  end

  def get_ligacoes_status
    connection = ActiveRecord::Base.connection

    sql = "select substring(u.descricao from 0 for 20) as label, count(l.id) as value, u.id as id
            from ligacoes l
            inner join status u on l.status_cliente_id = u.id
            left join clientes cliente on cliente.id = l.cliente_id
            left join cidades cidade on cidade.id = cliente.cidade_id
            where data_inicio::date = '" +  params[:data] + "'
              and data_fim is not null
              and l.tipo = 0
              and l.empresa_id in (" + ApplicationHelper.get_empresas_by_codigo(params[:empresa_id]) + ")
              and (#{ params[:estado_id].present? ? (ApplicationHelper.get_estado_by_codigo(params[:estado_id])) : 'null'} is null or cidade.estado_id = #{ params[:estado_id].present? ? (ApplicationHelper.get_estado_by_codigo(params[:estado_id])) : 'null'})
              and (user_id = " + (params[:user_id].present? ? params[:user_id] : 'null') + " or " + (params[:user_id].present? ? params[:user_id] : 'null') +  " is null)
              and (status_ligacao_id = " + (params[:status_ligacao_id].present? ? params[:status_ligacao_id] : 'null') + " or " + (params[:status_ligacao_id].present? ? params[:status_ligacao_id] : 'null') +  " is null)
              group by u.descricao, u.id
              order by count(l.id)
            "

    @ligacoes = connection.select_all sql
    
    render json: @ligacoes
  end

  def get_ligacoes_status_ligacao
    connection = ActiveRecord::Base.connection

    sql = "select substring(u.descricao from 0 for 20) as label, count(l.id) as value, u.id as id
            from ligacoes l
            inner join status_ligacoes u on l.status_ligacao_id = u.id
            left join clientes cliente on cliente.id = l.cliente_id
            left join cidades cidade on cidade.id = cliente.cidade_id
            where data_inicio::date = '" +  params[:data] + "'
              and data_fim is not null
              and l.tipo = 0
              and l.empresa_id in (" + ApplicationHelper.get_empresas_by_codigo(params[:empresa_id]) + ")
              and (#{ params[:estado_id].present? ? (ApplicationHelper.get_estado_by_codigo(params[:estado_id])) : 'null'} is null or cidade.estado_id = #{ params[:estado_id].present? ? (ApplicationHelper.get_estado_by_codigo(params[:estado_id])) : 'null'})
              and (user_id = " + (params[:user_id].present? ? params[:user_id] : 'null') + " or " + (params[:user_id].present? ? params[:user_id] : 'null') +  " is null)
              group by u.descricao, u.id
              order by count(l.id)
            "

    @ligacoes = connection.select_all sql

    render json: @ligacoes
  end

  def get_clientes_by_status

    connection = ActiveRecord::Base.connection

    sql = "select cliente.cnpj, cliente.razao_social, cidade.nome || '-' || estado.sigla as cidade, estado.sigla as estado,
                  to_char(l.data_inicio, 'DD/MM/YYYY HH24:MI') as data_inicio_formatada, us.name as usuario, l.observacao, 
                  status.descricao as status_cliente
            from ligacoes l
            left join status_ligacoes u on l.status_ligacao_id = u.id
            left join clientes cliente on cliente.id = l.cliente_id
            left join status on status.id = cliente.status_id
            left join cidades cidade on cidade.id = cliente.cidade_id
            left join estados estado on estado.id = cidade.estado_id
            left join users us on us.id = l.user_id
            where data_inicio::date = '" +  params[:dia] + "'
              and data_fim is not null
              and l.tipo = 0
              and l.empresa_id in (" + ApplicationHelper.get_empresas_by_codigo(params[:empresa_id]) + ")
              and (#{ params[:estado_id].present? ? (ApplicationHelper.get_estado_by_codigo(params[:estado_id])) : 'null'} is null or cidade.estado_id = #{ params[:estado_id].present? ? (ApplicationHelper.get_estado_by_codigo(params[:estado_id])) : 'null'})
              and (#{ params[:usuario_id] } is null or #{ params[:usuario_id] } = l.user_id)
              and (#{ params[:status].present? ? params[:status] : 'null'  } is null or #{ params[:status].present? ? params[:status] : 'null' } = l.status_cliente_id)
              and (#{ params[:status_ligacao_id].present? ? params[:status_ligacao_id] : 'null' } is null or #{ params[:status_ligacao_id].present? ? params[:status_ligacao_id] : 'null' } = l.status_ligacao_id)
              order by l.data_inicio
            "

    @ligacoes = connection.select_all sql

    render json: @ligacoes
  end

  def get_clientes_by_status_ligacao
    connection = ActiveRecord::Base.connection

    sql = "select cliente.cnpj, cliente.razao_social, cidade.nome || '-' || estado.sigla as cidade,
                  to_char(l.data_inicio, 'DD/MM/YYYY HH24:MI') as data_inicio_formatada, us.name as usuario, l.observacao,
                  status.descricao as status_cliente
            from ligacoes l
            inner join status_ligacoes u on l.status_ligacao_id = u.id
            left join clientes cliente on cliente.id = l.cliente_id
            left join status on status.id = cliente.status_id
            left join cidades cidade on cidade.id = cliente.cidade_id
            left join estados estado on estado.id = cidade.estado_id
            left join users us on us.id = l.user_id
            where data_inicio::date = '" +  params[:dia] + "'
              and data_fim is not null
              and l.tipo = 0
              and l.empresa_id in (" + ApplicationHelper.get_empresas_by_codigo(params[:empresa_id]) + ")
              and (#{ params[:estado_id].present? ? (ApplicationHelper.get_estado_by_codigo(params[:estado_id])) : 'null'} is null or cidade.estado_id = #{ params[:estado_id].present? ? (ApplicationHelper.get_estado_by_codigo(params[:estado_id])) : 'null'})
              and (#{ params[:usuario_id] } is null or #{ params[:usuario_id] } = l.user_id)
              and (#{ params[:status] } is null or #{ params[:status] } = l.status_ligacao_id)
              order by l.data_inicio desc
            "

    @ligacoes = connection.select_all sql

    render json: @ligacoes
  end

  def get_fechamentos
    user = params[:user_id]
    user = current_user.id if !current_user.admin?

    empresa = params[:empresa_id]
    empresa = current_empresa.id.to_s if !current_user.admin?
    connection = ActiveRecord::Base.connection
    @fechamentos = connection.select_all DashboardsPainelVendasHelper.get_fechamentos params[:data_inicio], params[:data_fim],
                                                                                      empresa, params[:estado],
                                                                                      user, params[:status_id], params[:flag]

    render json: @fechamentos
  end

  def get_fechamentos_by_sistemas
    user = params[:user_id]
    user = current_user.id if !current_user.admin?

    empresa = params[:empresa_id]
    empresa = current_empresa.id.to_s if !current_user.admin?

    connection = ActiveRecord::Base.connection
    @fechamentos = connection.select_all DashboardsPainelVendasHelper.get_fechamentos_by_sistemas params[:data_inicio], params[:data_fim],
                                                                                      empresa, params[:estado],
                                                                                      user, params[:status_id], params[:flag]
    render json: @fechamentos
  end

  def get_tipo_fechamento
    user = params[:user_id]
    user = current_user.id if !current_user.admin?

    empresa = params[:empresa_id]
    empresa = current_empresa.id.to_s if !current_user.admin?

    connection = ActiveRecord::Base.connection
    @fechamentos = connection.select_all DashboardsPainelVendasHelper.get_tipo_fechamentos params[:data_inicio], params[:data_fim],
                                                                                                  empresa, params[:estado],
                                                                                                  user, params[:status_id], params[:flag]   
    render json: @fechamentos
  end

  def get_valores_fechamento
    user = params[:user_id]
    user = current_user.id if !current_user.admin?

    empresa = params[:empresa_id]
    empresa = current_empresa.id.to_s if !current_user.admin?

    data_inicio_anterior = Date.strptime(params[:data_inicio], "%d/%m/%Y") - 1.month
    data_fim_anterior = Date.strptime(params[:data_fim], "%d/%m/%Y") - 1.month

    connection = ActiveRecord::Base.connection
    
    @fechamentos = connection.select_all DashboardsPainelVendasHelper.get_valores_fechamento params[:data_inicio], params[:data_fim],
                                                                                           empresa, params[:estado],
                                                                                           user,
                                                                                             data_inicio_anterior.strftime("%d/%m/%Y"),
                                                                                             data_fim_anterior.strftime("%d/%m/%Y"), params[:flag]

    render json: @fechamentos
  end

  def get_top_fechamentos
    empresa = params[:empresa_id]
    empresa = current_empresa.id.to_s if !current_user.admin?
    
    connection = ActiveRecord::Base.connection
    @fechamentos = connection.select_all DashboardsPainelVendasHelper.get_top_fechamentos params[:data_inicio], params[:data_fim],
                                                                                             empresa, params[:estado], params[:flag]
    render json: @fechamentos
  end

  def get_top_mensalidade
    empresa = params[:empresa_id]
    empresa = current_empresa.id.to_s if !current_user.admin?

    connection = ActiveRecord::Base.connection
    @fechamentos = connection.select_all DashboardsPainelVendasHelper.get_top_mensalidade params[:data_inicio], params[:data_fim],
                                                                                          empresa, params[:estado], params[:flag]

    tratar_ranking @fechamentos if !current_user.admin?

    render json: @fechamentos
  end

  def get_top_implantacao
    empresa = params[:empresa_id]
    empresa = current_empresa.id.to_s if !current_user.admin?

    connection = ActiveRecord::Base.connection
    @fechamentos = connection.select_all DashboardsPainelVendasHelper.get_top_implantacao params[:data_inicio], params[:data_fim],
                                                                                          empresa, params[:estado]

    tratar_ranking @fechamentos if !current_user.admin?

    render json: @fechamentos
  end

  def get_top_estados_vendas
    empresa = params[:empresa_id]
    empresa = current_empresa.id.to_s if !current_user.admin?
    
    connection = ActiveRecord::Base.connection
    @fechamentos = connection.select_all DashboardsPainelVendasHelper.get_top_estados_vendas params[:data_inicio], params[:data_fim],
                                                                                          empresa, params[:flag]

    tratar_ranking @fechamentos if !current_user.admin?

    render json: @fechamentos
  end

  def get_top_estados_implantacao
    connection = ActiveRecord::Base.connection

    empresa = params[:empresa_id]
    
    sql = DashboardsHelper.get_top_estados_implantacao params[:data_inicio], params[:data_fim], empresa, params[:flag]

    @estados = connection.select_all sql

    render json: @estados
  end

  def get_top_estados_acompanhamento
    connection = ActiveRecord::Base.connection

    empresa = params[:empresa_id]
    
    sql = DashboardsHelper.get_top_estados_acompanhamento params[:data_inicio], params[:data_fim], empresa, params[:flag]

    @estados = connection.select_all sql

    render json: @estados
  end

  def get_fechamentos_table
    user = params[:user_id]
    user = current_user.id if !current_user.admin?

    empresa = params[:empresa_id]
    empresa = current_empresa.id.to_s if !current_user.admin?
    
    connection = ActiveRecord::Base.connection
    @fechamentos = connection.select_all DashboardsPainelVendasHelper.get_fechamentos_table params[:data_inicio], params[:data_fim],
                                                                                          empresa, params[:estado], params[:status_id],
                                                                                            params[:sistema_id], user, params[:flag]

    tratar_ranking @fechamentos if !current_user.admin?

    render json: @fechamentos
  end

  def get_valores_implantacao
    connection = ActiveRecord::Base.connection

    implantador = params[:implantador_id]
    vendedor = params[:vendedor_id]
    empresa = params[:empresa_id]

    sql = DashboardsHelper.get_valores_implantacao params[:data_inicio], params[:data_fim], empresa, vendedor, implantador,
                                                   params[:novos], params[:fechamento], params[:estado], params[:flag]

    @implantacoes = connection.select_all sql

    render json: @implantacoes
  end

  def get_implantacoes_concluidas
    connection = ActiveRecord::Base.connection

    implantador = params[:implantador_id]
    vendedor = params[:vendedor_id]
    empresa = params[:empresa_id]

    sql = DashboardsHelper.get_implantacoes_concluidas params[:data_inicio], params[:data_fim], empresa,
                                                       vendedor, implantador,params[:fechamento], params[:estado], params[:flag]

    @implantacoes = connection.select_all sql

    render json: @implantacoes
  end

  def get_implantacoes_andamento
    connection = ActiveRecord::Base.connection

    implantador = params[:implantador_id]
    vendedor = params[:vendedor_id]
    empresa = params[:empresa_id]

    sql = DashboardsHelper.get_implantacoes_andamento params[:data_inicio], params[:data_fim], empresa, vendedor, implantador,
                                                      params[:novos], params[:fechamento], params[:estado]

    @implantacoes = connection.select_all sql

    render json: @implantacoes
  end

  def get_implantacoes_aguardando
    connection = ActiveRecord::Base.connection

    implantador = params[:implantador_id]
    vendedor = params[:vendedor_id]
    empresa = params[:empresa_id]

    sql = DashboardsHelper.get_implantacoes_aguardando params[:data_inicio], params[:data_fim], empresa, vendedor, implantador,
                                                       params[:novos], params[:fechamento], params[:estado]

    @implantacoes = connection.select_all sql

    render json: @implantacoes
  end

  def get_implantacoes_desistente
    connection = ActiveRecord::Base.connection

    implantador = params[:implantador_id]
    vendedor = params[:vendedor_id]
    empresa = params[:empresa_id]

    sql = DashboardsHelper.get_implantacoes_desistente params[:data_inicio], params[:data_fim], empresa, vendedor,
                                                       implantador,params[:fechamento], params[:estado], params[:flag]

    @implantacoes = connection.select_all sql

    render json: @implantacoes
  end

  def get_implantacoes_cidades
    connection = ActiveRecord::Base.connection

    implantador = params[:implantador_id]
    implantador = current_user.id.to_s if !current_user.admin?

    vendedor = params[:vendedor_id]
    vendedor = current_user.id.to_s if !current_user.admin?

    empresa = params[:empresa_id]
    empresa = current_empresa.id.to_s if !current_user.admin?

    sql = DashboardsHelper.get_implantacoes_cidades params[:data_inicio], params[:data_fim], empresa, vendedor, implantador

    @implantacoes = connection.select_all sql

    render json: @implantacoes
  end

  def get_top_implantadores
    connection = ActiveRecord::Base.connection

    empresa = params[:empresa_id]

    sql = DashboardsHelper.get_top_implantadores params[:data_inicio], params[:data_fim], empresa, params[:estado], params[:flag]

    @implantacoes = connection.select_all sql

    render json: @implantacoes
  end

  def get_implantacoes_table
    connection = ActiveRecord::Base.connection

    implantador = params[:implantador_id]
    vendedor = params[:vendedor_id]
    empresa = params[:empresa_id]

    sql = DashboardsHelper.get_implantacoes_table params[:data_inicio], params[:data_fim], empresa, vendedor, implantador, params[:status_id],
                                                  params[:novos], params[:fechamento], params[:estado], params[:flag]

    @implantacoes = connection.select_all sql

    render json: @implantacoes
  end

  def get_valores_acompanhamentos
    connection = ActiveRecord::Base.connection

    empresa = params[:empresa_id]
    empresa = current_empresa.id.to_s if !current_user.admin?

    sql = DashboardsHelper.get_valores_acompanhamentos params[:data_inicio], params[:data_fim], empresa, params[:vendedor_id],
                                                       params[:responsavel_id], params[:novos], params[:implantador_id],
                                                       params[:estado], params[:ocultar_efetivas], params[:flag]

    @implantacoes = connection.select_all sql

    render json: @implantacoes
  end

  def get_acompanhamentos_concluidas
      connection = ActiveRecord::Base.connection

      empresa = params[:empresa_id]

      sql = DashboardsHelper.get_acompanhamentos_concluidas params[:data_inicio], params[:data_fim], empresa, params[:vendedor_id],
                                                            params[:responsavel_id], params[:implantador_id], params[:estado], params[:flag]

      @implantacoes = connection.select_all sql

      render json: @implantacoes
  end

  def get_acompanhamentos_andamento
    connection = ActiveRecord::Base.connection

    empresa = params[:empresa_id]
    empresa = current_empresa.id.to_s if !current_user.admin?

    sql = DashboardsHelper.get_acompanhamentos_andamento params[:data_inicio], params[:data_fim], empresa, params[:vendedor_id],
                                                         params[:responsavel_id], params[:implantador_id], params[:estado],
                                                         params[:novos], params[:ocultar_efetivas], params[:flag]

    @implantacoes = connection.select_all sql

    render json: @implantacoes
  end


  def get_acompanhamentos_aguardando
    connection = ActiveRecord::Base.connection

    empresa = params[:empresa_id]
    empresa = current_empresa.id.to_s if !current_user.admin?

    sql = DashboardsHelper.get_acompanhamentos_aguardando params[:data_inicio], params[:data_fim], empresa, params[:vendedor_id],
                                                          params[:responsavel_id], params[:implantador_id], params[:estado],
                                                          params[:novos], params[:ocultar_efetivas]

    @implantacoes = connection.select_all sql

    render json: @implantacoes
  end

  def get_top_implantadores_acompanhamento
    connection = ActiveRecord::Base.connection

    empresa = params[:empresa_id]
    empresa = current_empresa.id.to_s if !current_user.admin?
    
    sql = DashboardsHelper.get_top_implantadores_acompanhamento params[:data_inicio], params[:data_fim], empresa, params[:estado], params[:flag]

    @implantacoes = connection.select_all sql

    render json: @implantacoes
  end

  def get_top_vendedores_acompanhamento
    connection = ActiveRecord::Base.connection

    empresa = params[:empresa_id]
    empresa = current_empresa.id.to_s if !current_user.admin?

    sql = DashboardsHelper.get_top_vendedores_acompanhamento params[:data_inicio], params[:data_fim], empresa, params[:estado], params[:flag]

    @implantacoes = connection.select_all sql

    render json: @implantacoes
  end

  def get_acompanhamentos_table
    connection = ActiveRecord::Base.connection

    empresa = params[:empresa_id]
    empresa = current_empresa.id.to_s if !current_user.admin?

    sql = DashboardsHelper.get_acompanhamentos_table params[:data_inicio], params[:data_fim], empresa, params[:vendedor_id],
                                                     params[:responsavel_id], params[:status_id],
                                                     params[:implantador_id], params[:novos], params[:estado], params[:flag]

    acompanhamentos = connection.select_all sql

    connectionFinanceiro = Financeiro::HonorarioMensal.connection

    acompanhamentos = acompanhamentos.to_hash
    acompanhamentos.each do |acomp|
      acompanhamento = Acompanhamento.find acomp['acompanhamentoid']

      acomp['dias_sem_uso'] = acompanhamento.dias_sem_uso

      honorario = connectionFinanceiro.select_all FinanceiroHelper.get_honorario_ativo(acomp['cnpj'], true)
      honorario = honorario.first
      acomp['honorario_ativo'] = honorario.present? ? 'Sim' : 'Não'
    end

    render json: acompanhamentos
  end

  def get_empresas_status_geral
    connection = ActiveRecord::Base.connection
    lista = connection.select_all DashboardsHelper.get_status_empresa_geral params[:empresa_id],params[:data_controle],
                                                                            params[:job_id], ApplicationHelper.true?(params[:agrupar_mes])

    render json: lista
  end

  def get_empresas_status
    connection = ActiveRecord::Base.connection
    lista = connection.select_all DashboardsHelper.get_status_empresa params[:empresa_id], params[:data_controle],
                                                                      params[:job_id], params[:status_empresa_geral],
                                                                      ApplicationHelper.true?(params[:agrupar_mes])

    render json: lista
  end

  def get_controle_filas_job
    connection = ActiveRecord::Base.connection
    mes = params[:mes]
    ano = params[:ano]
    data = Time.now

    data_inicio = Time.now.change(month: mes, year: ano).beginning_of_month
    data_fim = Time.now.change(month: mes, year: ano).end_of_month

    lista = connection.select_all DashboardsHelper.get_controle_job params[:empresa_id], data_inicio, data_fim

    render json: lista
  end

  def get_lista_job
    connection = ActiveRecord::Base.connection

    lista = connection.select_all DashboardsHelper.get_lista_job params[:empresa_id], params[:data_controle], ApplicationHelper.true?(params[:agrupar_mes])

    render json: lista
  end

  def get_controle_filas_table
    connection = ActiveRecord::Base.connection
    lista = connection.select_all DashboardsHelper.get_controle_filas_table params[:empresa_id], params[:data_controle],
                                                                            params[:job_id], params[:status_empresa_geral],
                                                                            params[:status_empresa], ApplicationHelper.true?(params[:agrupar_mes]), params[:boas]

    render json: lista
  end

  def get_empresas_boas_ruins
    connection = ActiveRecord::Base.connection
    lista = connection.select_all DashboardsHelper.get_empresas_boas_ruins params[:empresa_id], params[:data_controle],
                                                                           params[:job_id], ApplicationHelper.true?(params[:agrupar_mes])

    render json: lista
  end

  def get_empresas_boas_ruins_status_geral
    connection = ActiveRecord::Base.connection
    lista = connection.select_all DashboardsHelper.get_empresas_boas_ruins_status_geral params[:empresa_id], params[:data_controle],
                                                                           params[:job_id], params[:boas], ApplicationHelper.true?(params[:agrupar_mes])

    render json: lista
  end

  def get_empresas_boas_ruins_status_empresa
    connection = ActiveRecord::Base.connection
    lista = connection.select_all DashboardsHelper.get_empresas_boas_ruins_status_empresa params[:empresa_id], params[:data_controle],
                                                                                        params[:job_id], params[:boas], params[:status_empresa_geral], ApplicationHelper.true?(params[:agrupar_mes])

    render json: lista
  end

  def get_contatos_12_meses
    connection = ActiveRecord::Base.connection
    params[:data] = (Time.now) if params[:data].eql? ''
    
    if params[:usuario].present?
      lista = connection.select_all DashboardsResultadosHelper.get_contatos_12_meses params[:estado], params[:usuario]    
    elsif (params[:usuario].present? ) && (params[:data].present? )
      lista = connection.select_all DashboardsResultadosHelper.get_contatos_mes_anterior params[:estado], params[:usuario], (params[:data] - 1.month).beginning_of_month, (params[:data] - 1.month).end_of_month
    elsif params[:data].present?
      lista = connection.select_all DashboardsResultadosHelper.get_contatos_mes_anterior params[:estado], nil, (params[:data] - 1.month).beginning_of_month, (params[:data] - 1.month).end_of_month
    else
      lista = connection.select_all DashboardsResultadosHelper.get_contatos_12_meses params[:estado], nil
    end

    #pegar dados das importações
    # importacoes = Importacao.where("data_importacao > ?", data).order(data_importacao: :desc).as_json
    # importacoes.each do |imp|

    #   if imp['empresa_id'] == 2
    #     imp['empresas_boas'] = Cliente.select("distinct clientes.*").where(importacao_id: imp['id']).cnae_blacklist.completo.count
    #   elsif imp['empresa_id'] == 5
    #     imp['empresas_boas'] = imp['total']
    #   else
    #     imp['empresas_boas'] = Cliente.select("distinct clientes.*").where(importacao_id: imp['id']).cnae_blacklist.completo.para_ligacao.count
    #   end
    # end
    
    #add os 13 meses
    # meses = Array.new #12
    # (0..12).each do |i|
    #   meses.push(Time.now - i.month)
    # end

    # dados_importacoes = Array.new
    # #contar empresas boas
    # meses.each do |item|
    #   start_date = item.beginning_of_month.to_date
    #   end_date = item.end_of_month.to_date

    #   #aux = importacoes.select{|entry| entry['data_importacao'].to_date.between?(start_date, end_date) }
    #   #qtd_boas_mes = aux.sum {|h| h['empresas_boas'] }
    #   clientes = Cliente.where("data_importacao between ? and ? and status_empresa is not null and status_empresa <> 0", start_date, end_date)
    #   hash = { "data" => end_date, "qtd_boas" => clientes.count }
    #   dados_importacoes.push(hash)      
    # end
    
    render json: lista
  end

  def get_contatos_mes
    connection = ActiveRecord::Base.connection    
    data = Time.now
    
    if params[:data].present?
      data = params[:data].to_date
    end    

    if (params[:flag].eql? '1')
      data = (data - 1.month).to_s
    elsif (params[:flag].eql? '2')
      data = (data - 2.month).to_s
    else
      data = data.to_s
    end
    
    lista = connection.select_all DashboardsResultadosHelper.get_contatos_mes Date.parse(data).beginning_of_month, Date.parse(data).end_of_month
        
    render json: lista
  end

  #--------------------------------------------- RESULTADOS --------------------------------------------------------------#

  def resultados

  end

  def get_cliente_12_meses
    connection = Financeiro::HonorarioMensal.connection
    lista = connection.select_all DashboardsResultadosHelper.get_cliente_12_meses params[:empresa], params[:estado]

    render json: lista
  end

  def get_cliente_12_meses_sistema
    if params[:data] == ""
      data= Time.now.to_s
    else
      data = params[:data]
    end
    
    connection = Financeiro::HonorarioMensal.connection
    lista = connection.select_all DashboardsResultadosTabelasHelper.table_clientes_ativos_bloqueados params[:estado],
                                                                                                     params[:empresa],
                                                                                                     params[:tipo],
                                                                                                     Time.parse(data).end_of_month
    lista = lista.to_hash
    
    aux = lista.select { |key, value| ( key['sistema'] == "MANAGER") }
    media = aux.sum {|h| h['valor'].to_d }
    totais = {manager:aux.count, rs_man:media}
    totais[:media_man] = media/aux.count if aux.count > 0
    
    aux = lista.select { |key, value| ( key['sistema'] == "LIGHT") }
    media = aux.sum {|h| h['valor'].to_d}
    totais[:light] = aux.count
    totais[:rs_lig] = media
    totais[:media_lig] = media/aux.count if aux.count > 0

    aux = lista.select { |key, value| ( key['sistema'] == "EMISSOR") }
    media = aux.sum {|h| h['valor'].to_d}
    totais[:emissor] = aux.count
    totais[:rs_emi] = media
    totais[:media_emi] = media/aux.count if aux.count > 0


    aux = lista.select { |key, value| ( key['sistema'] == "FISCAL/CONTÁBIL") }
    media = aux.sum {|h| h['valor'].to_d}
    totais[:fiscal] = aux.count
    totais[:rs_f] = media
    totais[:media_f] = media/aux.count if aux.count > 0

    aux = lista.select { |key, value| ( key['sistema'] == "PRO-VENDAS") || (key['sistema'] == "PRÓ-VENDAS") || ( key['sistema'] == "EMISSOR/PRÓ-VENDAS") || ( key['sistema'] == "LIGHT/PRÓ-VENDAS") || ( key['sistema'] == "MANAGER/PRÓ-VENDAS") || ( key['sistema'] == "GOURMET/PRÓ-VENDAS") || ( key['sistema'] == "FISCAL/PRÓ-VENDAS")}
    media = aux.sum {|h| h['valor'].to_d}
    totais[:pro] = aux.count
    totais[:rs_pro] = media
    totais[:media_pro] = media/aux.count if aux.count > 0

    aux = lista.select { |key, value| ( key['sistema'] == "GOURMET") }
    media = aux.sum {|h| h['valor'].to_d}
    totais[:gourmet] = aux.count
    totais[:rs_g] = media
    totais[:media_g] = media/aux.count if aux.count > 0

    aux = lista.select { |key, value| ( key['sistema'] == "TRADE") }
    media = aux.sum {|h| h['valor'].to_d}
    totais[:trade] = aux.count
    totais[:rs_trade] = media
    totais[:media_trade] = media/aux.count if aux.count > 0

    aux = lista.select { |key, value| ( key['sistema'] == "ATHUS MANAGMENT SYSTEM") }
    media = aux.sum {|h| h['valor'].to_d}
    totais[:athus] = aux.count
    totais[:rs_athus] = media
    totais[:media_athus] = media/aux.count if aux.count > 0

    aux = lista.select { |key, value| ( key['sistema'] == "EMISSOR WEB") }
    media = aux.sum {|h| h['valor'].to_d}
    totais[:emissor_web] = aux.count
    totais[:rs_emissor_web] = media
    totais[:media_emissor_web] = media/aux.count if aux.count > 0

    aux = lista.select { |key, value| ( key['sistema'] == "") || ( key['sistema'] == "=>") }
    totais[:sem_sistema] = aux.count
    totais[:rs_sem_sistema] = aux.sum {|h| h['valor'].to_d}

    render json: totais
  end

  def get_clientes_ativos_cidade
    connection = Financeiro::HonorarioMensal.connection
    lista = connection.select_all DashboardsResultadosHelper.get_clientes_ativos_cidade params[:empresa], params[:estado], params[:order]
    
    render json: lista
  end

  def get_cliente_UF
    if params[:data] == ""
      data= Time.now.to_s
    else
      data = params[:data]
    end
    
    connection = Financeiro::HonorarioMensal.connection
    if params[:flag] == "1"
      lista = connection.select_all DashboardsResultadosTabelasHelper.get_cliente_UF params[:empresa], params[:tipo], Time.parse(data).end_of_month
    elsif params[:flag] == "2"
      lista = connection.select_all DashboardsResultadosTabelasHelper.cliente_UF_ativo_Real params[:empresa], Time.parse(data).beginning_of_month , Time.parse(data).end_of_month
    elsif params[:flag] == "3"
      lista = connection.select_all DashboardsResultadosTabelasHelper.cliente_UF_inativo_Real params[:empresa], Time.parse(data).beginning_of_month , Time.parse(data).end_of_month
    elsif params[:flag] == "4"
      lista = connection.select_all DashboardsResultadosTabelasHelper.cliente_UF_ativo params[:empresa], Time.parse(data).beginning_of_month , Time.parse(data).end_of_month
    elsif params[:flag] == "5"
      lista = connection.select_all DashboardsResultadosTabelasHelper.cliente_UF_inativo params[:empresa], Time.parse(data).beginning_of_month , Time.parse(data).end_of_month
    elsif params[:flag] == "6"
      lista = connection.select_all DashboardsResultadosTabelasHelper.table_efetivacoes_financeiro_2meses nil, params[:empresa], Time.parse(data).beginning_of_month , Time.parse(data).end_of_month
    elsif params[:flag] == "7" #desistente
      lista = connection.select_all DashboardsResultadosTabelasHelper.table_desistencia_financeiro_2meses nil, params[:empresa], Time.parse(data).beginning_of_month , Time.parse(data).end_of_month
    end    

    lista = lista.to_hash
    
    totais = Array.new

    contador = {estado:'PR'}
    contador[:qtd] = lista.count { |key, value| ( key['sigla'] == "PR") }
    totais.push(contador);

    contador = {estado:'SP'}
    contador[:qtd] = lista.count { |key, value| ( key['sigla'] == "SP") }
    totais.push(contador);

    contador = {estado:'MS'}
    contador[:qtd] = lista.count { |key, value| ( key['sigla'] == "MS") }
    totais.push(contador);

    contador = {estado:'BA'}
    contador[:qtd] = lista.count { |key, value| ( key['sigla'] == "BA") }
    totais.push(contador);

    contador = {estado:'RS'}
    contador[:qtd] = lista.count { |key, value| ( key['sigla'] == "RS") }
    totais.push(contador);

    contador = {estado:'GO'}
    contador[:qtd] = lista.count { |key, value| ( key['sigla'] == "GO") }
    totais.push(contador);

    contador = {estado:'PE'}
    contador[:qtd] = lista.count { |key, value| ( key['sigla'] == "PE") }
    totais.push(contador);

    contador = {estado:'ES'}
    contador[:qtd] = lista.count { |key, value| ( key['sigla'] == "ES") }
    totais.push(contador);

    contador = {estado:'RJ'}
    contador[:qtd] = lista.count { |key, value| ( key['sigla'] == "RJ") }
    totais.push(contador);    

    contador = {estado:'MT'}
    contador[:qtd] = lista.count { |key, value| ( key['sigla'] == "MT") }
    totais.push(contador); 

    contador = {estado:'MG'}
    contador[:qtd] = lista.count { |key, value| ( key['sigla'] == "MG") }
    totais.push(contador); 

    contador = {estado:'SC'}
    contador[:qtd] = lista.count { |key, value| ( key['sigla'] == "SC") }
    totais.push(contador); 

    contador = {estado:'RO'}
    contador[:qtd] = lista.count { |key, value| ( key['sigla'] == "RO") }
    totais.push(contador); 

    contador = {estado:'PI'}
    contador[:qtd] = lista.count { |key, value| ( key['sigla'] == "PI") }
    totais.push(contador); 

    contador = {estado:'MA'}
    contador[:qtd] = lista.count { |key, value| ( key['sigla'] == "MA") }
    totais.push(contador); 

    contador = {estado:'PB'}
    contador[:qtd] = lista.count { |key, value| ( key['sigla'] == "PB") }
    totais.push(contador); 

    #contador = {estado:'TOTAL'}
    #contador[:qtd] = lista.count
    #totais.push(contador);    

    render json: totais
  end

  def get_efetivacoes_desativacoes
    connection = Financeiro::HonorarioMensal.connection
    lista = connection.select_all DashboardsResultadosHelper.get_efetivacoes_desativacoes params[:empresa], params[:estado], Dashboard.cnpjs_com_tags_troca_cnpj
    
    render json: lista
  end

  def get_efetivacoes_desativacoes_sistema
    if params[:data] == ""
      data= Time.now.to_s
    else
      data = params[:data]
    end
    
    connection = Financeiro::HonorarioMensal.connection
    
    if params[:tipo] == "ATIVAS"
      lista = connection.select_all DashboardsResultadosTabelasHelper.table_efetivacoes_financeiro params[:estado],
                                                                                                 params[:empresa],
                                                                                                 Time.parse(data).beginning_of_month,
                                                                                                 Time.parse(data).end_of_month
    else
      lista = connection.select_all DashboardsResultadosTabelasHelper.table_desistencia_financeiro params[:estado],
                                                                                                 params[:empresa],
                                                                                                 Time.parse(data).beginning_of_month,
                                                                                                 Time.parse(data).end_of_month
    end
    lista = lista.to_hash  
    
    aux = lista.select { |key, value| ( key['sistema'] == "MANAGER")}
    totais = {manager:aux.count, rs_man:aux.sum {|h| h['valor'].to_d}}

    aux = lista.select { |key, value| ( key['sistema'] == "LIGHT")}
    totais[:light] = aux.count
    totais[:rs_lig] = aux.sum {|h| h['valor'].to_d}
    
    aux = lista.select { |key, value| ( key['sistema'] == "EMISSOR")}
    totais[:emissor] = aux.count
    totais[:rs_emi] = aux.sum {|h| h['valor'].to_d}

    aux = lista.select { |key, value| ( key['sistema'] == "FISCAL/CONTÁBIL")}
    totais[:fiscal] = aux.count
    totais[:rs_f] = aux.sum {|h| h['valor'].to_d}

    aux = lista.select { |key, value| ( key['sistema'] == "PRO-VENDAS") || ( key['sistema'] == "EMISSOR/PRÓ-VENDAS") || ( key['sistema'] == "LIGHT/PRÓ-VENDAS") || ( key['sistema'] == "MANAGER/PRÓ-VENDAS") || ( key['sistema'] == "GOURMET/PRÓ-VENDAS") || ( key['sistema'] == "FISCAL/PRÓ-VENDAS")}
    totais[:pro] = aux.count
    totais[:rs_pro] = aux.sum {|h| h['valor'].to_d}

    aux = lista.select { |key, value| ( key['sistema'] == "GOURMET")}
    totais[:gourmet] = aux.count
    totais[:rs_g] = aux.sum {|h| h['valor'].to_d}

    aux = lista.select { |key, value| ( key['sistema'] == "TRADE")}
    totais[:trade] = aux.count
    totais[:rs_trade] = aux.sum {|h| h['valor'].to_d}

    aux = lista.select { |key, value| ( key['sistema'] == "ATHUS MANAGMENT SYSTEM")}
    totais[:athus] = aux.count
    totais[:rs_athus] = aux.sum {|h| h['valor'].to_d}

    aux = lista.select { |key, value| ( key['sistema'] == "EMISSOR WEB")}
    totais[:emissor_web] = aux.count
    totais[:rs_emissor_web] = aux.sum {|h| h['valor'].to_d}

    aux = lista.select { |key, value| (( key['sistema'] == "") || ( key['sistema'] == "=>"))}
    totais[:sem_sistema] = aux.count
    totais[:rs_sem_sistema] = aux.sum {|h| h['valor'].to_d}

    render json: totais
  end

  def get_efetivacoes_desativacoesReal
    connection = Financeiro::HonorarioMensal.connection
    lista = connection.select_all DashboardsResultadosHelper.get_efetivacoes_desativacoesReal params[:empresa], params[:estado], Dashboard.cnpjs_com_tags_troca_cnpj

    render json: lista
  end

  def get_efetivacoes_desativacoes_2meses
    connection = Financeiro::HonorarioMensal.connection
    lista = connection.select_all DashboardsResultadosHelper.get_efetivacoes_desativacoes_2meses params[:empresa], params[:estado], params[:qtd_mes], Dashboard.cnpjs_com_tags_troca_cnpj
    
    render json: lista
  end

  def table_desistencia_financeiroReal    
    connection = Financeiro::HonorarioMensal.connection
    cnpjs = Dashboard.cnpjs_com_tags_troca_cnpj
    if params[:qtd_mes].eql? '1'
      lista = connection.select_all DashboardsResultadosTabelasHelper.table_desistencia_financeiroReal params[:estado],params[:empresa],
                                                                            Time.parse(params[:data]).beginning_of_month,Time.parse(params[:data]).end_of_month, cnpjs
    else
      lista = connection.select_all DashboardsResultadosTabelasHelper.table_desistencia_financeiro_2meses params[:estado],params[:empresa],
                                                                            Time.parse(params[:data]).beginning_of_month,Time.parse(params[:data]).end_of_month, params[:qtd_mes].to_i, cnpjs
    end

    lista = lista.to_hash
    
    lista.each do |empre|
      cliente = Cliente.find_by_cnpj empre['cpfcnpj']
      if cliente.nil?
        empre['vendedor'] =  ''
        empre['implantador'] =  ''
        empre['dias_sem_uso'] = Cliente.dias_sem_uso empre['cpfcnpj']
        next
      end
      empre['dias_sem_uso'] = Cliente.dias_sem_uso empre['cpfcnpj']

      implantacao = Implantacao.find_by_cliente_id cliente.id
      if implantacao.nil?
        empre['implantador'] =  ''
      else
        empre['implantador'] =  implantacao.user.present? ? implantacao.user.name : ''
      end

      if cliente.fechamento.nil?
        empre['vendedor'] =  ''
      else
        empre['vendedor'] = cliente.fechamento.user.present? ? cliente.fechamento.user.name : ''
      end
    end
    
    render json: lista
  end

  def get_efetivacoes_desativacoes_sistema_real
    if params[:data] == ""
      data= Time.now.to_s
    else
      data = params[:data]
    end

    connection = Financeiro::HonorarioMensal.connection
    if params[:pagamento2].present?
      if params[:tipo] == "INATIVAS"
        lista = connection.select_all DashboardsResultadosTabelasHelper.table_desistencia_financeiro_2meses params[:estado],
                                                                                                  params[:empresa],
                                                                                                  Time.parse(data).beginning_of_month,Time.parse(data).end_of_month
      else
        lista = connection.select_all DashboardsResultadosTabelasHelper.table_efetivacoes_financeiro_2meses params[:estado],params[:empresa],
                                                                              Time.parse(data).beginning_of_month,Time.parse(data).end_of_month
      end
    else
      if params[:tipo] == "INATIVAS"
        lista = connection.select_all DashboardsResultadosTabelasHelper.table_desistencia_financeiroReal params[:estado],
                                                                                                  params[:empresa],
                                                                                                  Time.parse(data).beginning_of_month,Time.parse(data).end_of_month
      else
        lista = connection.select_all DashboardsResultadosTabelasHelper.table_efetivacoes_financeiroReal params[:estado],params[:empresa],
                                                                              Time.parse(data).beginning_of_month,Time.parse(data).end_of_month
      end
    end

    lista = lista.to_hash
    
    aux = lista.select { |key, value| ( key['sistema'] == "MANAGER")}
    totais = {manager:aux.count, rs_man:aux.sum {|h| h['valor'].to_d}}

    aux = lista.select { |key, value| ( key['sistema'] == "LIGHT")}
    totais[:light] = aux.count
    totais[:rs_lig] = aux.sum {|h| h['valor'].to_d}
    
    aux = lista.select { |key, value| ( key['sistema'] == "EMISSOR")}
    totais[:emissor] = aux.count
    totais[:rs_emi] = aux.sum {|h| h['valor'].to_d}

    aux = lista.select { |key, value| ( key['sistema'] == "FISCAL/CONTÁBIL")}
    totais[:fiscal] = aux.count
    totais[:rs_f] = aux.sum {|h| h['valor'].to_d}

    aux = lista.select { |key, value| ( key['sistema'] == "PRO-VENDAS") || ( key['sistema'] == "EMISSOR/PRO-VENDAS") || ( key['sistema'] == "LIGHT/PRO-VENDAS") || ( key['sistema'] == "MANAGER/PRO-VENDAS") || ( key['sistema'] == "GOURMET/PRO-VENDAS") || ( key['sistema'] == "FISCAL/PRO-VENDAS")}
    totais[:pro] = aux.count
    totais[:rs_pro] = aux.sum {|h| h['valor'].to_d}

    aux = lista.select { |key, value| ( key['sistema'] == "GOURMET")}
    totais[:gourmet] = aux.count
    totais[:rs_g] = aux.sum {|h| h['valor'].to_d}

    aux = lista.select { |key, value| ( key['sistema'] == "TRADE")}
    totais[:trade] = aux.count
    totais[:rs_trade] = aux.sum {|h| h['valor'].to_d}

    aux = lista.select { |key, value| ( key['sistema'] == "ATHUS MANAGMENT SYSTEM")}
    totais[:athus] = aux.count
    totais[:rs_athus] = aux.sum {|h| h['valor'].to_d}

    aux = lista.select { |key, value| ( key['sistema'] == "EMISSOR WEB")}
    totais[:emissor_web] = aux.count
    totais[:rs_emissor_web] = aux.sum {|h| h['valor'].to_d}

    aux = lista.select { |key, value| (( key['sistema'] == "") || ( key['sistema'] == "=>"))}
    totais[:sem_sistema] = aux.count
    totais[:rs_sem_sistema] = aux.sum {|h| h['valor'].to_d}

    render json: totais    
  end

  def get_total_faturamento_12_meses
    connection = Financeiro::HonorarioMensal.connection
    lista = connection.select_all DashboardsResultadosHelper.get_total_faturamento_12_meses params[:empresa],  params[:estado]

    render json: lista
  end

  def get_total_faturamento_UF
    if params[:data] == ""
      data= Time.now.to_s
    else
      data = params[:data]
    end
    
    connection = Financeiro::HonorarioMensal.connection
    if params[:script].present?
      lista = connection.select_all DashboardsResultadosHelper.get_primeira_parcela_UF params[:empresa], 
                                                        Date.parse(data).beginning_of_month, Date.parse(data).end_of_month, params[:script]
    else
      lista = connection.select_all DashboardsResultadosHelper.get_total_faturamento_UF params[:empresa], 
                                                        Date.parse(data).beginning_of_month, Date.parse(data).end_of_month 
    end

    render json: lista
  end

  def get_total_faturamento_12_meses_sistema
    if params[:data] == ""
      data= Time.now
    else
      data = params[:data].to_date
    end
    data_inicial = Date.new(data.year, data.month, 1)
    data_final = Date.new(data.year, data.month, -1)
    
    connection = Financeiro::HonorarioMensal.connection
    lista = connection.select_all DashboardsResultadosHelper.get_total_faturamento_12_meses_sistema params[:empresa],  params[:estado], data_inicial, data_final
    
    lista = lista.to_hash  

    aux = lista.select { |key, value| ( key['sistema'] == "MANAGER") &&  ( key['idcobranca'] == "16")}
    media = aux.sum {|h| h['valorpagodebito'].to_d}
    totais = {manager:aux.count, rs_man:media}
    totais[:media_man] = media/aux.count if aux.count > 0

    aux = lista.select { |key, value| ( key['sistema'] == "LIGHT") &&  ( key['idcobranca'] == "16") }
    media = aux.sum {|h| h['valorpagodebito'].to_d}
    totais[:light] = aux.count
    totais[:rs_lig] = media
    totais[:media_lig] = media/aux.count if aux.count > 0
    
    aux = lista.select { |key, value| ( key['sistema'] == "EMISSOR") &&  ( key['idcobranca'] == "16") }
    media = aux.sum {|h| h['valorpagodebito'].to_d}
    totais[:emissor] = aux.count
    totais[:rs_emi] = media
    totais[:media_emi]= media/aux.count if aux.count > 0

    aux = lista.select { |key, value| ( key['sistema'] == "FISCAL/CONTÁBIL") &&  ( key['idcobranca'] == "16") }
    media = aux.sum {|h| h['valorpagodebito'].to_d}
    totais[:fiscal] = aux.count
    totais[:rs_f] = media
    totais[:media_f] = media/aux.count if aux.count > 0

    aux = lista.select { |key, value| ( key['sistema'] == "PRO-VENDAS") || ( key['sistema'] == "EMISSOR/PRÓ-VENDAS") || ( key['sistema'] == "LIGHT/PRÓ-VENDAS") || ( key['sistema'] == "MANAGER/PRÓ-VENDAS") || ( key['sistema'] == "GOURMET/PRÓ-VENDAS") || ( key['sistema'] == "FISCAL/PRÓ-VENDAS")}
    media = aux.sum {|h| h['valorpagodebito'].to_d}
    totais[:pro] = aux.count
    totais[:rs_pro] = media
    totais[:media_pro] = media/aux.count if aux.count > 0

    aux = lista.select { |key, value| ( key['sistema'] == "GOURMET") &&  ( key['idcobranca'] == "16") }
    media = aux.sum {|h| h['valorpagodebito'].to_d}
    totais[:gourmet] = aux.count
    totais[:rs_g] = media
    totais[:media_g] = media/aux.count if aux.count > 0

    aux = lista.select { |key, value| ( key['sistema'] == "TRADE") &&  ( key['idcobranca'] == "16") }
    media = aux.sum {|h| h['valorpagodebito'].to_d}
    totais[:trade] = aux.count
    totais[:rs_trade] = media
    totais[:media_trade] = media/aux.count if aux.count > 0

    aux = lista.select { |key, value| ( key['sistema'] == "ATHUS MANAGMENT SYSTEM") &&  ( key['idcobranca'] == "16") }
    media = aux.sum {|h| h['valorpagodebito'].to_d}
    totais[:athus] = aux.count
    totais[:rs_athus] = media
    totais[:media_athus] = media/aux.count if aux.count > 0

    aux = lista.select { |key, value| ( key['sistema'] == "EMISSOR WEB")  &&  ( key['idcobranca'] == "16")}
    media = aux.sum {|h| h['valorpagodebito'].to_d}
    totais[:emissor_web] = aux.count
    totais[:rs_emissor_web] = media
    totais[:media_emissor_web] = media/aux.count if aux.count > 0

    aux = lista.select { |key, value| (( key['sistema'] == "") || ( key['sistema'] == "=>")) &&  ( key['idcobranca'] == "16") }
    media = aux.sum {|h| h['valorpagodebito'].to_d}
    totais[:sem_sistema] = aux.count
    totais[:rs_sem_sistema] = media
    totais[:media_sem_sistema] = media/aux.count if aux.count > 0
    
    render json: totais
  end

  def get_total_faturamento_mes_anterior
    connection = Financeiro::HonorarioMensal.connection
    lista = connection.select_all DashboardsResultadosHelper.get_total_faturamento_mes_anterior params[:empresa],  params[:estado]
    
    render json: lista
  end  

  def get_total_primeira_mensalidade_por_tipo
    connection = Financeiro::HonorarioMensal.connection
    lista = connection.select_all DashboardsResultadosHelper.get_total_primeira_mensalidade_por_tipo params[:empresa] , params[:estado]

    render json: lista
  end

  def get_total_primeira_mensalidade_por_tipo_mes_anterior
    connection = Financeiro::HonorarioMensal.connection
    lista = connection.select_all DashboardsResultadosHelper.get_total_primeira_mensalidade_por_tipo_mes_anterior params[:empresa] , params[:estado]

    render json: lista
  end

  def get_inadimplencia_12_meses
    connection = Financeiro::HonorarioMensal.connection
    lista = connection.select_all DashboardsResultadosHelper.get_inadimplencia_12_meses params[:empresa] ,  params[:estado]

    render json: lista
  end

  def implantacoes_conluidas_12_meses
    connection = ActiveRecord::Base.connection
    lista = connection.select_all DashboardsResultadosHelper.implantacoes_conluidas_12_meses params[:empresa] ,  params[:estado], params[:vendedor], params[:implantador]

    render json: lista
  end

  def implantacoes_conluidas_12_meses_mes_anterior
    connection = ActiveRecord::Base.connection
    lista = connection.select_all DashboardsResultadosHelper.implantacoes_conluidas_12_meses_mes_anterior params[:empresa], params[:estado], params[:vendedor], params[:implantador]

    render json: lista
  end

  def get_demonstrativo_12_meses
    connection = Financeiro::HonorarioMensal.connection
    lista = connection.select_all DashboardsResultadosHelper.get_demonstrativo_12_meses params[:empresa],  params[:estado]

    render json: lista
  end

  def get_demonstrativo_mes_anterior
    if params[:data] == ""
      data = (Time.now - 1.month).to_s
    else
      data = params[:data] - 1.month
    end

    connection = Financeiro::HonorarioMensal.connection
    lista = connection.select_all DashboardsResultadosHelper.get_demonstrativo_mes_anterior params[:empresa],  params[:estado], 
                                                                        Date.parse(data).beginning_of_month, Date.parse(data).end_of_month
    
    render json: lista
  end

  def get_receita_12_meses
    connection = Financeiro::HonorarioMensal.connection
    ordem = 'm' + Date.today.month.to_s
    lista = connection.select_all DashboardsResultadosHelper.get_receitas_12_meses params[:empresa], params[:script], ordem
    lista = lista.to_hash
    if params[:script] == "SOMAR_RECEITA"
      #criar um nova lista pra mostrar cobrança 16,66 e outros
      aux_lista = lista.select { |key, value| ( key['idcobranca'] == "16") || ( key['idcobranca'] == "66")}
      lista2 = aux_lista
      aux_lista = lista - lista2
      #somar outros
      hash_soma = {idcobranca:'0'}
      hash_soma["nomecobranca"] = 'OUTROS'
      hash_soma["m1"] = aux_lista.sum {|h| h['m1'].to_d}
      hash_soma["m2"] = aux_lista.sum {|h| h['m2'].to_d}
      hash_soma["m3"] = aux_lista.sum {|h| h['m3'].to_d}
      hash_soma["m4"] = aux_lista.sum {|h| h['m4'].to_d}
      hash_soma["m5"] = aux_lista.sum {|h| h['m5'].to_d}
      hash_soma["m6"] = aux_lista.sum {|h| h['m6'].to_d}
      hash_soma["m7"] = aux_lista.sum {|h| h['m7'].to_d}
      hash_soma["m8"] = aux_lista.sum {|h| h['m8'].to_d}
      hash_soma["m9"] = aux_lista.sum {|h| h['m9'].to_d}
      hash_soma["m10"] = aux_lista.sum {|h| h['m10'].to_d}
      hash_soma["m11"] = aux_lista.sum {|h| h['m11'].to_d}
      hash_soma["m12"] = aux_lista.sum {|h| h['m12'].to_d}
      lista2.push(hash_soma)

      receitas = Array.new
      mes = Date.today.month
      
      lista2.each do |item|
        nova_lista = {idcobranca: item['idcobranca'], nomecobranca: item['nomecobranca']}
        aux_mes = mes
        for i in 0..11        
          aux_mes = aux_mes + 1    
          
          if aux_mes == 13
            aux_mes = 1
          end
          nome = 'm'+ i.to_s #esse NOME não se refere ao mês e sim a ordem de meses que deve aparecer na tabela
          nova_lista["#{nome}"] = item['m' + aux_mes.to_s].to_f
        end      
        receitas.push(nova_lista)
        
      end
    else
      receitas = Array.new
      mes = Date.today.month
      
      lista.each do |item|
        if item['nomecobranca'] == 'FUNCIONARIOS'
          item['nomecobranca'] = 'DESPESAS COM PESSOAL'
        end
        nova_lista = {idcobranca: item['idcobranca'], nomecobranca: item['nomecobranca']}
        aux_mes = mes
        for i in 0..11        
          aux_mes = aux_mes + 1    
          
          if aux_mes == 13
            aux_mes = 1
          end
          nome = 'm'+ i.to_s #esse NOME não se refere ao mês e sim a ordem de meses que deve aparecer na tabela
          nova_lista["#{nome}"] = item['m' + aux_mes.to_s].to_f
        end      
        receitas.push(nova_lista)
      end
    end   
    
    #totalizador
    hash_soma = {idcobranca:''}
    hash_soma["nomecobranca"] = 'TOTAL'
    hash_soma["m0"] = receitas.sum {|h| h['m0'].to_d}
    hash_soma["m1"] = receitas.sum {|h| h['m1'].to_d}
    hash_soma["m2"] = receitas.sum {|h| h['m2'].to_d}
    hash_soma["m3"] = receitas.sum {|h| h['m3'].to_d}
    hash_soma["m4"] = receitas.sum {|h| h['m4'].to_d}
    hash_soma["m5"] = receitas.sum {|h| h['m5'].to_d}
    hash_soma["m6"] = receitas.sum {|h| h['m6'].to_d}
    hash_soma["m7"] = receitas.sum {|h| h['m7'].to_d}
    hash_soma["m8"] = receitas.sum {|h| h['m8'].to_d}
    hash_soma["m9"] = receitas.sum {|h| h['m9'].to_d}
    hash_soma["m10"] = receitas.sum {|h| h['m10'].to_d}
    hash_soma["m11"] = receitas.sum {|h| h['m11'].to_d}
    receitas.push(hash_soma)

    render json: receitas
  end

  def get_receita_12_meses_sistema
    connection = Financeiro::HonorarioMensal.connection
    lista = connection.select_all DashboardsResultadosHelper.get_receita_12_meses_sistema params[:empresa], params[:tipo].to_i, ordem = 'm' + Date.today.month.to_s
    
    lista = lista.to_hash
   
    aux_lista = lista.select { |key, value| ( key['sistema'] == "PRÓ-VENDAS") || ( key['sistema'] == "EMISSOR/PRÓ-VENDAS") || ( key['sistema'] == "LIGHT/PRÓ-VENDAS") || 
                        ( key['sistema'] == "MANAGER/PRÓ-VENDAS") || ( key['sistema'] == "GOURMET/PRÓ-VENDAS") || ( key['sistema'] == "FISCAL/PRÓ-VENDAS")}
    lista2 = lista - aux_lista #pega todos os outros elementos da lista
      #somar outros
      hash_soma = {nomecobranca:'honorario'}
      hash_soma["sistema"] = 'PRÓ-VENDAS'
      hash_soma["m1"] = aux_lista.sum {|h| h['m1'].to_d}
      hash_soma["m2"] = aux_lista.sum {|h| h['m2'].to_d}
      hash_soma["m3"] = aux_lista.sum {|h| h['m3'].to_d}
      hash_soma["m4"] = aux_lista.sum {|h| h['m4'].to_d}
      hash_soma["m5"] = aux_lista.sum {|h| h['m5'].to_d}
      hash_soma["m6"] = aux_lista.sum {|h| h['m6'].to_d}
      hash_soma["m7"] = aux_lista.sum {|h| h['m7'].to_d}
      hash_soma["m8"] = aux_lista.sum {|h| h['m8'].to_d}
      hash_soma["m9"] = aux_lista.sum {|h| h['m9'].to_d}
      hash_soma["m10"] = aux_lista.sum {|h| h['m10'].to_d}
      hash_soma["m11"] = aux_lista.sum {|h| h['m11'].to_d}
      hash_soma["m12"] = aux_lista.sum {|h| h['m12'].to_d}
      lista2.push(hash_soma)

    receitas = Array.new
    mes = Date.today.month
    
    lista2.each do |item|
      nova_lista = {nomecobranca: item['nomecobranca'], sistema: item['sistema']}
      aux_mes = mes
      for i in 0..11        
        aux_mes = aux_mes + 1    
        
        if aux_mes == 13
          aux_mes = 1
        end
        nome = 'm'+ i.to_s
        nova_lista["#{nome}"] = item['m' + aux_mes.to_s].to_f
      end      
      receitas.push(nova_lista)
    end

    render json: receitas
  end

  def get_tabela_receitas
    if params[:data] == ""
      data = Time.now.to_s
    else
      data = params[:data]
    end
    
    connection = Financeiro::HonorarioMensal.connection
    lista = connection.select_all DashboardsResultadosTabelasHelper.get_tabela_receitas params[:empresa],  params[:estado], 
                                                                      Date.parse(data).beginning_of_month, Date.parse(data).end_of_month, params[:categoria]
    
    lista = lista.to_hash
    
    render json: lista
  end

  def get_outras_receitas_12_meses
    connection = Financeiro::HonorarioMensal.connection
    lista = connection.select_all DashboardsResultadosHelper.get_outras_receitas_12_meses params[:empresa]
    
    lista = lista.to_hash
    
    receitas = Array.new
    mes = Date.today.month
    
    lista.each do |item|
      nova_lista = {idcobranca: item['idcobranca'], nomecobranca: item['nomecobranca']}
      aux_mes = mes
      for i in 0..11        
        aux_mes = aux_mes + 1    
        
        if aux_mes == 13
          aux_mes = 1
        end
        nome = 'm'+ i.to_s #esse NOME não se refere ao mês e sim a ordem de meses que deve aparecer na tabela
        nova_lista["#{nome}"] = item['m' + aux_mes.to_s].to_f
      end      
      receitas.push(nova_lista)
    end

    render json: receitas
  end

  def get_receita_12_meses_gruber
    connection = Financeiro::HonorarioMensal.connection
    ordem = 'm' + Date.today.month.to_s
    lista = connection.select_all DashboardsResultadosGruberHelper.get_receitas_12_meses_gruber params[:empresa], params[:script], ordem
    
    lista = lista.to_hash
    receitas = Array.new
    mes = Date.today.month
      
    lista.each do |item|
      if item['nomecobranca'] == 'FUNCIONARIOS'
        item['nomecobranca'] = 'DESPESAS COM PESSOAL'
      end
      nova_lista = {idcobranca: item['idcobranca'], nomecobranca: item['nomecobranca']}
      aux_mes = mes
      for i in 0..11        
        aux_mes = aux_mes + 1    
          
        if aux_mes == 13
          aux_mes = 1
        end
        nome = 'm'+ i.to_s #esse NOME não se refere ao mês e sim a ordem de meses que deve aparecer na tabela
        nova_lista["#{nome}"] = item['m' + aux_mes.to_s].to_f
      end      
      receitas.push(nova_lista)        
    end 
    
    #totalizador
    hash_soma = {idcobranca:''}
    hash_soma["nomecobranca"] = 'TOTAL'
    hash_soma["m0"] = receitas.sum {|h| h['m0'].to_d}
    hash_soma["m1"] = receitas.sum {|h| h['m1'].to_d}
    hash_soma["m2"] = receitas.sum {|h| h['m2'].to_d}
    hash_soma["m3"] = receitas.sum {|h| h['m3'].to_d}
    hash_soma["m4"] = receitas.sum {|h| h['m4'].to_d}
    hash_soma["m5"] = receitas.sum {|h| h['m5'].to_d}
    hash_soma["m6"] = receitas.sum {|h| h['m6'].to_d}
    hash_soma["m7"] = receitas.sum {|h| h['m7'].to_d}
    hash_soma["m8"] = receitas.sum {|h| h['m8'].to_d}
    hash_soma["m9"] = receitas.sum {|h| h['m9'].to_d}
    hash_soma["m10"] = receitas.sum {|h| h['m10'].to_d}
    hash_soma["m11"] = receitas.sum {|h| h['m11'].to_d}
    receitas.push(hash_soma)

    render json: receitas
  end

  def get_resultado_12_meses
    connection = Financeiro::HonorarioMensal.connection
    lista = connection.select_all DashboardsResultadosGruberHelper.get_resultado_12_meses_gruber params[:empresa]
    
    lista = lista.to_hash
    receitas = Array.new
    mes = Date.today.month      
    lista.each do |item|
      nova_lista = {tipo: item['tipo']}
      aux_mes = mes
      for i in 0..11        
        aux_mes = aux_mes + 1    
          
        if aux_mes == 13
          aux_mes = 1
        end
        nome = 'm'+ i.to_s #esse NOME não se refere ao mês e sim a ordem de meses que deve aparecer na tabela
        nova_lista["#{nome}"] = item['m' + aux_mes.to_s].to_f
      end      
      receitas.push(nova_lista)        
    end 

    render json: receitas
  end

  def get_resumo_ultimos_5_anos
    connection = Financeiro::HonorarioMensal.connection
    lista = connection.select_all DashboardsResultadosGruberHelper.get_resumo_ultimos_5_anos params[:empresa]

    render json: lista
  end

  def get_despesas_com_pessoal
    connection = Financeiro::HonorarioMensal.connection
    lista = connection.select_all DashboardsResultadosHelper.get_despesas_com_pessoal params[:empresa]

    render json: lista
  end

    def acompanhamentos_concluidos_12_meses
    connection = ActiveRecord::Base.connection
    lista = connection.select_all DashboardsResultadosHelper.acompanhamentos_concluidos_12_meses params[:empresa],  params[:estado], params[:vendedor], params[:implantador]

    render json: lista
  end

  def acompanhamentos_concluidos_12_meses_mes_anterior
    connection = ActiveRecord::Base.connection
    lista = connection.select_all DashboardsResultadosHelper.acompanhamentos_concluidos_12_meses_mes_anterior params[:empresa], params[:estado], params[:vendedor], params[:implantador]

    render json: lista
  end

  def desistencia_12_meses
    connection = ActiveRecord::Base.connection
    lista = connection.select_all DashboardsResultadosHelper.desistencia_12_meses params[:empresa] ,  params[:estado], params[:vendedor], params[:implantador]

    render json: lista
  end

  def desistencia_12_meses_mes_anterior
    connection = ActiveRecord::Base.connection
    lista = connection.select_all DashboardsResultadosHelper.desistencia_12_meses_mes_anterior params[:empresa] ,  params[:estado], params[:vendedor], params[:implantador]

    render json: lista
  end

  def fechamentos_12_meses
    connection = ActiveRecord::Base.connection
    lista = connection.select_all DashboardsResultadosHelper.fechamentos_12_meses params[:empresa], params[:estado], params[:vendedor]

    render json: lista
  end

  def fechamentos_12_meses_mes_anterior
    connection = ActiveRecord::Base.connection
    lista = connection.select_all DashboardsResultadosHelper.fechamentos_12_meses_mes_anterior params[:empresa],  params[:estado], params[:vendedor]

    render json: lista
  end

  def top_vendedores_acompanhamentos
    mes = params[:mes]
    data = Time.now

    if data.month != mes
      data_inicio = Time.now.change(month: mes, day: 1).beginning_of_month
      data_fim = Time.now.change(month: mes, day: 1).end_of_month
    else
      data_inicio = Time.now.beginning_of_month
      data_fim =Time.now.end_of_month
    end

    connection = ActiveRecord::Base.connection
    lista = connection.select_all DashboardsResultadosHelper.top_vendedores_acompanhamentos data_inicio, data_fim, params[:estado], params[:empresa], params[:tipo]
    render json: lista
  end

  def top_vendedores_implantacoes
    mes = params[:mes]
    data = Time.now

    if data.month != mes
      data_inicio = Time.now.change(month: mes, day: 1).beginning_of_month
      data_fim = Time.now.change(month: mes, day: 1).end_of_month
    else
      data_inicio = Time.now.beginning_of_month
      data_fim =Time.now.end_of_month
    end

    connection = ActiveRecord::Base.connection
    lista = connection.select_all DashboardsResultadosHelper.top_vendedores_implantacoes data_inicio, data_fim, params[:estado], params[:empresa], params[:tipo]

    render json: lista
  end

  def table_efetivacoes
    if params[:data].length.eql? 2
      data_inicio = Time.now.change(month: params[:data], day: 1).beginning_of_month
      data_fim = Time.now.change(month: params[:data], day: 1).end_of_month
    else
      if params[:data].present?
        data_inicio = Time.parse(params[:data]).beginning_of_month
        data_fim = Time.parse(params[:data]).end_of_month
      else
        data_inicio = Time.now.beginning_of_month
        data_fim = Time.now.end_of_month
      end
    end

    connection = ActiveRecord::Base.connection
    lista = connection.select_all DashboardsResultadosTabelasHelper.table_efetivacoes params[:empresa],
                                                                                      params[:estado],
                                                                                      data_inicio,
                                                                                      data_fim,
                                                                                      params[:tipo],
                                                                                      params[:object_id],
                                                                                      params[:efetivacao],
                                                                                      params[:vendedor],
                                                                                      params[:implantador]

    lista = lista.to_hash
    lista.each do |empre|
      connection_fiscal = Financeiro::HonorarioMensal.connection
      honorario_id = connection_fiscal.select_all DashboardsResultadosTabelasHelper.cliente_tem_honorario empre['cnpj']

      empre['honorario_cadastrado'] =  honorario_id.present?
    end

    render json: lista
  end

  def table_implantacoes
    if params[:data].length.eql? 2
      data_inicio = Time.now.change(month: params[:data], day: 1).beginning_of_month
      data_fim = Time.now.change(month: params[:data], day: 1).end_of_month
    else
      data_inicio = Time.parse(params[:data]).beginning_of_month
      data_fim = Time.parse(params[:data]).end_of_month
    end

    connection = ActiveRecord::Base.connection
    lista = connection.select_all DashboardsResultadosTabelasHelper.table_implantacoes params[:empresa],
                                                                                       params[:estado],
                                                                                       data_inicio,
                                                                                       data_fim,
                                                                                       params[:tipo],
                                                                                       params[:object_id],
                                                                                       params[:vendedor],
                                                                                       params[:implantador]

    render json: lista
  end

  def table_desistencia_acompanhamento
    connection = ActiveRecord::Base.connection
    lista = connection.select_all DashboardsResultadosTabelasHelper.table_desistencia_acompanhamento params[:empresa],
                                                                                       params[:estado],
                                                                                       Time.parse(params[:data]).beginning_of_month,
                                                                                       Time.parse(params[:data]).end_of_month,
                                                                                       params[:vendedor],
                                                                                       params[:implantador]

    render json: lista
  end

  def table_desistencia_implantacao
    connection = ActiveRecord::Base.connection
    lista = connection.select_all DashboardsResultadosTabelasHelper.table_desistencia_implantacao params[:empresa],
                                                                                                     params[:estado],
                                                                                                     Time.parse(params[:data]).beginning_of_month,
                                                                                                     Time.parse(params[:data]).end_of_month,
                                                                                                  params[:status],
                                                                                                  params[:vendedor],
                                                                                                  params[:implantador]

    render json: lista
  end

  def table_efetivacoes_financeiro
    connection = Financeiro::HonorarioMensal.connection
    lista = connection.select_all DashboardsResultadosTabelasHelper.table_efetivacoes_financeiro params[:estado],
                                                                                                 params[:empresa],
                                                                                                 Time.parse(params[:data]).beginning_of_month,
                                                                                                 Time.parse(params[:data]).end_of_month

    lista = lista.to_hash
    
    lista.each do |empre|
      cliente = Cliente.find_by_cnpj empre['cpfcnpj']
      if cliente.nil?
        empre['vendedor'] =  'Sem Info.'
        empre['implantador'] =  'Sem Info.'
        empre['dias_sem_uso'] = Cliente.dias_sem_uso empre['cpfcnpj']
        next
      end
      empre['dias_sem_uso'] = Cliente.dias_sem_uso empre['cpfcnpj']

      implantacao = Implantacao.find_by_cliente_id cliente.id
      if implantacao.nil?
        empre['implantador'] =  ''
      else
        empre['implantador'] =  implantacao.user.present? ? implantacao.user.name : ''
      end

      if cliente.fechamento.nil?
        empre['vendedor'] =  ''
      else
        empre['vendedor'] =  cliente.fechamento.user.present? ? cliente.fechamento.user.name : ''
      end
    end

    render json: lista
  end

  def table_efetivacoes_financeiroReal
    connection = Financeiro::HonorarioMensal.connection

    if params[:qtd_debito].eql? '1'
      lista = connection.select_all DashboardsResultadosTabelasHelper.table_efetivacoes_financeiroReal params[:estado],
                                                                                                 params[:empresa],
                                                                                                 Time.parse(params[:data]).beginning_of_month,
                                                                                                 Time.parse(params[:data]).end_of_month
    else
      lista = connection.select_all DashboardsResultadosTabelasHelper.table_efetivacoes_financeiro_2meses params[:estado],
                                                                                                 params[:empresa],
                                                                                                 Time.parse(params[:data]).beginning_of_month,
                                                                                                 Time.parse(params[:data]).end_of_month, params[:qtd_debito].to_i
    end
    lista = lista.to_hash
    
    lista.each do |empre|
      cliente = Cliente.find_by_cnpj empre['cpfcnpj']
      if cliente.nil?
        empre['vendedor'] =  'Sem Info.'
        empre['implantador'] =  'Sem Info.'
        empre['dias_sem_uso'] = Cliente.dias_sem_uso empre['cpfcnpj']
        next
      end
      empre['dias_sem_uso'] = Cliente.dias_sem_uso empre['cpfcnpj']

      implantacao = Implantacao.find_by_cliente_id cliente.id
      if implantacao.nil?
        empre['implantador'] =  ''
      else
        empre['implantador'] =  implantacao.user.present? ? implantacao.user.name : ''
      end

      if cliente.fechamento.nil?
        empre['vendedor'] =  ''
      else
        empre['vendedor'] =  cliente.fechamento.user.present? ? cliente.fechamento.user.name : ''
      end
    end

    render json: lista
  end

  def table_desistencia_financeiro
    connection = Financeiro::HonorarioMensal.connection
    lista = connection.select_all DashboardsResultadosTabelasHelper.table_desistencia_financeiro params[:estado],
                                                                                                 params[:empresa],
                                                                                                 Time.parse(params[:data]).beginning_of_month,
                                                                                                 Time.parse(params[:data]).end_of_month

    lista = lista.to_hash
    lista.each do |empre|
      cliente = Cliente.find_by_cnpj empre['cpfcnpj']
      if cliente.nil?
        empre['vendedor'] =  ''
        empre['implantador'] =  ''
        empre['dias_sem_uso'] = Cliente.dias_sem_uso empre['cpfcnpj']
        next
      end
      empre['dias_sem_uso'] = Cliente.dias_sem_uso empre['cpfcnpj']

      implantacao = Implantacao.find_by_cliente_id cliente.id
      if implantacao.nil?
        empre['implantador'] =  ''
      else
        empre['implantador'] =  implantacao.user.present? ? implantacao.user.name : ''
      end

      if cliente.fechamento.nil?
        empre['vendedor'] =  ''
      else
        empre['vendedor'] = cliente.fechamento.user.present? ? cliente.fechamento.user.name : ''
      end
    end

    render json: lista
  end

  def table_primeira_parcela
    connection = Financeiro::HonorarioMensal.connection
    lista = connection.select_all DashboardsResultadosTabelasHelper.table_primeira_parcela params[:estado],
                                                                                                 params[:empresa],
                                                                                                 Time.parse(params[:data]).beginning_of_month,
                                                                                                 Time.parse(params[:data]).end_of_month,
                                                                                                       params[:tipo]
    
    if params[:tipo] == '2'
      lista = lista.to_hash
      lista.each do |empre|
        empre['dias_sem_uso'] = Cliente.dias_sem_uso empre['cpfcnpj']
        
        cliente = Cliente.find_by_cnpj empre['cpfcnpj']
        if cliente.nil?
          empre['vendedor'] = ' '
          empre['implantador'] = ' '
          next
        end

        if cliente.fechamento.nil?
          empre[:vendedor] =  ''
        else
          empre[:vendedor] = cliente.fechamento.user.name unless cliente.fechamento.user.nil?
        end
      end      
    else
      lista = lista.to_hash
      lista.each do |empre|
        cliente = Cliente.find_by_cnpj empre['cpfcnpj']
        
        if cliente.nil?
          empre['vendedor'] = ''
          empre['implantador'] = ''
          next
        end

        implantacao = Implantacao.find_by_cliente_id cliente.id
        if implantacao.nil?
          empre['implantador'] =  'Parceiro'
        else
          if implantacao.user.nil?
            empre['implantador'] =  ''
          else
            empre['implantador'] =  implantacao.user.name
          end
        end

        if cliente.fechamento.nil?
          empre['vendedor'] =  ''
        else
          empre['vendedor'] = cliente.fechamento.user.name unless cliente.fechamento.user.nil?
        end
      end
    end
    
    render json: lista
  end

  def table_primeira_parcela_instalacao
    connection = Financeiro::HonorarioMensal.connection
    lista = connection.select_all DashboardsResultadosTabelasHelper.table_primeira_parcela_instalacao params[:estado],
                                                                                           params[:empresa],
                                                                                           Time.parse(params[:data]).beginning_of_month,
                                                                                           Time.parse(params[:data]).end_of_month,
                                                                                           params[:tipo]
    
    if params[:tipo] == '2'
      lista = lista.to_hash
      lista.each do |empre|
        empre['dias_sem_uso'] = Cliente.dias_sem_uso empre['cpfcnpj']
        cliente = Cliente.find_by_cnpj empre['cpfcnpj']
        
        if cliente.nil?
          empre['vendedor'] = ' '
          empre['implantador'] = ' '
          next
        end

        if cliente.fechamento.nil?
          empre['vendedor'] =  ''
        else
          empre['vendedor'] = cliente.fechamento.user.name unless cliente.fechamento.user.nil?
        end
        empre['implantador'] = ' '
      end
    else
      lista = lista.to_hash
      lista.each do |empre|
        cliente = Cliente.find_by_cnpj empre['cpfcnpj']
        if cliente.nil?
          empre['vendedor'] = ' '
          empre['implantador'] = ' '
          next
        end

        implantacao = Implantacao.find_by_cliente_id cliente.id
        if implantacao.nil? || implantacao.user.nil?
          empre['implantador'] =  ' '
        else
          empre['implantador'] =  implantacao.user.name
        end

        if cliente.fechamento.nil? || cliente.fechamento.user.nil?
          empre['vendedor'] =  ' '
        else
          empre['vendedor'] =  cliente.fechamento.user.name
        end
      end
    end

    render json: lista
  end

  def table_historico_cobranca_cliente
    connection = Financeiro::HonorarioMensal.connection
    lista = connection.select_all DashboardsResultadosTabelasHelper.table_historico_cobranca_cliente params[:cliente_id],
                                                                                                      params[:empresa]
    render json: lista
  end

  def table_clientes_ativos_bloqueados
    connection = Financeiro::HonorarioMensal.connection
    lista = connection.select_all DashboardsResultadosTabelasHelper.table_clientes_ativos_bloqueados params[:estado],
                                                                                                     params[:empresa],
                                                                                                     params[:tipo],
                                                                                                     Time.parse(params[:data]).end_of_month
    lista = lista.to_hash
    lista.each do |empre|
      empre['dias_sem_uso'] = Cliente.dias_sem_uso empre['cpfcnpj']
    end

    render json: lista
  end

  def table_clientes_bloqueados_atualmente
    connection = Financeiro::HonorarioMensal.connection
    lista = connection.select_all DashboardsResultadosTabelasHelper.table_clientes_bloqueados_atualmente params[:estado],
                                                                                                     params[:empresa],
                                                                                                     Time.parse(params[:data]).end_of_month
    lista = lista.to_hash
    lista.each do |empre|
      empre['dias_sem_uso'] = Cliente.dias_sem_uso empre['cpfcnpj']
    end

    render json: lista
  end


  #--------------------RESUMO_COMERCIAL -------------------

  def resumo_comercial

  end


  #------------------- FUNIL -------------------------------

  def get_dados_funil
    mes = params[:mes]
    ano = params[:ano]

    data_inicio = Time.now.change(month: mes, year: ano).beginning_of_month
    data_fim = Time.now.change(month: mes, year: ano).end_of_month
    connection = ActiveRecord::Base.connection
    funil = connection.select_all DashboardsFunilHelper.funil data_inicio,
                                                              data_fim,
                                                              params[:estado],
                                                              params[:empresa]

    fechamentos = connection.select_all DashboardsFunilHelper.get_acompanhamentos_concluidos_funil data_inicio,
                                                                                    data_fim,
                                                                        params[:estado],
                                                                        params[:empresa]

    connecFinanceiro = Financeiro::HonorarioMensal.connection

    cont = 0
    fechamentos = fechamentos.to_hash
    fechamentos.each do |fechamento|
      primeiraMensalidade = connecFinanceiro.select_all DashboardsFunilHelper.get_primeira_parcela_paga fechamento['cnpj'], params[:empresa]
      if primeiraMensalidade.present? && (primeiraMensalidade[0]['status'].eql? 'PAGO')
        cont += 1
      end
    end

    funil = funil.to_hash

    funil << {'tipo'=> 'PRIMEIRA MENSALIDADE', 'qtd' => cont.to_s, 'perc' => 10}

    render json: funil
  end

  def get_dados_funil_usuario
    mes = params[:mes]
    ano = params[:ano]

    data_inicio = Time.now.change(month: mes, year: ano).beginning_of_month
    data_fim = Time.now.change(month: mes, year: ano).end_of_month
    connection = ActiveRecord::Base.connection
    funil = connection.select_all DashboardsFunilHelper.funil_usuario data_inicio,
                                                              data_fim,
                                                              params[:estado],
                                                              params[:empresa],
                                                              params[:usuario],
                                                              params[:captacao]

    fechamentos = connection.select_all DashboardsFunilHelper.get_acompanhamentos_concluidos_funil_usuario data_inicio,
                                                                                                   data_fim,
                                                                                                   params[:estado],
                                                                                                   params[:empresa],
                                                                                                   params[:usuario],
                                                                                                   params[:captacao]

    connecFinanceiro = Financeiro::HonorarioMensal.connection

    cont = 0
    fechamentos = fechamentos.to_hash
    fechamentos.each do |fechamento|
      primeiraMensalidade = connecFinanceiro.select_all DashboardsFunilHelper.get_primeira_parcela_paga fechamento['cnpj'], params[:empresa]
      if primeiraMensalidade.present? && (primeiraMensalidade[0]['status'].eql? 'PAGO')
        cont += 1
      end
    end

    funil = funil.to_hash

    funil << {'tipo'=> 'PRIMEIRA MENSALIDADE', 'qtd' => cont.to_s, 'perc' => 10}

    render json: funil
  end

  def get_dados_funil_captacao
    mes = params[:mes]
    ano = params[:ano]

    data_inicio = Time.now.change(month: mes, year: ano).beginning_of_month
    data_fim = Time.now.change(month: mes, year: ano).end_of_month
    connection = ActiveRecord::Base.connection
    funil = connection.select_all DashboardsFunilHelper.funil_captacao data_inicio,
                                                                      data_fim,
                                                                      params[:estado],
                                                                      params[:empresa],
                                                                      params[:usuario]

    fechamentos = connection.select_all DashboardsFunilHelper.get_acompanhamentos_concluidos_funil_captacao data_inicio,
                                                                                                           data_fim,
                                                                                                           params[:estado],
                                                                                                           params[:empresa],
                                                                                                           params[:usuario]

    connecFinanceiro = Financeiro::HonorarioMensal.connection

    cont = 0
    fechamentos = fechamentos.to_hash
    fechamentos.each do |fechamento|
      primeiraMensalidade = connecFinanceiro.select_all DashboardsFunilHelper.get_primeira_parcela_paga fechamento['cnpj'], params[:empresa]
      if primeiraMensalidade.present? && (primeiraMensalidade[0]['status'].eql? 'PAGO')
        cont += 1
      end
    end

    funil = funil.to_hash

    funil << {'tipo'=> 'PRIMEIRA MENSALIDADE', 'qtd' => cont.to_s, 'perc' => 10}

    render json: funil
  end

  def get_empresas_funil_status
    mes = params[:mes]
    ano = params[:ano]

    data_inicio = Time.now.change(month: mes, year: ano).beginning_of_month
    data_fim = Time.now.change(month: mes, year: ano).end_of_month
    connection = ActiveRecord::Base.connection

    funil = connection.select_all DashboardsFunilHelper.get_totais_etapas data_inicio,
                                                              data_fim,
                                                              params[:estado],
                                                              params[:empresa]


      fechamentos = connection.select_all DashboardsFunilHelper.get_acompanhamentos_concluidos_funil data_inicio,
                                                                                      data_fim,
                                                                                      params[:estado],
                                                                                      params[:empresa]

      connecFinanceiro = Financeiro::HonorarioMensal.connection

      contPago = 0
      contPendente = 0
      contDesistente = 0

      fechamentos = fechamentos.to_hash
      fechamentos.each do |fechamento|
        primeiraMensalidade = connecFinanceiro.select_all DashboardsFunilHelper.get_primeira_parcela_paga fechamento['cnpj'], params[:empresa]
        contPago += 1 if primeiraMensalidade.present? && (primeiraMensalidade[0]['status'].eql? 'PAGO')
        contPendente += 1 if primeiraMensalidade.present? && (!primeiraMensalidade[0]['status'].eql? 'PAGO') && (primeiraMensalidade[0]['honorario_ativo'].eql? 't')
        contDesistente += 1 if primeiraMensalidade.count < 1 || (primeiraMensalidade[0]['honorario_ativo'].eql? 'f')
      end

      funil = funil.to_hash

      funil << {'tipo'=> 'FINANCEIRO', 'em_andamento' => contPendente.to_s, 'finalizado' => contPago.to_s, 'descartado' => contDesistente.to_s, 'total' => (contPendente + contPago + contDesistente).to_s}

    render json: funil
  end

  def get_empresas_funil_status_usuario
    mes = params[:mes]
    ano = params[:ano]

    data_inicio = Time.now.change(month: mes, year: ano).beginning_of_month
    data_fim = Time.now.change(month: mes, year: ano).end_of_month
    connection = ActiveRecord::Base.connection

    funil = connection.select_all DashboardsFunilHelper.get_totais_etapas_usuario data_inicio,
                                                                          data_fim,
                                                                          params[:estado],
                                                                          params[:empresa],
                                                                          params[:usuario],
                                                                          params[:captacao]


    fechamentos = connection.select_all DashboardsFunilHelper.get_acompanhamentos_concluidos_funil_usuario data_inicio,
                                                                                                   data_fim,
                                                                                                   params[:estado],
                                                                                                   params[:empresa],
                                                                                                   params[:usuario],
                                                                                                   params[:captacao]

    connecFinanceiro = Financeiro::HonorarioMensal.connection

    contPago = 0
    contPendente = 0
    contDesistente = 0

    fechamentos = fechamentos.to_hash
    fechamentos.each do |fechamento|
      primeiraMensalidade = connecFinanceiro.select_all DashboardsFunilHelper.get_primeira_parcela_paga fechamento['cnpj'], params[:empresa]
      contPago += 1 if primeiraMensalidade.present? && (primeiraMensalidade[0]['status'].eql? 'PAGO')
      contPendente += 1 if primeiraMensalidade.present? && (!primeiraMensalidade[0]['status'].eql? 'PAGO') && (primeiraMensalidade[0]['honorario_ativo'].eql? 't')
      contDesistente += 1 if primeiraMensalidade.count < 1 || (primeiraMensalidade[0]['honorario_ativo'].eql? 'f')
    end

    funil = funil.to_hash

    funil << {'tipo'=> 'FINANCEIRO', 'em_andamento' => contPendente.to_s, 'finalizado' => contPago.to_s, 'descartado' => contDesistente.to_s, 'total' => (contPendente + contPago + contDesistente).to_s}

    render json: funil
  end

  def get_empresas_funil_status_captacao
    mes = params[:mes]
    ano = params[:ano]

    data_inicio = Time.now.change(month: mes, year: ano).beginning_of_month
    data_fim = Time.now.change(month: mes, year: ano).end_of_month
    connection = ActiveRecord::Base.connection

    funil = connection.select_all DashboardsFunilHelper.get_totais_etapas_captacao data_inicio,
                                                                                  data_fim,
                                                                                  params[:estado],
                                                                                  params[:empresa],
                                                                                  params[:usuario]


    fechamentos = connection.select_all DashboardsFunilHelper.get_acompanhamentos_concluidos_funil_captacao data_inicio,
                                                                                                           data_fim,
                                                                                                           params[:estado],
                                                                                                           params[:empresa],
                                                                                                           params[:usuario]

    connecFinanceiro = Financeiro::HonorarioMensal.connection

    contPago = 0
    contPendente = 0
    contDesistente = 0

    fechamentos = fechamentos.to_hash
    fechamentos.each do |fechamento|
      primeiraMensalidade = connecFinanceiro.select_all DashboardsFunilHelper.get_primeira_parcela_paga fechamento['cnpj'], params[:empresa]
      contPago += 1 if primeiraMensalidade.present? && (primeiraMensalidade[0]['status'].eql? 'PAGO')
      contPendente += 1 if primeiraMensalidade.present? && (!primeiraMensalidade[0]['status'].eql? 'PAGO') && (primeiraMensalidade[0]['honorario_ativo'].eql? 't')
      contDesistente += 1 if primeiraMensalidade.count < 1 || (primeiraMensalidade[0]['honorario_ativo'].eql? 'f')
    end

    funil = funil.to_hash

    funil << {'tipo'=> 'FINANCEIRO', 'em_andamento' => contPendente.to_s, 'finalizado' => contPago.to_s, 'descartado' => contDesistente.to_s, 'total' => (contPendente + contPago + contDesistente).to_s}

    render json: funil
  end

  #--------------------- RESULTADOS GRUBER------------------

  def resultados_gruber

  end

  def clientes_12_meses_gruber
    connection = Financeiro::HonorarioMensal.connection
    lista = connection.select_all DashboardsResultadosGruberHelper.cliente_12_meses params[:empresa]

    render json: lista
  end

  def table_clientes_gruber
    connection = Financeiro::HonorarioMensal.connection
    lista = connection.select_all DashboardsResultadosGruberHelper.table_clientes_gruber params[:empresa],Time.parse(params[:data]).end_of_month

    render json: lista
  end

  def get_efetivacoes_desativacoes_gruber
    connection = Financeiro::HonorarioMensal.connection
    lista = connection.select_all DashboardsResultadosGruberHelper.get_efetivacoes_desativacoes_gruber params[:empresa]

    render json: lista
  end

  def table_efetivacoes_financeiro_gruber
    connection = Financeiro::HonorarioMensal.connection
    lista = connection.select_all DashboardsResultadosGruberHelper.table_efetivacoes_financeiro_gruber params[:empresa],
                                                                                                 Time.parse(params[:data]).beginning_of_month,
                                                                                                 Time.parse(params[:data]).end_of_month

    render json: lista
  end

  def table_desistencia_financeiro_gruber
    connection = Financeiro::HonorarioMensal.connection
    lista = connection.select_all DashboardsResultadosGruberHelper.table_desistencia_financeiro_gruber params[:empresa],
                                                                                                 Time.parse(params[:data]).beginning_of_month,
                                                                                                 Time.parse(params[:data]).end_of_month

    render json: lista
  end

  def get_total_faturamento_12_meses_gruber
    connection = Financeiro::HonorarioMensal.connection
    lista = connection.select_all DashboardsResultadosGruberHelper.get_total_faturamento_12_meses_gruber params[:empresa]

    render json: lista
  end

  def get_total_faturamento_mes_anterior_gruber
    connection = Financeiro::HonorarioMensal.connection
    lista = connection.select_all DashboardsResultadosGruberHelper.get_total_faturamento_mes_anterior_gruber params[:empresa]

    render json: lista
  end

  def get_demonstrativo_12_meses_gruber
    connection = Financeiro::HonorarioMensal.connection
    lista = connection.select_all DashboardsResultadosGruberHelper.get_demonstrativo_12_meses_gruber params[:empresa]

    render json: lista
  end

  def get_faturamento_por_tipo
    connection = Financeiro::HonorarioMensal.connection
    lista = connection.select_all DashboardsResultadosGruberHelper.get_faturamento_por_tipo params[:empresa], Time.parse(params[:data]).end_of_month

    render json: lista
  end

  def get_inadimplencia_12_meses_gruber
    connection = Financeiro::HonorarioMensal.connection
    lista = connection.select_all DashboardsResultadosGruberHelper.get_inadimplencia_12_meses params[:empresa]

    render json: lista
  end

  def get_total_primeira_honorario
    connection = Financeiro::HonorarioMensal.connection
    lista = connection.select_all DashboardsResultadosGruberHelper.get_primeira_parcela_honorario params[:empresa]

    render json: lista
  end

  def get_total_primeira_honorario_mes_anterior
    connection = Financeiro::HonorarioMensal.connection
    lista = connection.select_all DashboardsResultadosGruberHelper.get_primeira_parcela_honorario_anterior params[:empresa]

    render json: lista
  end

  def get_inadimplencia_tipo_gruber
    connection = Financeiro::HonorarioMensal.connection
    lista = connection.select_all DashboardsResultadosGruberHelper.get_inadimplencia_por_tipo params[:empresa], Time.parse(params[:data]).end_of_month

    render json: lista
  end

  def table_primeira_parcela_honorario
    connection = Financeiro::HonorarioMensal.connection
    lista = connection.select_all DashboardsResultadosGruberHelper.table_primeira_parcela_honorario params[:tipo],
                                                                                           params[:empresa],
                                                                                           Time.parse(params[:data]).beginning_of_month,
                                                                                           Time.parse(params[:data]).end_of_month

    render json: lista
  end


  #DASH DE PROJECOES

  def get_projecao_honorario_12_meses
    connection = Financeiro::HonorarioMensal.connection
    lista = connection.select_all DashboardsResultadosHelper.get_projecao_honorario_12_meses params[:estado], params[:empresa], params[:tipo_cobranca]

    render json: lista
  end

  def get_projecao_instalacao_12_meses
    connection = Financeiro::HonorarioMensal.connection
    lista = connection.select_all DashboardsResultadosHelper.get_projecao_instalacao_6_meses params[:estado], params[:empresa]

    render json: lista
  end


  def get_projecao_faturamento
    connection = Financeiro::HonorarioMensal.connection
    if params[:tipo_analise_projecao_faturamento] == 'FATURAMENTO'
      lista = connection.select_all DashboardsResultadosHelper.get_projecao_faturamento params[:estado], params[:empresa], params[:qtd_meses_analise_faturamento].to_i
    else
      lista = connection.select_all DashboardsResultadosHelper.get_projecao_recebimento params[:estado], params[:empresa], params[:qtd_meses_analise_faturamento].to_i
    end

    render json: lista
  end

  def get_projecao_clientes
    connection = Financeiro::HonorarioMensal.connection
    lista = connection.select_all DashboardsResultadosHelper.get_projecao_clientes params[:estado], params[:empresa], params[:qtd_meses_analise_clientes].to_i, params[:tipo_cobranca]

    render json: lista
  end

  def get_projecao_faturamento_honorario
    connection = Financeiro::HonorarioMensal.connection    
    lista = connection.select_all DashboardsResultadosHelper.get_projecao_faturamento_honorario params[:estado], params[:empresa], params[:qtd_meses_analise_honorario].to_i
    
    render json: lista
  end

  def exportar_lista_empresas_xlsx
    empresa = Empresa.find params[:empresa_id]
    params[:nono_digito] = params[:nono_digito].present? ? true : false
    respond_to do |format|
      format.xlsx {
        response.headers[
          'Content-Disposition'
          ] = "attachment; filename='importacoes.xlsx'"
        }
      format.html { render :index }
    end
  end

  def empresas_centro_distribuicao
    preferidos = Estado.estados_preferidos
    demais = Estado.estados_demais
    @preferencia = Array.new
    totais_preferencia = {'estado': 'Total', 'total': 0, 'job0':0 ,'job1': 0, 'job2': 0, 'job3': 0, 'job4': 0}
    preferidos.each do |estado|
      est = FilaEmpresa.contar_empresas_centro_distribuicao(estado.sigla, 1, 20)
      @preferencia << est
      totais_preferencia[:total] += est[:total]
      totais_preferencia[:job0] += est[:job0]
      totais_preferencia[:job1] += est[:job1]
      totais_preferencia[:job2] += est[:job2]
      totais_preferencia[:job3] += est[:job3]
      totais_preferencia[:job4] += est[:job4]
    end

    @demais = Array.new
    totais_demais = {'estado': 'Total', 'total': 0, 'job0':0 , 'job1': 0, 'job2': 0, 'job3': 0, 'job4': 0}
    demais.each do |estado|
      est = FilaEmpresa.contar_empresas_centro_distribuicao(estado.sigla, 1, 20)
      @demais << est
      totais_demais[:total] += est[:total]
      totais_demais[:job0] += est[:job0]
      totais_demais[:job1] += est[:job1]
      totais_demais[:job2] += est[:job2]
      totais_demais[:job3] += est[:job3]
      totais_demais[:job4] += est[:job4]
    end
    @preferencia = @preferencia.sort_by{|obj| obj[:total]}.reverse!
    @demais = @demais.sort_by{|obj| obj[:total]}.reverse!

    @preferencia << totais_preferencia
    @demais << totais_demais
  end

  def create_fila_empresas_centro_distribuicao
    DistribuirFilaCentroDistribuicao.new(empresa_id: params[:empresa_id], estado_id: params[:estado_id]).call
    render json: {message: 'Processo iniciado'}, status: 201
  end

  def desistencias
    @tags_desistencia = TagsSolicitacaoDesistencia.sem_tags_troca_cnpj
  end

  def desistentes_por_tags
    connection = ActiveRecord::Base.connection

    response = connection.select_all DashboardsHelper.get_qtd_clientes_por_tag_desistencia params[:datainicial], params[:datafinal]
    render json: response
  end

  def clientes_bloqueados
    connection = Financeiro::HonorarioMensal.connection
    lista = connection.select_all DashboardsResultadosHelper.get_clientes_bloqueados Date.parse(params[:datainicial]).strftime('%Y-%m-%d'), Date.parse(params[:datafinal]).strftime('%Y-%m-%d'), params[:empresas]

    render json: lista
  end

  def buscar_info_desistentes_por_tag
    connection = ActiveRecord::Base.connection
    lista = connection.select_all DashboardsResultadosHelper.get_infos_por_tag_desistencia Date.parse(params[:datainicial]).strftime('%Y-%m-%d'), Date.parse(params[:datafinal]).strftime('%Y-%m-%d'), params[:tags]

    render json: lista
  end

  def comparacao_tags_mensal
    connection = ActiveRecord::Base.connection
    lista = connection.select_all DashboardsResultadosHelper.get_comparacao_tags_mensal params[:primeiro_mes], params[:segundo_mes], params[:tags]

    render json: lista
  end

  private

  def tratar_ranking(fechamentos)
    fechamentos.each do |fechamento|
      fechamento['valor'] = 0 if fechamento['id'] != current_user.id.to_s
      fechamento['media'] = 0 if fechamento['id'] != current_user.id.to_s
    end
    return fechamentos
  end 

end
