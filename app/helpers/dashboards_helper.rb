module DashboardsHelper

  def self.get_valores_implantacao(data_inicio, data_fim, empresa, vendedor, implantador, somenteNovos, fechamentoMes, estado, efetivo)

    if data_inicio.present? && data_fim.present?
      diff = TimeDifference.between(Date.parse(data_fim),Date.parse(data_inicio)).in_days
      data_fim_anterior = Date.parse(data_inicio) - 1.day
      data_inicio_anterior = data_fim_anterior - diff.day
    end


    sql = "with parametros as (
            select #{data_inicio.present? ? "'" + data_inicio + "'": 'null'}::date as dataInicio,
              #{ data_fim.present? ? ("'" + data_fim + "'") : 'null'}::date as dataFim,
              #{ data_inicio_anterior.present? ? ("'" + data_inicio_anterior.to_s + "'") : 'null'}::date as dataInicioAnterior,
              #{ data_fim_anterior.present? ? ("'" + data_fim_anterior.to_s + "'") : 'null'}::date as dataFimAnterior,
              #{ vendedor.present? ? vendedor : 'null'}::int as vendedor_id,
              #{ implantador.present? ? implantador : 'null'}::int as implantador_id,
              #{ estado.present? ? (ApplicationHelper.get_estado_by_codigo(estado)) : 'null'}::int as estado_id,
              #{ somenteNovos } as somenteNovos,
              #{ fechamentoMes } as fechamentoMes
          ),
          	periodo_anterior as (
            select 'CONCLUIDO' as tipo, coalesce(count(i.id),0) as qtd, coalesce(sum(p.valor_mensalidade),0) as valorMensalidade, coalesce(sum(p.valor_implantacao),0) as valorImplantacao
            from implantacoes i
            inner join parametros on true
            left join fechamentos f on f.id =  (select max(id) from fechamentos where cliente_id = i.cliente_id)
            inner join propostas p on p.id = (select id from propostas where propostas.cliente_id = i.cliente_id and propostas.ativa is true order by id desc limit 1)
            left join clientes cliente on cliente.id = i.cliente_id
            left join cidades cidade on cidade.id = cliente.cidade_id
            where (parametros.dataInicioAnterior is null or i.data_fim::date >= parametros.dataInicioAnterior)
	            and (parametros.dataFimAnterior is null or i.data_fim::date <= parametros.dataFimAnterior)
              and i.empresa_id in (#{ ApplicationHelper.get_empresas_by_codigo(empresa) })
              and (parametros.implantador_id is null or i.user_id = parametros.implantador_id)
              and (parametros.vendedor_id is null or f.user_id = parametros.vendedor_id)
              and (parametros.estado_id is null or cidade.estado_id = parametros.estado_id)
              and (parametros.fechamentoMes is false or ((parametros.dataInicioAnterior is null or f.data_fechamento::date >= parametros.dataInicioAnterior) and (parametros.dataFimAnterior is null or f.data_fechamento::date <= parametros.dataFimAnterior)))
              and status = 9"
              sql += "

            UNION ALL

	         select 'EM ANDAMENTO' as tipo, coalesce(count(i.id), 0) as qtd, coalesce(sum(p.valor_mensalidade),0) as valorMensalidade, coalesce(sum(p.valor_implantacao),0) as valorImplantacao
            from implantacoes i
            inner join parametros on true
            inner join fechamentos f on f.cliente_id = i.cliente_id
            inner join propostas p on p.id = (select id from propostas where propostas.cliente_id = i.cliente_id and propostas.ativa is true order by id desc limit 1)
            where i.id in (
              select distinct i.id
              from implantacoes i
              inner join parametros on true
              left join fechamentos f on f.id =  (select max(id) from fechamentos where cliente_id = i.cliente_id)
              inner join propostas p on p.id = (select id from propostas where propostas.cliente_id = i.cliente_id and propostas.ativa is true order by id desc limit 1)
              left join activities activity on activity.recipient_id = i.id and activity.trackable_type = 'Implantacao'
              left join clientes cliente on cliente.id = i.cliente_id
              left join cidades cidade on cidade.id = cliente.cidade_id
              where (parametros.somenteNovos is false or
                  ((parametros.dataInicioAnterior is null or i.data_inicio::date >= parametros.dataInicioAnterior or
                  parametros.dataInicioAnterior is null or activity.created_at::date >= parametros.dataInicioAnterior) and
                  (parametros.dataFimAnterior is null or i.data_fim::date <= parametros.dataFimAnterior or
                  parametros.dataFimAnterior is null or activity.created_at::date <= parametros.dataFimAnterior)))
              and i.empresa_id in (#{ ApplicationHelper.get_empresas_by_codigo(empresa) })
              and (parametros.implantador_id is null or i.user_id = parametros.implantador_id)
              and (parametros.vendedor_id is null or f.user_id = parametros.vendedor_id)
              and (parametros.estado_id is null or cidade.estado_id = parametros.estado_id)
              and (parametros.fechamentoMes is false or ((parametros.dataInicioAnterior is null or f.data_fechamento::date >= parametros.dataInicioAnterior) and (parametros.dataFimAnterior is null or f.data_fechamento::date <= parametros.dataFimAnterior)))
              and status in(3,4,5)"

              sql += "
            )


            UNION ALL

	          select  'AGUARDANDO' as tipo, coalesce(count(i.id),0) as qtd, coalesce(sum(p.valor_mensalidade),0) as valorMensalidade, coalesce(sum(p.valor_implantacao),0) as valorImplantacao
            from implantacoes i
            left join parametros on true
            left join fechamentos f on f.id =  (select max(id) from fechamentos where cliente_id = i.cliente_id)
            left join propostas p on p.id = (select id from propostas where propostas.cliente_id = i.cliente_id and propostas.ativa is true order by id desc limit 1)
            left join clientes cli on cli.id = i.cliente_id
            where i.id in(
                select  distinct i.id
                from implantacoes i
                left join parametros on true
                left join fechamentos f on f.id =  (select max(id) from fechamentos where cliente_id = i.cliente_id)
                left join propostas p on p.id = (select id from propostas where propostas.cliente_id = i.cliente_id and propostas.ativa is true order by id desc limit 1)
                left join clientes cli on cli.id = i.cliente_id
                left join cidades cidade on cidade.id = cli.cidade_id
                left join activities activity on activity.recipient_id = i.id and activity.trackable_type = 'Implantacao'
                where (parametros.somenteNovos is false or
                    ((parametros.dataInicioAnterior is null or i.created_at >= parametros.dataInicioAnterior or
                    parametros.dataInicioAnterior is null or activity.created_at::date >= parametros.dataInicioAnterior) and
                    (parametros.dataFimAnterior is null or i.created_at <= parametros.dataFimAnterior or
                    parametros.dataFimAnterior is null or activity.created_at::date <= parametros.dataFimAnterior)))
                 and status in(0,1)
                and i.empresa_id in (#{ ApplicationHelper.get_empresas_by_codigo(empresa) })"
                sql += "
                and (parametros.implantador_id is null or i.user_id = parametros.implantador_id)
                and (parametros.vendedor_id is null or f.user_id = parametros.vendedor_id)
                and (parametros.estado_id is null or cidade.estado_id = parametros.estado_id)
                and (parametros.fechamentoMes is false or ((parametros.dataInicioAnterior is null or f.data_fechamento::date >= parametros.dataInicioAnterior) and (parametros.dataFimAnterior is null or f.data_fechamento::date <= parametros.dataFimAnterior)))
              )

            UNION ALL

            select  'STAND BY' as tipo, coalesce(count(i.id),0) as qtd, coalesce(sum(p.valor_mensalidade),0) as valorMensalidade, coalesce(sum(p.valor_implantacao),0) as valorImplantacao
            from implantacoes i
            left join parametros on true
            left join fechamentos f on f.id =  (select max(id) from fechamentos where cliente_id = i.cliente_id)
            left join propostas p on p.id = (select id from propostas where propostas.cliente_id = i.cliente_id and propostas.ativa is true order by id desc limit 1)
            left join clientes cli on cli.id = i.cliente_id
            where i.id in(
                select  distinct i.id
                from implantacoes i
                left join parametros on true
                left join fechamentos f on f.id =  (select max(id) from fechamentos where cliente_id = i.cliente_id)
                left join propostas p on p.id = (select id from propostas where propostas.cliente_id = i.cliente_id and propostas.ativa is true order by id desc limit 1)
                left join clientes cli on cli.id = i.cliente_id
                left join cidades cidade on cidade.id = cli.cidade_id
                left join activities activity on activity.recipient_id = i.id and activity.trackable_type = 'Implantacao'
                where (parametros.somenteNovos is false or
                    ((parametros.dataInicioAnterior is null or i.created_at >= parametros.dataInicioAnterior or
                    parametros.dataInicioAnterior is null or activity.created_at::date >= parametros.dataInicioAnterior) and
                    (parametros.dataFimAnterior is null or i.created_at <= parametros.dataFimAnterior or
                    parametros.dataFimAnterior is null or activity.created_at::date <= parametros.dataFimAnterior)))
                 and status in(2,6,10)
                and i.empresa_id in (#{ ApplicationHelper.get_empresas_by_codigo(empresa) })"
                sql += "
                and (parametros.implantador_id is null or i.user_id = parametros.implantador_id)
                and (parametros.vendedor_id is null or f.user_id = parametros.vendedor_id)
                and (parametros.estado_id is null or cidade.estado_id = parametros.estado_id)
                and (parametros.fechamentoMes is false or ((parametros.dataInicioAnterior is null or f.data_fechamento::date >= parametros.dataInicioAnterior) and (parametros.dataFimAnterior is null or f.data_fechamento::date <= parametros.dataFimAnterior)))
              )

              UNION ALL

            select 'DESISTENTE' as tipo, coalesce(count(i.id),0) as qtd, coalesce(sum(p.valor_mensalidade),0) as valorMensalidade, coalesce(sum(p.valor_implantacao),0) as valorImplantacao
            from implantacoes i
            inner join parametros on true
            inner join fechamentos f on f.id =  (select max(id) from fechamentos where cliente_id = i.cliente_id)
            inner join propostas p on p.id = (select id from propostas where propostas.cliente_id = i.cliente_id and propostas.ativa is true order by id desc limit 1)
            inner join activities a on a.id = (select id from activities where recipient_id = i.id and (key = 'implantacao.desistente_pre' or key = 'implantacao.desistente_implantacao') order by id desc limit 1)
            left join clientes cliente on cliente.id = i.cliente_id
            left join cidades cidade on cidade.id = cliente.cidade_id
            where ((parametros.dataInicioAnterior is null or a.created_at::date >= parametros.dataInicioAnterior) and
		              (parametros.dataFimAnterior is null or a.created_at::date <= parametros.dataFimAnterior))
              and i.empresa_id in (#{ ApplicationHelper.get_empresas_by_codigo(empresa) })"
              sql += "
              and (parametros.implantador_id is null or i.user_id = parametros.implantador_id)
              and (parametros.vendedor_id is null or f.user_id = parametros.vendedor_id)
              and (parametros.estado_id is null or cidade.estado_id = parametros.estado_id)
              and (parametros.fechamentoMes is false or ((parametros.dataInicioAnterior is null or f.data_fechamento::date >= parametros.dataInicioAnterior) and (parametros.dataFimAnterior is null or f.data_fechamento::date <= parametros.dataFimAnterior)))
              and status in(7,8)

          ),
          qtd_dias AS
            ( SELECT CASE
                         WHEN count(DISTINCT data_inicio::date) = 0 THEN 1
                         ELSE count(DISTINCT data_inicio::date)
                     END AS count
             FROM ligacoes
             inner join parametros on true
             WHERE data_inicio between dataInicio and dataFim
               and empresa_id in  (#{ ApplicationHelper.get_empresas_by_codigo(empresa) }) 
          ),
          periodo_atual as (
            select 'CONCLUIDO' as tipo, coalesce(count(i.id),0) as qtd, coalesce(sum(p.valor_mensalidade),0) as valorMensalidade, coalesce(sum(p.valor_implantacao),0) as valorImplantacao
            from implantacoes i
            inner join parametros on true
            left join fechamentos f on f.id =  (select max(id) from fechamentos where cliente_id = i.cliente_id)
            inner join propostas p on p.id = (select id from propostas where propostas.cliente_id = i.cliente_id and propostas.ativa is true order by id desc limit 1)
            left join clientes cliente on cliente.id = i.cliente_id
            left join cidades cidade on cidade.id = cliente.cidade_id
            where (parametros.dataInicio is null or i.data_fim::date >= parametros.dataInicio)
	            and (parametros.dataFim is null or i.data_fim::date <= parametros.dataFim)
              and i.empresa_id in (#{ ApplicationHelper.get_empresas_by_codigo(empresa) })
              and (parametros.implantador_id is null or i.user_id = parametros.implantador_id)
              and (parametros.vendedor_id is null or f.user_id = parametros.vendedor_id)
              and (parametros.estado_id is null or cidade.estado_id = parametros.estado_id)
              and (parametros.fechamentoMes is false or ((parametros.dataInicio is null or f.data_fechamento::date >= date_trunc('month',parametros.dataInicio)::date) and (parametros.dataFim is null or f.data_fechamento::date <= date_trunc('month',parametros.dataFim) + interval '1 month'  - interval '1 day')))
              and status = 9"
              sql += "

            UNION ALL

            select 'EM ANDAMENTO' as tipo, coalesce(count(i.id), 0) as qtd, coalesce(sum(p.valor_mensalidade),0) as valorMensalidade, coalesce(sum(p.valor_implantacao),0) as valorImplantacao
            from implantacoes i
            inner join parametros on true
            inner join fechamentos f on f.id =  (select max(id) from fechamentos where cliente_id = i.cliente_id)
            inner join propostas p on p.id = (select id from propostas where propostas.cliente_id = i.cliente_id and propostas.ativa is true order by id desc limit 1)
            where i.id in (
              select distinct i.id
              from implantacoes i
              inner join parametros on true
              left join fechamentos f on f.id =  (select max(id) from fechamentos where cliente_id = i.cliente_id)
              inner join propostas p on p.id = (select id from propostas where propostas.cliente_id = i.cliente_id and propostas.ativa is true order by id desc limit 1)
              left join activities activity on activity.recipient_id = i.id and activity.trackable_type = 'Implantacao'
              left join clientes cliente on cliente.id = i.cliente_id
              left join cidades cidade on cidade.id = cliente.cidade_id
              where (parametros.somenteNovos is false or
                    ((parametros.dataInicio is null or i.data_inicio::date >= parametros.dataInicio or
                    parametros.dataInicio is null or activity.created_at::date >= parametros.dataInicio) and
                    (parametros.dataFim is null or i.data_fim::date <= parametros.dataFim or
                    parametros.dataFim is null or activity.created_at::date <= parametros.dataFim)))
              and i.empresa_id in (#{ ApplicationHelper.get_empresas_by_codigo(empresa) })
              and (parametros.implantador_id is null or i.user_id = parametros.implantador_id)
              and (parametros.vendedor_id is null or f.user_id = parametros.vendedor_id)
              and (parametros.estado_id is null or cidade.estado_id = parametros.estado_id)
              and (parametros.fechamentoMes is false or ((parametros.dataInicio is null or f.data_fechamento::date >= date_trunc('month',parametros.dataInicio)::date) and (parametros.dataFim is null or f.data_fechamento::date <= date_trunc('month',parametros.dataFim) + interval '1 month'  - interval '1 day')))
              and status in(3,4,5)"
              sql += "
            )


            UNION ALL

            select  'AGUARDANDO' as tipo, coalesce(count(i.id),0) as qtd, coalesce(sum(p.valor_mensalidade),0) as valorMensalidade, coalesce(sum(p.valor_implantacao),0) as valorImplantacao
            from implantacoes i
            left join parametros on true
            left join fechamentos f on f.id =  (select max(id) from fechamentos where cliente_id = i.cliente_id)
            left join propostas p on p.id = (select id from propostas where propostas.cliente_id = i.cliente_id and propostas.ativa is true order by id desc limit 1)
            left join clientes cli on cli.id = i.cliente_id
            where i.id in(
              select  distinct i.id
                from implantacoes i
                left join parametros on true
                left join fechamentos f on f.id =  (select max(id) from fechamentos where cliente_id = i.cliente_id)
                left join propostas p on p.id = (select id from propostas where propostas.cliente_id = i.cliente_id and propostas.ativa is true order by id desc limit 1)
                left join clientes cli on cli.id = i.cliente_id
                left join cidades cidade on cidade.id = cli.cidade_id
                left join activities activity on activity.recipient_id = i.id and activity.trackable_type = 'Implantacao'
                 where (parametros.somenteNovos is false or
                  ((parametros.dataInicio is null or i.created_at >= parametros.dataInicio or
                  parametros.dataInicio is null or activity.created_at::date >= parametros.dataInicio) and
                  (parametros.dataFim is null or i.created_at <= parametros.dataFim or
                  parametros.dataFim is null or activity.created_at::date <= parametros.dataFim)))
                and status in(0,1)
                and i.empresa_id in (#{ ApplicationHelper.get_empresas_by_codigo(empresa) })"
                sql += "
                and (parametros.implantador_id is null or i.user_id = parametros.implantador_id)
                and (parametros.vendedor_id is null or f.user_id = parametros.vendedor_id)
                and (parametros.estado_id is null or cidade.estado_id = parametros.estado_id)
                and (parametros.fechamentoMes is false or ((parametros.dataInicio is null or f.data_fechamento::date >= date_trunc('month',parametros.dataInicio)::date) and (parametros.dataFim is null or f.data_fechamento::date <= date_trunc('month',parametros.dataFim) + interval '1 month'  - interval '1 day')))
              )

            UNION ALL

            select  'STAND BY' as tipo, coalesce(count(i.id),0) as qtd, coalesce(sum(p.valor_mensalidade),0) as valorMensalidade, coalesce(sum(p.valor_implantacao),0) as valorImplantacao
            from implantacoes i
            left join parametros on true
            left join fechamentos f on f.id =  (select max(id) from fechamentos where cliente_id = i.cliente_id)
            left join propostas p on p.id = (select id from propostas where propostas.cliente_id = i.cliente_id and propostas.ativa is true order by id desc limit 1)
            left join clientes cli on cli.id = i.cliente_id
            where i.id in(
              select  distinct i.id
                from implantacoes i
                left join parametros on true
                left join fechamentos f on f.id =  (select max(id) from fechamentos where cliente_id = i.cliente_id)
                left join propostas p on p.id = (select id from propostas where propostas.cliente_id = i.cliente_id and propostas.ativa is true order by id desc limit 1)
                left join clientes cli on cli.id = i.cliente_id
                left join cidades cidade on cidade.id = cli.cidade_id
                left join activities activity on activity.recipient_id = i.id and activity.trackable_type = 'Implantacao'
                 where (parametros.somenteNovos is false or
                  ((parametros.dataInicio is null or i.created_at >= parametros.dataInicio or
                  parametros.dataInicio is null or activity.created_at::date >= parametros.dataInicio) and
                  (parametros.dataFim is null or i.created_at <= parametros.dataFim or
                  parametros.dataFim is null or activity.created_at::date <= parametros.dataFim)))
                and status in(2,6,10)
                and i.empresa_id in (#{ ApplicationHelper.get_empresas_by_codigo(empresa) })"
                sql += "
                and (parametros.implantador_id is null or i.user_id = parametros.implantador_id)
                and (parametros.vendedor_id is null or f.user_id = parametros.vendedor_id)
                and (parametros.estado_id is null or cidade.estado_id = parametros.estado_id)
                and (parametros.fechamentoMes is false or ((parametros.dataInicio is null or f.data_fechamento::date >= date_trunc('month',parametros.dataInicio)::date) and (parametros.dataFim is null or f.data_fechamento::date <= date_trunc('month',parametros.dataFim) + interval '1 month'  - interval '1 day')))
              )

            UNION ALL

            select 'DESISTENTE' as tipo, coalesce(count(i.id),0) as qtd, coalesce(sum(p.valor_mensalidade),0) as valorMensalidade, coalesce(sum(p.valor_implantacao),0) as valorImplantacao
            from implantacoes i
            inner join parametros on true
            inner join fechamentos f on f.id =  (select max(id) from fechamentos where cliente_id = i.cliente_id)
            inner join propostas p on p.id = (select id from propostas where propostas.cliente_id = i.cliente_id and propostas.ativa is true order by id desc limit 1)
            inner join activities a on a.id = (select id from activities where recipient_id = i.id and (key = 'implantacao.desistente_pre' or key = 'implantacao.desistente_implantacao') order by id desc limit 1)
            left join clientes cliente on cliente.id = i.cliente_id
            left join cidades cidade on cidade.id = cliente.cidade_id
            where ((parametros.dataInicio is null or a.created_at::date >= parametros.dataInicio) and
		            (parametros.dataFim is null or a.created_at::date <= parametros.dataFim))
              and i.empresa_id in (#{ ApplicationHelper.get_empresas_by_codigo(empresa) })"
              sql += "
              and (parametros.implantador_id is null or i.user_id = parametros.implantador_id)
              and (parametros.vendedor_id is null or f.user_id = parametros.vendedor_id)
              and (parametros.estado_id is null or cidade.estado_id = parametros.estado_id)
              and (parametros.fechamentoMes is false or ((parametros.dataInicio is null or f.data_fechamento::date >= date_trunc('month',parametros.dataInicio)::date) and (parametros.dataFim is null or f.data_fechamento::date <= date_trunc('month',parametros.dataFim) + interval '1 month'  - interval '1 day')))
              and status in(7,8)

          ),
          sql as (
            select 	atual.tipo,
              atual.qtd as qtdAtual,
              atual.valormensalidade as valormensalidadeatual,
              atual.valorimplantacao as valorimplantacaoatual,
              coalesce(anterior.qtd,0) as qtdanterior,
              coalesce(anterior.valormensalidade,0) as valormensalidadeanterior,
              coalesce(anterior.valorimplantacao,0) as valorimplantacaoanterior,
              ROUND(atual.valormensalidade/(case when atual.qtd = 0 then 1 else atual.qtd end),2) media_mensalidade,
              ROUND(atual.valorimplantacao/(case when atual.qtd = 0 then 1 else atual.qtd end),2) media_implantacao,
              ROUND(atual.qtd::numeric/qtd_dias.count,2) media_quantidade,
              qtd_dias.count as qtddias,
              case when anterior.valormensalidade > atual.valormensalidade then
                coalesce(ROUND((1 - (atual.valormensalidade/(case when anterior.valormensalidade = 0 then 1 else anterior.valormensalidade end)))*100, 2), 0)
                   else
                coalesce(ROUND(((atual.valormensalidade/(case when anterior.valormensalidade = 0 then 1 else anterior.valormensalidade end)) - 1)*100, 2), 0)
                    end as perc_mensalidade,
                  case when anterior.valorimplantacao > atual.valorimplantacao then
                coalesce(ROUND((1 - (atual.valorimplantacao/(case when anterior.valorimplantacao = 0 then 1 else anterior.valorimplantacao end)))*100, 2), 0)
                  else
                coalesce(ROUND(((atual.valorimplantacao/(case when anterior.valorimplantacao = 0 then 1 else anterior.valorimplantacao end)) - 1)*100, 2), 0)
                  end as perc_implantacao,
                  case when anterior.qtd > atual.qtd then
			              coalesce(ROUND((1 - (atual.qtd::numeric/(case when anterior.qtd = 0 then 1 else anterior.qtd end)))*100, 2), 0)
                  else
			              coalesce(ROUND(((atual.qtd::numeric/(case when anterior.qtd = 0 then 1 else anterior.qtd end)) - 1)*100, 2), 0)
                  end as perc_quantidade
            from periodo_atual atual
            left join periodo_anterior anterior on anterior.tipo = atual.tipo
            inner join qtd_dias on true
          )

          select 	tipo,
            qtdAtual,
            valormensalidadeatual,
            valorimplantacaoatual,
            qtdanterior,
            valormensalidadeanterior,
            valorimplantacaoanterior,
            media_mensalidade,
            media_implantacao,
            media_quantidade,
            qtddias,
            case when perc_mensalidade > 100 then 100 else perc_mensalidade end as perc_mensalidade,
            case when perc_implantacao > 100 then 100 else perc_implantacao end as perc_implantacao,
            case when perc_quantidade > 100 then 100 else perc_quantidade end as perc_quantidade
          from sql"
  end

  def self.get_implantacoes_concluidas(data_inicio, data_fim, empresa, vendedor, implantador, fechamentoMes, estado, efetivo)
    sql = "with parametros as (
            select #{data_inicio.present? ? "'" + data_inicio + "'": 'null'}::date as dataInicio,
              #{data_fim.present? ? ("'" + data_fim + "'") : 'null'}::date as dataFim,
              #{ vendedor.present? ? vendedor : 'null'}::int as vendedor_id,
              #{ implantador.present? ? implantador : 'null'}::int as implantador_id,
              #{ estado.present? ? (ApplicationHelper.get_estado_by_codigo(estado)) : 'null'}::int as estado_id,
              #{ fechamentoMes } as fechamentoMes
          )
          select sis.nome as sistema, coalesce(sum(p.valor_mensalidade),0) totalmensalidade, coalesce(sum(p.valor_implantacao), 0) as totalimplantacao, count(sis.id), sis.id
          from implantacoes i
          inner join parametros on true
          inner join fechamentos f on f.cliente_id = i.cliente_id
          inner join propostas p on p.id = (select id from propostas where propostas.cliente_id = i.cliente_id and propostas.ativa is true order by id desc limit 1)
          inner join pacotes pac on pac.id = p.pacote_id
          inner join sistemas sis on sis.id = pac.sistema_id
          left join clientes cliente on cliente.id = i.cliente_id
          left join cidades cidade on cidade.id = cliente.cidade_id
          where (parametros.dataInicio is null or i.data_fim::date >= parametros.dataInicio)
          and (parametros.dataFim is null or i.data_fim::date <= parametros.dataFim)
          and  i.empresa_id in (#{ ApplicationHelper.get_empresas_by_codigo(empresa) })
          and (parametros.implantador_id is null or i.user_id = parametros.implantador_id)
          and (parametros.vendedor_id is null or f.user_id = parametros.vendedor_id)
          and (parametros.estado_id is null or cidade.estado_id = parametros.estado_id)
          and (parametros.fechamentoMes is false or ((parametros.dataInicio is null or f.data_fechamento::date >= parametros.dataInicio) and (parametros.dataFim is null or f.data_fechamento::date <= parametros.dataFim)))
          and status = 9 "

            sql += "group by sis.nome, sis.id
"
  end

  def self.get_implantacoes_andamento(data_inicio, data_fim, empresa, vendedor, implantador, novos, fechamentoMes, estado)
    sql = "with parametros as (
            select #{data_inicio.present? ? "'" + data_inicio + "'": 'null'}::date as dataInicio,
              #{data_fim.present? ? ("'" + data_fim + "'") : 'null'}::date as dataFim,
              #{ vendedor.present? ? vendedor : 'null'}::int as vendedor_id,
              #{ implantador.present? ? implantador : 'null'}::int as implantador_id,
              #{ estado.present? ? (ApplicationHelper.get_estado_by_codigo(estado)) : 'null'}::int as estado_id,
              #{ novos } as somenteNovos,
              #{ fechamentoMes } as fechamentoMes
          )
          select distinct sis.nome as sistema, coalesce(sum(p.valor_mensalidade),0) totalmensalidade, coalesce(sum(p.valor_implantacao), 0) as totalimplantacao, count(sis.id), sis.id
          from implantacoes i
          inner join parametros on true
          inner join fechamentos f on f.id =  (select max(id) from fechamentos where cliente_id = i.cliente_id)
          inner join propostas p on p.id = (select id from propostas where propostas.cliente_id = i.cliente_id and propostas.ativa is true order by id desc limit 1)
          inner join pacotes pac on pac.id = p.pacote_id
          inner join sistemas sis on sis.id = pac.sistema_id
          where i.id in (
          select distinct i.id
            from implantacoes i
            inner join parametros on true
            inner join fechamentos f on f.id =  (select max(id) from fechamentos where cliente_id = i.cliente_id)
            inner join propostas p on p.id = (select id from propostas where propostas.cliente_id = i.cliente_id and propostas.ativa is true order by id desc limit 1)
            inner join pacotes pac on pac.id = p.pacote_id
            inner join sistemas sis on sis.id = pac.sistema_id
            left join clientes cliente on cliente.id = i.cliente_id
            left join cidades cidade on cidade.id = cliente.cidade_id
            left join activities activity on activity.recipient_id = i.id and activity.trackable_type = 'Implantacao'
            where (parametros.somenteNovos is false or
                  ((parametros.dataInicio is null or i.created_at >= parametros.dataInicio or
                  parametros.dataInicio is null or activity.created_at::date >= parametros.dataInicio) and
                  (parametros.dataFim is null or i.created_at <= parametros.dataFim or
                  parametros.dataFim is null or activity.created_at::date <= parametros.dataFim)))
            and  i.empresa_id in (#{ ApplicationHelper.get_empresas_by_codigo(empresa) })
            and (parametros.implantador_id is null or i.user_id = parametros.implantador_id)
            and (parametros.vendedor_id is null or f.user_id = parametros.vendedor_id)
            and (parametros.estado_id is null or cidade.estado_id = parametros.estado_id)
            and (parametros.fechamentoMes is false or ((parametros.dataInicio is null or f.data_fechamento::date >= parametros.dataInicio) and (parametros.dataFim is null or f.data_fechamento::date <= parametros.dataFim)))
            and status in(3,4,5)
	        )
	        group by sis.nome, sis.id
"
  end

  def self.get_implantacoes_aguardando(data_inicio, data_fim, empresa, vendedor, implantador, somenteNovos, fechamentoMes, estado)
    sql = "with parametros as (
            select #{data_inicio.present? ? "'" + data_inicio + "'": 'null'}::date as dataInicio,
              #{data_fim.present? ? ("'" + data_fim + "'") : 'null'}::date as dataFim,
              #{ vendedor.present? ? vendedor : 'null'}::int as vendedor_id,
              #{ implantador.present? ? implantador : 'null'}::int as implantador_id,
              #{ estado.present? ? (ApplicationHelper.get_estado_by_codigo(estado)) : 'null'}::int as estado_id,
              #{ somenteNovos } as somenteNovos,
              #{ fechamentoMes } as fechamentoMes
          )
          select sis.nome as sistema, coalesce(sum(p.valor_mensalidade),0) totalmensalidade, coalesce(sum(p.valor_implantacao), 0) as totalimplantacao, count(sis.id), sis.id
          from implantacoes i
          inner join parametros on true
          inner join fechamentos f on f.id =  (select max(id) from fechamentos where cliente_id = i.cliente_id)
          inner join propostas p on p.id = (select id from propostas where propostas.cliente_id = i.cliente_id and propostas.ativa is true order by id desc limit 1)
          inner join pacotes pac on pac.id = p.pacote_id
          inner join sistemas sis on sis.id = pac.sistema_id
          where i.id in (
            select distinct i.id
            from implantacoes i
            inner join parametros on true
            inner join fechamentos f on f.id =  (select max(id) from fechamentos where cliente_id = i.cliente_id)
            inner join propostas p on p.id = (select id from propostas where propostas.cliente_id = i.cliente_id and propostas.ativa is true order by id desc limit 1)
            inner join pacotes pac on pac.id = p.pacote_id
            inner join sistemas sis on sis.id = pac.sistema_id
            left join clientes cliente on cliente.id = i.cliente_id
            left join cidades cidade on cidade.id = cliente.cidade_id
            left join activities activity on activity.recipient_id = i.id and activity.trackable_type = 'Implantacao'
            where (parametros.somenteNovos is false or ((parametros.dataInicio is null or i.created_at::date >= parametros.dataInicio) or (parametros.dataInicio is null or activity.created_at::date >= parametros.dataInicio)))
            and (parametros.somenteNovos is false or ((parametros.dataFim is null or i.created_at::date <= parametros.dataFim) or (parametros.dataFim is null or activity.created_at::date <= parametros.dataFim)))
            and i.empresa_id in (#{ ApplicationHelper.get_empresas_by_codigo(empresa) })
            and (parametros.implantador_id is null or i.user_id = parametros.implantador_id)
            and (parametros.vendedor_id is null or f.user_id = parametros.vendedor_id)
            and (parametros.fechamentoMes is false or ((parametros.dataInicio is null or f.data_fechamento::date >= parametros.dataInicio) and (parametros.dataFim is null or f.data_fechamento::date <= parametros.dataFim)))
            and (parametros.estado_id is null or cidade.estado_id = parametros.estado_id)
            and status in(0,1)
          )
          group by sis.nome, sis.id
"
  end

  def self.get_implantacoes_desistente(data_inicio, data_fim, empresa, vendedor, implantador, fechamentoMes, estado, efetivo)
    sql = "with parametros as (
            select #{data_inicio.present? ? "'" + data_inicio + "'": 'null'}::date as dataInicio,
              #{data_fim.present? ? ("'" + data_fim + "'") : 'null'}::date as dataFim,
              #{ vendedor.present? ? vendedor : 'null'}::int as vendedor_id,
              #{ estado.present? ? (ApplicationHelper.get_estado_by_codigo(estado)) : 'null'}::int as estado_id,
              #{ implantador.present? ? implantador : 'null'}::int as implantador_id,
              #{ fechamentoMes } as fechamentoMes
          )
          select sis.nome as sistema, coalesce(sum(p.valor_mensalidade),0) totalmensalidade, coalesce(sum(p.valor_implantacao), 0) as totalimplantacao, count(sis.id), sis.id
          from implantacoes i
          inner join parametros on true
          inner join fechamentos f on f.id =  (select max(id) from fechamentos where cliente_id = i.cliente_id)
          inner join propostas p on p.id = (select id from propostas where propostas.cliente_id = i.cliente_id and propostas.ativa is true order by id desc limit 1)
          inner join pacotes pac on pac.id = p.pacote_id
          inner join sistemas sis on sis.id = pac.sistema_id
          left join clientes cliente on cliente.id = i.cliente_id
          left join cidades cidade on cidade.id = cliente.cidade_id
          inner join activities a on a.id = (select id from activities where recipient_id = i.id and (key = 'implantacao.desistente_pre' or key = 'implantacao.desistente_implantacao') order by id desc limit 1)
          where (parametros.dataInicio is null or a.created_at::date >= parametros.dataInicio)
          and (parametros.dataFim is null or a.created_at::date <= parametros.dataFim)
          and i.empresa_id in (#{ ApplicationHelper.get_empresas_by_codigo(empresa) })
          and (parametros.implantador_id is null or i.user_id = parametros.implantador_id)
          and (parametros.vendedor_id is null or f.user_id = parametros.vendedor_id)
          and (parametros.fechamentoMes is false or ((parametros.dataInicio is null or f.data_fechamento::date >= parametros.dataInicio) and (parametros.dataFim is null or f.data_fechamento::date <= parametros.dataFim)))
          and (parametros.estado_id is null or cidade.estado_id = parametros.estado_id)
          and status in(7,8)"
          sql +="group by sis.nome, sis.id
"
  end

  def self.get_implantacoes_cidades(data_inicio, data_fim, empresa, vendedor, implantador)
    sql = "with parametros as (
            select #{data_inicio.present? ? "'" + data_inicio + "'": 'null'}::date as dataInicio,
              #{data_fim.present? ? ("'" + data_fim + "'") : 'null'}::date as dataFim,
              #{ empresa.present? ? empresa : 'null'}::int as empresa_id,
              #{ vendedor.present? ? vendedor : 'null'}::int as vendedor_id,
              #{ implantador.present? ? implantador : 'null'}::int as implantador_id
          )
         select cidades.nome || ' - ' || e.sigla as cidade, coalesce(sum(p.valor_mensalidade),0) totalmensalidade, coalesce(sum(p.valor_implantacao), 0) as totalimplantacao, count(cidades.id), cidades.id
          from implantacoes i
          inner join parametros on true
          inner join fechamentos f on f.id =  (select max(id) from fechamentos where cliente_id = i.cliente_id)
          inner join propostas p on p.id = (select id from propostas where propostas.cliente_id = i.cliente_id and propostas.ativa is true order by id desc limit 1)
          inner join pacotes pac on pac.id = p.pacote_id
          inner join sistemas sis on sis.id = pac.sistema_id
          inner join clientes cli on cli.id = i.cliente_id
          inner join cidades on cidades.id = cli.cidade_id
          inner join estados e on e.id = cidades.estado_id
          where i.data_fim::date between parametros.dataInicio and parametros.dataFim
          and (parametros.empresa_id is null or i.empresa_id =  parametros.empresa_id)
          and (parametros.implantador_id is null or i.user_id = parametros.implantador_id)
          and (parametros.vendedor_id is null or f.user_id = parametros.vendedor_id)
          and status = 9
          group by cidades.nome, cidades.id, e.sigla
          order by count(cidades.id) desc
"
  end

  def self.get_top_implantadores(data_inicio, data_fim, empresa, estado, efetivo)
    sql = "
        with parametros as (
            select #{data_inicio.present? ? "'" + data_inicio + "'": 'null'}::date as dataInicio,
              #{data_fim.present? ? ("'" + data_fim + "'") : 'null'}::date as dataFim,
              #{ estado.present? ? (ApplicationHelper.get_estado_by_codigo(estado)) : 'null'}::int as estado_id
          ),
          concluidas as (
                      select u.id, u.name, count(i.id) as qtd, sum(p.valor_mensalidade) as mensalidade, sum(p.valor_implantacao) as implantacao
                      from implantacoes i
                      inner join parametros on true
                      inner join fechamentos f on f.id =  (select max(id) from fechamentos where cliente_id = i.cliente_id)
                      inner join propostas p on p.id = (select id from propostas where propostas.cliente_id = i.cliente_id and propostas.ativa is true order by id desc limit 1)
                      inner join users u on u.id = i.user_id
                      left join clientes cliente on cliente.id = i.cliente_id
                      left join cidades cidade on cidade.id = cliente.cidade_id
                      where (parametros.dataInicio is null or i.data_fim::date >= parametros.dataInicio)
                        and (parametros.dataFim is null or i.data_fim::date <= parametros.dataFim)
                        and i.empresa_id in (#{ ApplicationHelper.get_empresas_by_codigo(empresa) })
                        and (parametros.estado_id is null or cidade.estado_id = parametros.estado_id)
                        and status = 9"
                 sql +="    group by u.id, u.name
            )

          select 	users.id, users.name as nome, coalesce(c.qtd, 0)as concluidas, coalesce(c.mensalidade, 0) as mensalidade_concluida,
            coalesce(c.implantacao, 0) as implantacao_concluida
          from users
          left join concluidas c on c.id = users.id
          where (c.qtd is not null)
          order by coalesce(c.mensalidade,0) desc"
  end

  def self.get_top_estados_implantacao(data_inicio, data_fim, empresa, efetivo)
    sql = "
        with parametros as (
          select #{data_inicio.present? ? "'" + data_inicio + "'": 'null'}::date as dataInicio,
            #{data_fim.present? ? ("'" + data_fim + "'") : 'null'}::date as dataFim
        ),
        concluidas as (
                      select e.sigla, count(i.id) as qtd, sum(p.valor_mensalidade) as valor,
                            ROUND(sum(coalesce(p.valor_mensalidade, 0))/count(i.id), 2) AS media
                      from implantacoes i
                      inner join parametros on true
                      inner join fechamentos f on f.id =  (select max(id) from fechamentos where cliente_id = i.cliente_id)
                      inner join propostas p on p.id = (select id from propostas where propostas.cliente_id = i.cliente_id and propostas.ativa is true order by id desc limit 1)
                      inner join users u on u.id = i.user_id
                      left join clientes cliente on cliente.id = i.cliente_id
                      left join cidades cidade on cidade.id = cliente.cidade_id
                      left join estados e on e.id = cidade.estado_id
                      where (parametros.dataInicio is null or i.data_fim::date >= parametros.dataInicio)
                        and (parametros.dataFim is null or i.data_fim::date <= parametros.dataFim)
                        and i.empresa_id in (#{ ApplicationHelper.get_empresas_by_codigo(empresa) })
                        and status = 9"
                      sql += "group by e.sigla
            )

          select 	*
          from concluidas c
          where (c.qtd is not null)
          order by coalesce(c.valor,0) desc"
  end

  def self.get_implantacoes_table(data_inicio, data_fim, empresa, vendedor, implantador, status, somenteNovos, fechamentoMes, estado, efetivo)
    html = " with parametros as (
            select #{data_inicio.present? ? "'" + data_inicio + "'": 'null'}::date as dataInicio,
              #{data_fim.present? ? ("'" + data_fim + "'") : 'null'}::date as dataFim,
              #{ vendedor.present? ? vendedor : 'null'}::int as vendedor_id,
              #{ implantador.present? ? implantador : 'null'}::int as implantador_id,
              #{ somenteNovos } as somenteNovos,
              #{ fechamentoMes } as fechamentoMes,
              #{ estado.present? ? (ApplicationHelper.get_estado_by_codigo(estado)) : 'null'}::int as estado_id
          )

          select distinct i.id as implantacaoId, c.id as clienteId, c.cnpj, c.razao_social, sis.id as sistemaId, sis.nome as sistema,
            p.valor_implantacao, p.valor_mensalidade, vend.name as vendedor, cidade.nome || '-' || estado.sigla as cidade,
            impl.name as implantador,  i.motivo as motivo, 
          #{ status == '(7,8)' ? ' a.created_at ': ''}
          #{ status == '(0,1)' ? ' i.created_at ': ''}
          #{ status == '(2,6,10)' ? ' i.created_at ': ''}
          #{ status == '(3,4,5)' ? ' i.data_inicio ': ''}
          #{ status == '(9)' ? ' i.data_fim ': ''} as data, #{ status } as teste,
          #{ (status == '(7,8)' or status == '(9)') ? ' (i.data_fim::date - i.data_inicio::date) ': ''}
          #{ status == '(0,1)' ? ' (current_date - i.created_at::date) ': ''}
          #{ status == '(2,6,10)' ? ' (current_date - act_stand.created_at::date) ': ''}
          #{ status == '(3,4,5)' ? ' (current_date - i.data_inicio::date) ': ''} as tempo,
          retorno.data_agendamento_retorno,
          agendamento.data_inicio as prox_agendamento
          from implantacoes i
          inner join parametros on true
          inner join clientes c on c.id = i.cliente_id
          left join users impl on impl.id = i.user_id
          left join fechamentos f on f.id =  (select max(id) from fechamentos where cliente_id = i.cliente_id)
          left join users vend on vend.id = f.user_id
          left join propostas p on p.id = (select id from propostas where propostas.cliente_id = i.cliente_id and propostas.ativa is true order by id desc limit 1)
          left join pacotes pac on pac.id = p.pacote_id
          left join sistemas sis on sis.id = pac.sistema_id
          left join cidades cidade on cidade.id = c.cidade_id
          left join estados estado on estado.id = cidade.estado_id
          left join agendamentos agendamento on agendamento.id = (select id from agendamentos where cliente_id = i.cliente_id and implantacao_id = i.id and data_inicio::date >= CURRENT_DATE order by data_inicio desc limit 1)
          left join agendamento_retornos retorno on retorno.id = (select id from agendamento_retornos where cliente_id = i.cliente_id and implantacao_id = i.id and data_efetuado_retorno is null order by data_efetuado_retorno desc limit 1)
          left join activities a on a.id = (select id from activities where recipient_id = i.id and (key = 'implantacao.desistente_pre' or key = 'implantacao.desistente_implantacao') order by id desc limit 1)
          left join activities activity on activity.recipient_id = i.id and activity.trackable_type = 'Implantacao'
          #{ status == '(2,6,10)' ? " left join activities act_stand on act_stand.id = (select max(id) from activities where trackable_type = 'Implantacao' and recipient_id = i.id and (key like '%aguardando%' or key like '%limbo%') )  ": ''}
          where i.status in #{ status }
          #{ status == '(7,8)' ? ' and a.created_at::date between parametros.dataInicio and parametros.dataFim': ''}
          #{ status == '(0,1)' ? ' and (parametros.somenteNovos is false or ((parametros.dataInicio is null or activity.created_at::date >= parametros.dataInicio) or (parametros.dataInicio is null or activity.created_at::date >= parametros.dataInicio)))
            and (parametros.somenteNovos is false or ((parametros.dataFim is null or activity.created_at::date <= parametros.dataFim) or (parametros.dataFim is null or activity.created_at::date <= parametros.dataFim)))': ''}
          #{ status == '(2,6,10)' ? ' and (parametros.somenteNovos is false or ((parametros.dataInicio is null or activity.created_at::date >= parametros.dataInicio) or (parametros.dataInicio is null or activity.created_at::date >= parametros.dataInicio)))
            and (parametros.somenteNovos is false or ((parametros.dataFim is null or activity.created_at::date <= parametros.dataFim) or (parametros.dataFim is null or activity.created_at::date <= parametros.dataFim)))': ''}
          #{ status == '(3,4,5)' ?  ' and (parametros.somenteNovos is false or ((parametros.dataInicio is null or activity.created_at::date >= parametros.dataInicio) or (parametros.dataInicio is null or activity.created_at::date >= parametros.dataInicio)))
                                        and (parametros.somenteNovos is false or ((parametros.dataFim is null or activity.created_at::date <= parametros.dataFim) or (parametros.dataFim is null or activity.created_at::date <= parametros.dataFim))) ': ''}
          #{ status == '(9)' ? ' and i.data_fim::date between parametros.dataInicio and parametros.dataFim': ''}
          and i.empresa_id in (#{ ApplicationHelper.get_empresas_by_codigo(empresa) })
          and (parametros.implantador_id is null or i.user_id = parametros.implantador_id)
          and (parametros.vendedor_id is null or f.user_id = parametros.vendedor_id)
          and (parametros.estado_id is null or cidade.estado_id = parametros.estado_id)"
          html += "
          order by  retorno.data_agendamento_retorno  nulls first, #{ status == '(7,8)' ? ' a.created_at ': ''}
                    #{ status == '(0,1)' ? ' i.created_at ': ''}
                    #{ status == '(2,6,10)' ? ' i.created_at ': ''}
                    #{ status == '(3,4,5)' ? ' i.data_inicio ': ''}
                    #{ status == '(9)' ? ' i.data_fim ': ''} asc
      "
  end


  def self.get_valores_acompanhamentos(data_inicio, data_fim, empresa, vendedor, responsavel, somenteNovos, implantador, estado, ocultar_efetivas, efetivo)
    diff = TimeDifference.between(Date.parse(data_inicio), Date.parse(data_fim)).in_days.to_i
    data_fim_anterior = Date.parse(data_inicio) - 1.day
    data_inicio_anterior = data_fim_anterior - diff.day

    sql = "with parametros as (
            select '#{data_inicio}'::date as dataInicio,
              '#{data_fim}'::date as dataFim,
              '#{data_inicio_anterior}'::date as dataInicioAnterior,
              '#{data_fim_anterior}'::date as dataFimAnterior,
              #{ estado.present? ? (ApplicationHelper.get_estado_by_codigo(estado)) : 'null'}::int as estado_id,
              #{ vendedor.present? ? vendedor : 'null'}::int as vendedor_id,
              #{ responsavel.present? ? responsavel : 'null'}::int as responsavel_id,
              #{ implantador.present? ? implantador : 'null'}::int as implantador_id,
              #{ somenteNovos } as somenteNovos,
              #{ ocultar_efetivas } as ocultar_efetivas
          ),
                    periodo_anterior as (
            select 'CONCLUIDO' as tipo, coalesce(count(a.id),0) as qtd, coalesce(sum(p.valor_mensalidade),0) as valorMensalidade, coalesce(sum(p.valor_implantacao),0) as valorImplantacao
            from acompanhamentos a
            inner join parametros on true
            inner join fechamentos f on f.cliente_id = a.cliente_id
            inner join propostas p on p.id = (select id from propostas where propostas.cliente_id = a.cliente_id and propostas.ativa is true order by id desc limit 1)
            left join clientes cliente on cliente.id = a.cliente_id
            left join cidades cidade on cidade.id = cliente.cidade_id
            left join implantacoes implantacao on implantacao.cliente_id = a.cliente_id
            where a.data_fim::date between parametros.dataInicioAnterior and parametros.dataFimAnterior
              and a.empresa_id in (#{ ApplicationHelper.get_empresas_by_codigo(empresa) })
              and (parametros.responsavel_id is null or a.user_id = parametros.responsavel_id)
              and (parametros.vendedor_id is null or f.user_id = parametros.vendedor_id)
              and (parametros.implantador_id is null or implantacao.user_id = parametros.implantador_id)
              and (parametros.estado_id is null or cidade.estado_id = parametros.estado_id)
              and a.status = 5 "
              sql += "

            UNION ALL

            select 'EM ANDAMENTO' as tipo, coalesce(count(a.id),0) as qtd, coalesce(sum(p.valor_mensalidade),0) as valorMensalidade,coalesce(sum(p.valor_implantacao),0) as valorImplantacao
            from implantacoes a
            inner join parametros on true
            inner join fechamentos f on f.cliente_id = a.cliente_id
            inner join propostas p on p.id = (select id from propostas where propostas.cliente_id = a.cliente_id and propostas.ativa is true order by id desc limit 1)
            left join clientes cliente on cliente.id = a.cliente_id
            left join cidades cidade on cidade.id = cliente.cidade_id
            left join implantacoes implantacao on implantacao.cliente_id = a.cliente_id
            where (parametros.somenteNovos is false or a.data_inicio::date between parametros.dataInicioAnterior and parametros.dataFimAnterior)
              and a.empresa_id in (#{ ApplicationHelper.get_empresas_by_codigo(empresa) })
              and (parametros.responsavel_id is null or a.user_id = parametros.responsavel_id)
              and (parametros.vendedor_id is null or f.user_id = parametros.vendedor_id)
              and (parametros.implantador_id is null or implantacao.user_id = parametros.implantador_id)
              and (parametros.estado_id is null or cidade.estado_id = parametros.estado_id)
              and a.status in(1)
              and (parametros.ocultar_efetivas is false) "
              sql += "

              UNION ALL

              select 'STAND BY' as tipo, coalesce(count(a.id), 0) as qtd, coalesce(sum(p.valor_mensalidade),0) as valorMensalidade, coalesce(sum(p.valor_implantacao),0) as valorImplantacao
            from acompanhamentos a
            inner join parametros on true
            inner join fechamentos f on f.cliente_id = a.cliente_id
            inner join propostas p on p.id = (select id from propostas where propostas.cliente_id = a.cliente_id and propostas.ativa is true order by id desc limit 1)
            left join clientes cliente on cliente.id = a.cliente_id
            left join cidades cidade on cidade.id = cliente.cidade_id
            left join implantacoes implantacao on implantacao.cliente_id = a.cliente_id
            left join activities ac on ac.id = (select id from activities where recipient_id = a.id and (key = 'acompanhamento.pausada') order by id desc limit 1)
            where (parametros.somenteNovos is false or ac.created_at::date between parametros.dataInicioAnterior and parametros.dataFimAnterior)
              and a.empresa_id in (#{ ApplicationHelper.get_empresas_by_codigo(empresa) })
              and (parametros.responsavel_id is null or a.user_id = parametros.responsavel_id)
              and (parametros.vendedor_id is null or f.user_id = parametros.vendedor_id)
              and (parametros.implantador_id is null or implantacao.user_id = parametros.implantador_id)
              and (parametros.estado_id is null or cidade.estado_id = parametros.estado_id)
              and a.status in(2)
              and (parametros.ocultar_efetivas is false) "
              sql += "

            UNION ALL


            select 'AGUARDANDO' as tipo, coalesce(count(a.id),0) as qtd, coalesce(sum(p.valor_mensalidade),0) as valorMensalidade, coalesce(sum(p.valor_implantacao),0) as valorImplantacao
            from acompanhamentos a
            inner join parametros on true
            inner join fechamentos f on f.cliente_id = a.cliente_id
            inner join propostas p on p.id = (select id from propostas where propostas.cliente_id = a.cliente_id and propostas.ativa is true order by id desc limit 1)
            left join clientes cliente on cliente.id = a.cliente_id
            left join cidades cidade on cidade.id = cliente.cidade_id
            left join implantacoes implantacao on implantacao.cliente_id = a.cliente_id
            where (parametros.somenteNovos is false or a.created_at::date between parametros.dataInicioAnterior and parametros.dataFimAnterior)
              and a.empresa_id in (#{ ApplicationHelper.get_empresas_by_codigo(empresa) })
              and (parametros.responsavel_id is null or a.user_id = parametros.responsavel_id)
              and (parametros.vendedor_id is null or f.user_id = parametros.vendedor_id)
              and (parametros.implantador_id is null or implantacao.user_id = parametros.implantador_id)
              and (parametros.estado_id is null or cidade.estado_id = parametros.estado_id)
              and a.status in(0)
              and (parametros.ocultar_efetivas is false) "
              sql += "

              UNION ALL

            select 'DESISTENTE' as tipo, coalesce(count(a.id),0) as qtd, coalesce(sum(p.valor_mensalidade),0) as valorMensalidade, coalesce(sum(p.valor_implantacao),0) as valorImplantacao
            from acompanhamentos a
            inner join parametros on true
            inner join fechamentos f on f.cliente_id = a.cliente_id
            inner join propostas p on p.id = (select id from propostas where propostas.cliente_id = a.cliente_id and propostas.ativa is true order by id desc limit 1)
            left join implantacoes implantacao on implantacao.cliente_id = a.cliente_id
            left join clientes cliente on cliente.id = a.cliente_id
            left join cidades cidade on cidade.id = cliente.cidade_id
            where a.data_fim::date between parametros.dataInicioAnterior and parametros.dataFimAnterior
              and a.empresa_id in (#{ ApplicationHelper.get_empresas_by_codigo(empresa) })
              and (parametros.responsavel_id is null or a.user_id = parametros.responsavel_id)
              and (parametros.vendedor_id is null or f.user_id = parametros.vendedor_id)
              and (parametros.implantador_id is null or implantacao.user_id = parametros.implantador_id)
              and (parametros.estado_id is null or cidade.estado_id = parametros.estado_id)
              and a.status in(3,4) "
              sql += "

          ),
          qtd_dias AS
            ( SELECT CASE
                         WHEN count(DISTINCT data_inicio::date) = 0 THEN 1
                         ELSE count(DISTINCT data_inicio::date)
                     END AS qtd_dias
             FROM ligacoes
             inner join parametros on true
             WHERE data_inicio between dataInicio and dataFim
               and empresa_id in  (#{ ApplicationHelper.get_empresas_by_codigo(empresa) }) 
          ),
          periodo_atual as (
            select 'CONCLUIDO' as tipo, coalesce(count(a.id),0) as qtd, coalesce(sum(p.valor_mensalidade),0) as valorMensalidade, coalesce(sum(p.valor_implantacao),0) as valorImplantacao
            from acompanhamentos a
            inner join parametros on true
            inner join fechamentos f on f.cliente_id = a.cliente_id
            inner join propostas p on p.id = (select id from propostas where propostas.cliente_id = a.cliente_id and propostas.ativa is true order by id desc limit 1)
            left join clientes cliente on cliente.id = a.cliente_id
            left join cidades cidade on cidade.id = cliente.cidade_id
            left join implantacoes implantacao on implantacao.cliente_id = a.cliente_id
            where a.data_fim::date between parametros.dataInicio and parametros.dataFim
              and a.empresa_id in (#{ ApplicationHelper.get_empresas_by_codigo(empresa) })
              and (parametros.responsavel_id is null or a.user_id = parametros.responsavel_id)
              and (parametros.vendedor_id is null or f.user_id = parametros.vendedor_id)
              and (parametros.implantador_id is null or implantacao.user_id = parametros.implantador_id)
              and (parametros.estado_id is null or cidade.estado_id = parametros.estado_id)
              and a.status = 5 "
              sql += "

            UNION ALL

            select 'EM ANDAMENTO' as tipo, coalesce(count(a.id), 0) as qtd, coalesce(sum(p.valor_mensalidade),0) as valorMensalidade, coalesce(sum(p.valor_implantacao),0) as valorImplantacao
            from acompanhamentos a
            inner join parametros on true
            inner join fechamentos f on f.cliente_id = a.cliente_id
            inner join propostas p on p.id = (select id from propostas where propostas.cliente_id = a.cliente_id and propostas.ativa is true order by id desc limit 1)
            left join clientes cliente on cliente.id = a.cliente_id
            left join cidades cidade on cidade.id = cliente.cidade_id
            left join implantacoes implantacao on implantacao.cliente_id = a.cliente_id
            where (parametros.somenteNovos is false or a.data_inicio::date between parametros.dataInicio and parametros.dataFim)
              and a.empresa_id in (#{ ApplicationHelper.get_empresas_by_codigo(empresa) })
              and (parametros.responsavel_id is null or a.user_id = parametros.responsavel_id)
              and (parametros.vendedor_id is null or f.user_id = parametros.vendedor_id)
              and (parametros.implantador_id is null or implantacao.user_id = parametros.implantador_id)
              and (parametros.estado_id is null or cidade.estado_id = parametros.estado_id)
              and a.status in(1)
              and (parametros.ocultar_efetivas is false) "
              sql += "

            UNION ALL

            select 'STAND BY' as tipo, coalesce(count(a.id), 0) as qtd, coalesce(sum(p.valor_mensalidade),0) as valorMensalidade, coalesce(sum(p.valor_implantacao),0) as valorImplantacao
            from acompanhamentos a
            inner join parametros on true
            inner join fechamentos f on f.cliente_id = a.cliente_id
            inner join propostas p on p.id = (select id from propostas where propostas.cliente_id = a.cliente_id and propostas.ativa is true order by id desc limit 1)
            left join clientes cliente on cliente.id = a.cliente_id
            left join cidades cidade on cidade.id = cliente.cidade_id
            left join implantacoes implantacao on implantacao.cliente_id = a.cliente_id
            left join activities ac on ac.id = (select id from activities where recipient_id = a.id and (key = 'acompanhamento.pausada') order by id desc limit 1)
            where (parametros.somenteNovos is false or ac.created_at::date between parametros.dataInicio and parametros.dataFim)
              and a.empresa_id in (#{ ApplicationHelper.get_empresas_by_codigo(empresa) })
              and (parametros.responsavel_id is null or a.user_id = parametros.responsavel_id)
              and (parametros.vendedor_id is null or f.user_id = parametros.vendedor_id)
              and (parametros.implantador_id is null or implantacao.user_id = parametros.implantador_id)
              and (parametros.estado_id is null or cidade.estado_id = parametros.estado_id)
              and a.status in(2)
              and (parametros.ocultar_efetivas is false) "
              sql += "

            UNION ALL

            select 'AGUARDANDO' as tipo, coalesce(count(a.id),0) as qtd, coalesce(sum(p.valor_mensalidade),0) as valorMensalidade, coalesce(sum(p.valor_implantacao),0) as valorImplantacao
            from acompanhamentos a
            inner join parametros on true
            inner join fechamentos f on f.cliente_id = a.cliente_id
            inner join propostas p on p.id = (select id from propostas where propostas.cliente_id = a.cliente_id and propostas.ativa is true order by id desc limit 1)
            left join clientes cliente on cliente.id = a.cliente_id
            left join cidades cidade on cidade.id = cliente.cidade_id
            left join implantacoes implantacao on implantacao.cliente_id = a.cliente_id
            where (parametros.somenteNovos is false or a.created_at::date between parametros.dataInicio and parametros.dataFim)
              and a.empresa_id in (#{ ApplicationHelper.get_empresas_by_codigo(empresa) })
              and (parametros.responsavel_id is null or a.user_id = parametros.responsavel_id)
              and (parametros.vendedor_id is null or f.user_id = parametros.vendedor_id)
              and (parametros.implantador_id is null or implantacao.user_id = parametros.implantador_id)
              and (parametros.estado_id is null or cidade.estado_id = parametros.estado_id)
              and a.status in(0)
              and (parametros.ocultar_efetivas is false) "
              sql += "

            UNION ALL

            select 'DESISTENTE' as tipo, coalesce(count(a.id),0) as qtd, coalesce(sum(p.valor_mensalidade),0) as valorMensalidade, coalesce(sum(p.valor_implantacao),0) as valorImplantacao
            from acompanhamentos a
            inner join parametros on true
            inner join fechamentos f on f.cliente_id = a.cliente_id
            inner join propostas p on p.id = (select id from propostas where propostas.cliente_id = a.cliente_id and propostas.ativa is true order by id desc limit 1)
            left join implantacoes implantacao on implantacao.cliente_id = a.cliente_id
            left join clientes cliente on cliente.id = a.cliente_id
            left join cidades cidade on cidade.id = cliente.cidade_id
            where a.data_fim::date between parametros.dataInicio and parametros.dataFim
              and a.empresa_id in (#{ ApplicationHelper.get_empresas_by_codigo(empresa) })
              and (parametros.responsavel_id is null or a.user_id = parametros.responsavel_id)
              and (parametros.vendedor_id is null or f.user_id = parametros.vendedor_id)
              and (parametros.implantador_id is null or implantacao.user_id = parametros.implantador_id)
              and (parametros.estado_id is null or cidade.estado_id = parametros.estado_id)
              and a.status in(3,4) "
              sql += "

          ),

          sql as (
            select 	atual.tipo,
              atual.qtd as qtdAtual,
              atual.valormensalidade as valormensalidadeatual,
              atual.valorimplantacao as valorimplantacaoatual,
              anterior.qtd as qtdanterior,
              anterior.valormensalidade as valormensalidadeanterior,
              anterior.valorimplantacao as valorimplantacaoanterior,
              ROUND(atual.valormensalidade/(case when atual.qtd = 0 then 1 else atual.qtd end),2) media_mensalidade,
              ROUND(atual.valorimplantacao/(case when atual.qtd = 0 then 1 else atual.qtd end),2) media_implantacao,
              ROUND(atual.qtd::numeric/qtd_dias.qtd_dias,2) media_quantidade,
              qtd_dias.qtd_dias as qtddias,
              case when anterior.valormensalidade > atual.valormensalidade then
                coalesce(ROUND((1 - (atual.valormensalidade/(case when anterior.valormensalidade = 0 then 1 else anterior.valormensalidade end)))*100, 2), 0)
                   else
                coalesce(ROUND(((atual.valormensalidade/(case when anterior.valormensalidade = 0 then 1 else anterior.valormensalidade end)) - 1)*100, 2), 0)
                    end as perc_mensalidade,
                  case when anterior.valorimplantacao > atual.valorimplantacao then
                coalesce(ROUND((1 - (atual.valorimplantacao/(case when anterior.valorimplantacao = 0 then 1 else anterior.valorimplantacao end)))*100, 2), 0)
                  else
                coalesce(ROUND(((atual.valorimplantacao/(case when anterior.valorimplantacao = 0 then 1 else anterior.valorimplantacao end)) - 1)*100, 2), 0)
                  end as perc_implantacao,
                  case when anterior.qtd > atual.qtd then
			              coalesce(ROUND((1 - (atual.qtd::numeric/(case when anterior.qtd = 0 then 1 else anterior.qtd end)))*100, 2), 0)
                  else
			              coalesce(ROUND(((atual.qtd::numeric/(case when anterior.qtd = 0 then 1 else anterior.qtd end)) - 1)*100, 2), 0)
                  end as perc_quantidade
            from periodo_atual atual
            inner join periodo_anterior anterior on anterior.tipo = atual.tipo
		inner join qtd_dias on true
          )

          select 	tipo,
            qtdAtual,
            valormensalidadeatual,
            valorimplantacaoatual,
            qtdanterior,
            valormensalidadeanterior,
            valorimplantacaoanterior,
            media_mensalidade,
            media_implantacao,
            media_quantidade,
            qtddias,
            case when perc_mensalidade > 100 then 100 else perc_mensalidade end as perc_mensalidade,
            case when perc_implantacao > 100 then 100 else perc_implantacao end as perc_implantacao,
            case when perc_quantidade > 100 then 100 else perc_quantidade end as perc_quantidade
          from sql"
  end

  def self.get_acompanhamentos_concluidas(data_inicio, data_fim, empresa, vendedor, responsavel, implantador, estado, efetivo)
    sql = "with parametros as (
            select '#{data_inicio}'::date as dataInicio,
              '#{data_fim}'::date as dataFim,
              #{ vendedor.present? ? vendedor : 'null'}::int as vendedor_id,
              #{ responsavel.present? ? responsavel : 'null'}::int as responsavel_id,
              #{ implantador.present? ? implantador : 'null'}::int as implantador_id,
              #{ estado.present? ? (ApplicationHelper.get_estado_by_codigo(estado)) : 'null'}::int as estado_id
          )
          select sis.nome as sistema, coalesce(sum(p.valor_mensalidade),0) totalmensalidade, coalesce(sum(p.valor_implantacao), 0) as totalimplantacao, count(sis.id), sis.id
          from acompanhamentos a
          inner join parametros on true
          left join fechamentos f on f.cliente_id = a.cliente_id
          left join propostas p on p.id = (select id from propostas where propostas.cliente_id = a.cliente_id and propostas.ativa is true order by id desc limit 1)
          left join pacotes pac on pac.id = p.pacote_id
          left join sistemas sis on sis.id = pac.sistema_id
          left join clientes cliente on cliente.id = a.cliente_id
          left join cidades cidade on cidade.id = cliente.cidade_id
          left join implantacoes implantacao on implantacao.cliente_id = a.cliente_id
          where a.data_fim::date between parametros.dataInicio and parametros.dataFim
          and a.empresa_id in (#{ ApplicationHelper.get_empresas_by_codigo(empresa) })
          and (parametros.responsavel_id is null or a.user_id = parametros.responsavel_id)
          and (parametros.vendedor_id is null or f.user_id = parametros.vendedor_id)
          and (parametros.implantador_id is null or implantacao.user_id = parametros.implantador_id)
          and (parametros.estado_id is null or cidade.estado_id = parametros.estado_id)
          and a.status = 5 "
          sql += "
          
          group by sis.nome, sis.id
"
  end

  def self.get_acompanhamentos_andamento(data_inicio, data_fim, empresa, vendedor, responsavel, implantador, estado, somenteNovos, ocultar_efetivas, efetivo)
    sql = "with parametros as (
            select '#{data_inicio}'::date as dataInicio,
              '#{data_fim}'::date as dataFim,
              #{ empresa.present? ? empresa : 'null'}::int as empresa_id,
              #{ vendedor.present? ? vendedor : 'null'}::int as vendedor_id,
              #{ responsavel.present? ? responsavel : 'null'}::int as responsavel_id,
              #{ implantador.present? ? implantador : 'null'}::int as implantador_id,
              #{ estado.present? ? (ApplicationHelper.get_estado_by_codigo(estado)) : 'null'}::int as estado_id,
              #{ somenteNovos } as somenteNovos,
              #{ ocultar_efetivas } as ocultar_efetivas
          )
          select sis.nome as sistema, coalesce(sum(p.valor_mensalidade),0) totalmensalidade, coalesce(sum(p.valor_implantacao), 0) as totalimplantacao, count(sis.id), sis.id
          from acompanhamentos a
          inner join parametros on true
          inner join fechamentos f on f.cliente_id = a.cliente_id
          inner join propostas p on p.id = (select id from propostas where propostas.cliente_id = a.cliente_id and propostas.ativa is true order by id desc limit 1)
          inner join pacotes pac on pac.id = p.pacote_id
          inner join sistemas sis on sis.id = pac.sistema_id
          left join clientes cliente on cliente.id = a.cliente_id
          left join cidades cidade on cidade.id = cliente.cidade_id
          left join implantacoes implantacao on implantacao.cliente_id = a.cliente_id
          where (parametros.somenteNovos is false or a.data_inicio::date between parametros.dataInicio and parametros.dataFim)
          and a.empresa_id in (#{ ApplicationHelper.get_empresas_by_codigo(empresa) })
          and (parametros.responsavel_id is null or a.user_id = parametros.responsavel_id)
          and (parametros.vendedor_id is null or f.user_id = parametros.vendedor_id)
          and (parametros.implantador_id is null or implantacao.user_id = parametros.implantador_id)
          and (parametros.estado_id is null or cidade.estado_id = parametros.estado_id)
          and a.status in(1,2)
          and (parametros.ocultar_efetivas is false) "
            sql += "
          group by sis.nome, sis.id
"
  end

  def self.get_acompanhamentos_aguardando(data_inicio, data_fim, empresa, vendedor, responsavel, implantador, estado, somenteNovos, ocultar_efetivas)
    sql = "with parametros as (
            select '#{data_inicio}'::date as dataInicio,
              '#{data_fim}'::date as dataFim,
              #{ empresa.present? ? empresa : 'null'}::int as empresa_id,
              #{ vendedor.present? ? vendedor : 'null'}::int as vendedor_id,
              #{ responsavel.present? ? responsavel : 'null'}::int as responsavel_id,
              #{ implantador.present? ? implantador : 'null'}::int as implantador_id,
              #{ estado.present? ? (ApplicationHelper.get_estado_by_codigo(estado)) : 'null'}::int as estado_id,
              #{ somenteNovos } as somenteNovos,
              #{ ocultar_efetivas } as ocultar_efetivas
          )
          select sis.nome as sistema, coalesce(sum(p.valor_mensalidade),0) totalmensalidade, coalesce(sum(p.valor_implantacao), 0) as totalimplantacao, count(sis.id), sis.id
          from acompanhamentos a
          inner join parametros on true
          inner join fechamentos f on f.cliente_id = a.cliente_id
          inner join propostas p on p.id = (select id from propostas where propostas.cliente_id = a.cliente_id and propostas.ativa is true order by id desc limit 1)
          inner join pacotes pac on pac.id = p.pacote_id
          inner join sistemas sis on sis.id = pac.sistema_id
          left join clientes cliente on cliente.id = a.cliente_id
          left join cidades cidade on cidade.id = cliente.cidade_id
          left join implantacoes implantacao on implantacao.cliente_id = a.cliente_id
          where (parametros.somenteNovos is false or a.created_at::date between parametros.dataInicio and parametros.dataFim)
          and a.empresa_id in (#{ ApplicationHelper.get_empresas_by_codigo(empresa) })
          and (parametros.responsavel_id is null or a.user_id = parametros.responsavel_id)
          and (parametros.vendedor_id is null or f.user_id = parametros.vendedor_id)
          and (parametros.implantador_id is null or implantacao.user_id = parametros.implantador_id)
          and (parametros.estado_id is null or cidade.estado_id = parametros.estado_id)
          and a.status in(0)
          and (parametros.ocultar_efetivas is false)
          group by sis.nome, sis.id
"
  end

  def self.get_top_implantadores_acompanhamento(data_inicio, data_fim, empresa, estado, efetivo)
    sql = "
        with parametros as (
            select '#{data_inicio}'::date as dataInicio,
              '#{data_fim}'::date as dataFim,
              #{ estado.present? ? (ApplicationHelper.get_estado_by_codigo(estado)) : 'null'}::int as estado_id
          ),
          concluidas as (
                      select u.id, u.name, count(a.id)::numeric as qtd, sum(p.valor_mensalidade) as mensalidade, sum(p.valor_implantacao) as implantacao
                      from acompanhamentos a
                      inner join parametros on true
                      inner join fechamentos f on f.cliente_id = a.cliente_id
                      inner join propostas p on p.id = (select id from propostas where propostas.cliente_id = a.cliente_id and propostas.ativa is true order by id desc limit 1)
                      inner join implantacoes i on i.cliente_id = a.cliente_id
                      inner join users u on u.id = i.user_id
                      left join clientes cliente on cliente.id = a.cliente_id
                      left join cidades cidade on cidade.id = cliente.cidade_id
                      where a.data_fim::date between parametros.dataInicio and parametros.dataFim
                        and a.empresa_id in (#{ ApplicationHelper.get_empresas_by_codigo(empresa) })
                        and (parametros.estado_id is null or cidade.estado_id = parametros.estado_id)
                        and a.status = 5 "
                        sql += "
                      group by u.id, u.name
            )

          select distinct users.id, users.name as nome, coalesce(c.qtd, 0)as concluidas, coalesce(c.mensalidade, 0) as mensalidade_concluida,
            coalesce(c.implantacao, 0) as implantacao_concluida
          from users
          inner join parametros on true
          inner join empresas_users emp on emp.user_id = users.id
          left join concluidas c on c.id = users.id
          where users.permissao_id = 3
            and emp.empresa_id in (#{ ApplicationHelper.get_empresas_by_codigo(empresa) })
            and users.active is true
          order by coalesce(c.mensalidade,0) desc"
  end

  def self.get_top_estados_acompanhamento(data_inicio, data_fim, empresa, efetivo)
    sql = "
        with parametros as (
            select '#{data_inicio}'::date as dataInicio,
              '#{data_fim}'::date as dataFim
          ),
          concluidas as (
                      select e.sigla, count(a.id)::numeric as qtd, sum(coalesce(p.valor_mensalidade,0)) as valor, 
                      ROUND(sum(coalesce(p.valor_mensalidade, 0))/count(a.id), 2) AS media
                      from acompanhamentos a
                      inner join parametros on true
                      inner join fechamentos f on f.cliente_id = a.cliente_id
                      inner join propostas p on p.id = (select id from propostas where propostas.cliente_id = a.cliente_id and propostas.ativa is true order by id desc limit 1)
                      inner join implantacoes i on i.cliente_id = a.cliente_id
                      inner join users u on u.id = i.user_id
                      left join clientes cliente on cliente.id = a.cliente_id
                      left join cidades cidade on cidade.id = cliente.cidade_id
                      left join estados e on e.id = cidade.estado_id
                      where a.data_fim::date between parametros.dataInicio and parametros.dataFim
                        and a.empresa_id in (#{ ApplicationHelper.get_empresas_by_codigo(empresa) })
                        and a.status = 5 "
                        sql += "
                      group by e.sigla
            )

          select *
          from concluidas c
          order by coalesce(c.valor,0) desc"
  end

  def self.get_top_vendedores_acompanhamento(data_inicio, data_fim, empresa, estado, efetivo)
    sql = "
        with parametros as (
            select '#{data_inicio}'::date as dataInicio,
              '#{data_fim}'::date as dataFim,
              #{ estado.present? ? (ApplicationHelper.get_estado_by_codigo(estado)) : 'null'}::int as estado_id
          ),
          concluidas as (
                      select u.id, u.name, count(a.id)::numeric as qtd, sum(p.valor_mensalidade) as mensalidade, sum(p.valor_implantacao) as implantacao
                      from acompanhamentos a
                      inner join parametros on true
                      inner join fechamentos f on f.cliente_id = a.cliente_id
                      inner join propostas p on p.id = (select id from propostas where propostas.cliente_id = a.cliente_id and propostas.ativa is true order by id desc limit 1)
                      inner join users u on u.id = f.user_id
                      left join clientes cliente on cliente.id = a.cliente_id
                      left join cidades cidade on cidade.id = cliente.cidade_id
                      where a.data_fim::date between parametros.dataInicio and parametros.dataFim
                        and a.empresa_id in (#{ ApplicationHelper.get_empresas_by_codigo(empresa) })
                        and (parametros.estado_id is null or cidade.estado_id = parametros.estado_id)
                        and a.status = 5 "
    sql += "
                      group by u.id, u.name
            )

          select 	users.id, users.name as nome, coalesce(c.qtd, 0)as concluidas, coalesce(c.mensalidade, 0) as mensalidade_concluida,
            coalesce(c.implantacao, 0) as implantacao_concluida
          from users
          left join concluidas c on c.id = users.id
          where (c.qtd is not null)
          order by coalesce(c.mensalidade,0) desc"
  end

  def self.get_acompanhamentos_table(data_inicio, data_fim, empresa, vendedor, responsavel, status, implantador, novos, estado, efetivo)
    html = " with parametros as (
            select '#{data_inicio}'::date as dataInicio,
              '#{data_fim}'::date as dataFim,
              #{ vendedor.present? ? vendedor : 'null'}::int as vendedor_id,
              #{ responsavel.present? ? responsavel : 'null'}::int as responsavel_id,
              #{ implantador.present? ? implantador : 'null'}::int as implantador_id,
              #{ estado.present? ? (ApplicationHelper.get_estado_by_codigo(estado)) : 'null'}::int as estado_id,
              #{ novos } as somenteNovos
          )

          select  i.id as acompanhamentoid,
                  c.id as clienteId,
                  c.cnpj,
                  c.razao_social,
                  sis.id as sistemaId,
                  sis.nome as sistema,
                  p.valor_implantacao,
                  p.valor_mensalidade,
                  vend.name as vendedor,
            impl.name as implantador, i.motivo,
          #{ status == '(3,4)' ? ' i.data_fim ': ''}
          #{ status == '(0)' ? ' i.created_at ': ''}
          #{ status == '(1)' ? ' i.data_inicio ': ''}
          #{ status == '(2)' ? ' coalesce(ac.created_at, i.created_at) ': ''}
          #{ status == '(5)' ? ' i.data_fim ': ''} as data,
                  (cidade.nome || '-' || estado.sigla) as cidade,
                  retorno.data_agendamento_retorno
          from acompanhamentos i
          inner join parametros on true
          inner join clientes c on c.id = i.cliente_id
          inner join fechamentos f on f.cliente_id = i.cliente_id
          inner join users vend on vend.id = f.user_id
          inner join propostas p on p.id = (select id from propostas where propostas.cliente_id = i.cliente_id and propostas.ativa is true order by id desc limit 1)
          inner join pacotes pac on pac.id = p.pacote_id
          inner join sistemas sis on sis.id = pac.sistema_id
          left join cidades cidade on cidade.id = c.cidade_id
          left join estados estado on estado.id = cidade.estado_id
          left join implantacoes implantacao on implantacao.cliente_id = i.cliente_id
          left join users impl on impl.id = implantacao.user_id
          left join activities ac on ac.id = (select id from activities where recipient_id = i.id and (key = 'acompanhamento.pausada') order by id desc limit 1)
          left join agendamento_retornos retorno on retorno.id = (select id from agendamento_retornos where cliente_id = i.cliente_id and acompanhamento_id = i.id and data_efetuado_retorno is null order by data_efetuado_retorno desc limit 1)
          where i.status in #{ status }
          #{ status == '(3,4)' ? ' and i.data_fim::date between parametros.dataInicio and parametros.dataFim': ''}
          #{ status == '(0)' ? ' and (parametros.somenteNovos is false or i.created_at::date between parametros.dataInicio and parametros.dataFim)': ''}
          #{ status == '(1)' ? 'and (parametros.somenteNovos is false or i.data_inicio::date between parametros.dataInicio and parametros.dataFim)': ''}
          #{ status == '(2)' ? ' and (parametros.somenteNovos is false or ac.created_at::date between parametros.dataInicio and parametros.dataFim)': ''}
          #{ status == '(5)' ? ' and i.data_fim::date between parametros.dataInicio and parametros.dataFim': ''}
          and i.empresa_id in (#{ ApplicationHelper.get_empresas_by_codigo(empresa) })
          and (parametros.responsavel_id is null or i.user_id = parametros.responsavel_id)
          and (parametros.vendedor_id is null or f.user_id = parametros.vendedor_id)
          and (parametros.implantador_id is null or implantacao.user_id = parametros.implantador_id)
          and (parametros.estado_id is null or cidade.estado_id = parametros.estado_id) "
          html += "
          order by retorno.data_agendamento_retorno nulls first
      "
  end

  def self.get_lista_job(empresa_id, data_controle, agrupar_mes)
    if !agrupar_mes
      return "  with parametros as (
                select #{empresa_id}::int as empresa_id,
                      '#{data_controle}'::date as data_controle
              ),

            boas as (
            select coalesce(count(cli.id),0) as total, job.job
                from controle_jobs job
                left join parametros on true
                left join jobs on jobs.job = job.job and jobs.empresa_id = job.empresa_id
                left join controle_job_clientes controle_cli on controle_cli.controle_job_id = job.id
                left join clientes cli on cli.id = controle_cli.cliente_id
                inner join status status on status.id = cli.status_id
                where job.empresa_id = parametros.empresa_id
                  and job.data_controle = parametros.data_controle
                  and status.id not in ( 8,9, 19,21,5)
                 group by job.job
            )
            select job.empresa_id, job.job, job.quantidade, coalesce(job.restante, count(fila.id)) as restam, job.quantidade - coalesce(job.restante, count(fila.id)) as ligado,
            case when job.quantidade = 0 then 0 else ROUND(((( job.quantidade - coalesce(job.restante, count(fila.id))) * 100)::numeric / job.quantidade), 2) end as percentual, coalesce(boas.total,0) as boas,
            case when (job.quantidade - coalesce(job.restante, count(fila.id))) = 0 or coalesce(boas.total,0) = 0 then 0.00 else  ROUND(((boas.total * 100)::numeric/ (job.quantidade - coalesce(job.restante, count(fila.id)))), 2) end as percentual_boas
            from controle_jobs job
            left join parametros on true
            left join jobs on jobs.job = job.job and jobs.empresa_id = job.empresa_id
            left join fila_empresas fila on fila.empresa_id = job.empresa_id and fila.numero_fila = ANY(jobs.filas)
            left join boas on boas.job = job.job
            where job.empresa_id = parametros.empresa_id
            and job.data_controle = parametros.data_controle
            group by job.empresa_id, job.quantidade, job.job, job.restante, job.filas, boas.total
            order by job.job
      "
    else
      return "
            with parametros as (
                select #{empresa_id}::int as empresa_id,
                      '#{data_controle}'::date as data_controle
        ),
        totalMes as (
                select job.empresa_id, job.job, count(distinct cliente.cliente_id) as total
                from controle_jobs job
                inner join parametros on true
                inner join controle_job_clientes cliente on cliente.controle_job_id = job.id
                where job.empresa_id = parametros.empresa_id
                and job.data_controle::date between date_trunc('month', parametros.data_controle)::date and (date_trunc('month', parametros.data_controle) + INTERVAL'1 month' - INTERVAL'1 day')::date
                group by job.empresa_id , job.job
        ),
        totalMesRestante as (
          select job.empresa_id, job.job, count(distinct cliente.cliente_id) as total
          from controle_jobs job
          inner join parametros on true
          left join controle_job_cliente_restantes cliente on cliente.controle_job_id = job.id
          where job.empresa_id = parametros.empresa_id
          and job.data_controle::date between date_trunc('month', parametros.data_controle)::date and (date_trunc('month', parametros.data_controle) + INTERVAL'1 month' - INTERVAL'1 day')::date
          group by job.empresa_id , job.job
        ),
        boas as (
          with id_clientes as (
            select job.empresa_id, job.job, cliente.cliente_id
            from controle_jobs job
            inner join parametros on true
            inner join controle_job_clientes cliente on cliente.controle_job_id = job.id
            where job.empresa_id = parametros.empresa_id
            and job.data_controle::date between date_trunc('month', parametros.data_controle)::date and (date_trunc('month', parametros.data_controle) + INTERVAL'1 month' - INTERVAL'1 day')::date
            group by job.empresa_id , job.job, cliente.cliente_id
          )
          select count(cliente.id) as total, id_clientes.job
            from id_clientes
            left join parametros on true
            left join clientes cliente on cliente.id = id_clientes.cliente_id
            inner join status status on status.id = cliente.status_id
            where status.id not in ( 8,9, 19,21,5)
            group by id_clientes.job
        )
        select 	tot.empresa_id,
                tot.job,
                tot.total as quantidade,
                totRestante.total as restam,
                case when totRestante.total = 0 then 0 else tot.total  - totRestante.total end as ligado,
                case when totRestante.total = 0 then 0 else ROUND(((( tot.total - totRestante.total) * 100)::numeric / tot.total), 2) end as percentual,
                case when totRestante.total = 0 then 0 else coalesce(boas.total,0) end  as boas,
		            case when totRestante.total = 0 then 0 else case when (tot.total - totRestante.total) = 0 or coalesce(boas.total,0) = 0 then 0.00 else ROUND(((boas.total * 100)::numeric/ (tot.total - totRestante.total)),2) end end as percentual_boas
        from totalMes tot
        inner join totalMesRestante totRestante on totRestante.job = tot.job and totRestante.empresa_id = tot.empresa_id
        left join boas on boas.job = tot.job
         order by tot.job"
    end
  end

  def self.get_controle_job(empresa_id, data_inicio, data_fim)
    html = " with parametros as (
            select '#{data_inicio}'::date as dataInicio,
              '#{data_fim}'::date as dataFim,
              '#{empresa_id}'::int as empresa_id
            ),
             dias as (
		          select a::date as dia, parametros.empresa_id
                from parametros, generate_series(parametros.dataInicio,parametros.dataFim,INTERVAL'1 day') a
            )

          select TO_CHAR(dias.dia::date, 'DD/MM/YYYY') as dia , parametros.empresa_id, coalesce(sum(quantidade),0) as quantidade
          from dias
          left join controle_jobs on controle_jobs.data_controle = dias.dia
          left join parametros on true
          where coalesce(controle_jobs.empresa_id, dias.empresa_id) = parametros.empresa_id
          group by parametros.empresa_id, dias.dia
          order by dias.dia desc
    "
  end

  def self.get_status_empresa_geral(empresa_id, data_controle, job_id, agrupar_mes)
      if !agrupar_mes
        return "with parametros as (
                select #{empresa_id}::int as empresa_id,
                      '#{data_controle}'::date as data_controle,
                      #{ job_id.present? ? job_id : 'null' }::int as job_id
              )
              select case cli.status_empresa when 0 then 'EMPRESA IMPORTADA'
                     when 1 then 'AGUARDANDO LIGAÇÃO'
                     when 2 then 'EM NEGOCIAÇÃO'
                     when 3 then 'DESCARTADAS'
                     when 4 then 'SEM CONTATO INICIAL'
                     when 5 then 'FECHADO'
                     when 6 then 'IMPLANTAÇÃO EM ANDAMENTO'
                     when 7 then 'DESISTENTE'
                     when 8 then 'IMPLANTAÇÃO CONCLUÍDA' end as label, count(cli.id) as value, cli.status_empresa as id
            from controle_jobs job
            left join parametros on true
            left join jobs on jobs.job = job.job and jobs.empresa_id = job.empresa_id
            left join controle_job_clientes controle_cli on controle_cli.controle_job_id = job.id
            left join clientes cli on cli.id = controle_cli.cliente_id
            where job.empresa_id = parametros.empresa_id
              and job.data_controle = parametros.data_controle
              and (parametros.job_id is null or job.job = parametros.job_id)
            group by cli.status_empresa
          "
      else
        "with parametros as (
                select #{empresa_id}::int as empresa_id,
                      '#{data_controle}'::date as data_controle,
                      #{ job_id.present? ? job_id : 'null' }::int as job_id
              ),
        clientesDistinct as (
          select job.empresa_id, job.job, cliente.cliente_id
          from controle_jobs job
          inner join parametros on true
          inner join controle_job_clientes cliente on cliente.controle_job_id = job.id
          where job.empresa_id = parametros.empresa_id
            and job.data_controle::date between date_trunc('month', parametros.data_controle)::date and (date_trunc('month', parametros.data_controle) + INTERVAL'1 month' - INTERVAL'1 day')::date
            and (parametros.job_id is null or job.job = parametros.job_id)
          group by job.empresa_id , job.job, cliente.cliente_id
        )

        select case cliente.status_empresa when 0 then 'EMPRESA IMPORTADA'
             when 1 then 'AGUARDANDO LIGAÇÃO'
             when 2 then 'EM NEGOCIAÇÃO'
             when 3 then 'DESCARTADAS'
             when 4 then 'SEM CONTATO INICIAL'
             when 5 then 'FECHADO'
             when 6 then 'IMPLANTAÇÃO EM ANDAMENTO'
             when 7 then 'DESISTENTE'
             when 8 then 'IMPLANTAÇÃO CONCLUÍDA' end as label, count(cliente.id) as value, cliente.status_empresa as id
        from clientesDistinct cli
        left join clientes cliente on cliente.id = cli.cliente_id
        group by cliente.status_empresa
      "
      end

  end

  def self.get_status_empresa(empresa_id, data_controle, job_id, status_geral, agrupar_mes)
    if !agrupar_mes
      return "
             	with parametros as (
                select #{empresa_id}::int as empresa_id,
                      '#{data_controle}'::date as data_controle,
                      #{ job_id.present? ? job_id : 'null' }::int as job_id,
                      #{ status_geral.present? ? status_geral : 'null' }::int as status_geral
              )
              select coalesce(status.descricao, 'AGUARDANDO') as label, count(cli.id) as value, status.id as id
            from controle_jobs job
            left join parametros on true
            left join jobs on jobs.job = job.job and jobs.empresa_id = job.empresa_id
            left join controle_job_clientes controle_cli on controle_cli.controle_job_id = job.id
            left join clientes cli on cli.id = controle_cli.cliente_id
            inner join status status on status.id = cli.status_id
            where job.empresa_id = parametros.empresa_id
              and job.data_controle = parametros.data_controle
              and (parametros.job_id is null or job.job = parametros.job_id)
              and (parametros.status_geral is null or cli.status_empresa = parametros.status_geral)
            group by status.descricao, status.id
      "
    else
      return "with parametros as (
                select #{empresa_id}::int as empresa_id,
                      '#{data_controle}'::date as data_controle,
                      #{ job_id.present? ? job_id : 'null' }::int as job_id,
                      #{ status_geral.present? ? status_geral : 'null' }::int as status_geral
              ),
              clientesDistinct as (
                select job.empresa_id, job.job, cliente.cliente_id
                from controle_jobs job
                inner join parametros on true
                inner join controle_job_clientes cliente on cliente.controle_job_id = job.id
                left join clientes cli on cli.id = cliente.cliente_id
                where job.empresa_id = parametros.empresa_id
                  and job.data_controle::date between date_trunc('month', parametros.data_controle)::date and (date_trunc('month', parametros.data_controle) + INTERVAL'1 month' - INTERVAL'1 day')::date
                  and (parametros.job_id is null or job.job = parametros.job_id)
                  and (parametros.status_geral is null or cli.status_empresa = parametros.status_geral)
                group by job.empresa_id , job.job, cliente.cliente_id
              )

              select coalesce(status.descricao, 'AGUARDANDO') as label, count(cliente.id) as value, status.id as id
              from clientesDistinct cli
              left join clientes cliente on cliente.id = cli.cliente_id
              inner join status status on status.id = cliente.status_id
              group by status.descricao, status.id"
    end

  end

  def self.get_controle_filas_table(empresa_id, data_controle, job_id, status_geral, status, agrupar_mes, boas)
    html = "
    	    with parametros as (
                select #{empresa_id}::int as empresa_id,
                      '#{data_controle}'::date as data_controle,
                      #{ job_id.present? ? job_id : 'null' }::int as job_id,
                      #{ status_geral.present? ? status_geral : 'null' }::int as status_geral,
                      #{ status.present? ? status : 'null' }::int as status,
                      #{ boas.present? ? boas : 'null'}::boolean as boas
              ),
            clientes_carregados as (
              select cli.cnae_id, cli.cnpj, cli.razao_social, cli.data_licenca, cnae.descricao as cnae, cnae.codigo, fila_empresa.id as fila_id
              from controle_jobs job
              left join parametros on true
              left join jobs on jobs.job = job.job and jobs.empresa_id = job.empresa_id
              left join fila_empresas fila_empresa on fila_empresa.numero_fila = job.job
              left join clientes cli on cli.id = fila_empresa.cliente_id
              left join status status on status.id = cli.status_id
              left join ligacoes lig on lig.id = (select max(id) from ligacoes where ligacoes.empresa_id = job.empresa_id  and ligacoes.cliente_id = cli.id)
              left join users operador on operador.id = lig.user_id
              left join cnaes cnae on cnae.id = cli.cnae_id
              where job.empresa_id = parametros.empresa_id
                and fila_empresa.numero_fila = parametros.job_id
                and fila_empresa.empresa_id = parametros.empresa_id
                and (parametros.job_id is null or job.job = parametros.job_id)
                and (parametros.status_geral is null or cli.status_empresa = parametros.status_geral)
                and (parametros.status is null or cli.status_id = parametros.status)
                and (parametros.boas is null or parametros.boas is true or (parametros.boas is false and cli.status_id in (8,9, 19,21,5)))
                and (parametros.boas is null or parametros.boas is false or (parametros.boas is true and cli.status_id not in (8,9, 19,21,5)))
                #{ !agrupar_mes ? " and job.data_controle = parametros.data_controle " :
                            " and job.data_controle::date between date_trunc('month', parametros.data_controle)::date and (date_trunc('month', parametros.data_controle) + INTERVAL'1 month' - INTERVAL'1 day')::date " }                      
            )
            select
              clientes_carregados.razao_social,
              clientes_carregados.codigo,
              clientes_carregados.cnae,
              clientes_carregados.data_licenca
            from clientes_carregados
            order by clientes_carregados.fila_id asc;
      "
  end

  def self.get_empresas_boas_ruins(empresa_id, data_controle, job_id, agrupar_mes)
    return "
      with parametros as (
          select #{empresa_id}::int as empresa_id,
              '#{data_controle}'::date as data_controle,
              #{ job_id.present? ? job_id : 'null' }::int as job_id
      ),
      sql as (
        select cli.id, status.id as status_id
            from controle_jobs job
            left join parametros on true
            left join jobs on jobs.job = job.job and jobs.empresa_id = job.empresa_id
            left join controle_job_clientes controle_cli on controle_cli.controle_job_id = job.id
            left join clientes cli on cli.id = controle_cli.cliente_id
            inner join status status on status.id = cli.status_id
            where job.empresa_id = parametros.empresa_id
          #{ !agrupar_mes ? "and job.data_controle = parametros.data_controle" :
              "and job.data_controle::date between date_trunc('month', parametros.data_controle)::date and (date_trunc('month', parametros.data_controle) + INTERVAL'1 month' - INTERVAL'1 day')::date"}
              and (parametros.job_id is null or parametros.job_id = job.job)
              group by cli.id, status.id
      ),
      total_boas as(
        select count(sql.id), 'BOAS'::varchar as desc
        from sql
              where sql.status_id not in ( 8,9, 19,21,5)
      ),
      total_ruins as(
        select count(sql.id), 'RUINS'::varchar as desc
        from sql
              where sql.status_id in ( 8,9, 19,21,5)
      )
      select *
      from total_boas

      union all

      select *
      from total_ruins
    "
  end

  def self.get_empresas_boas_ruins_status_geral(empresa_id, data_controle, job_id, boas, agrupar_mes)
    return "
      with parametros as (
          select #{empresa_id}::int as empresa_id,
              '#{data_controle}'::date as data_controle,
              #{ job_id.present? ? job_id : 'null' }::int as job_id,
                #{ boas.present? ? boas : 'null' }::boolean as boas
      ),
      sqlClientes as (
	        select job.empresa_id, controle_cli.cliente_id
          from controle_jobs job
          left join parametros on true
          left join jobs on jobs.job = job.job and jobs.empresa_id = job.empresa_id
          left join controle_job_clientes controle_cli on controle_cli.controle_job_id = job.id
          left join clientes cli on cli.id = controle_cli.cliente_id
          where job.empresa_id = parametros.empresa_id
	        #{ !agrupar_mes ? "and job.data_controle = parametros.data_controle" :
            "and job.data_controle::date between date_trunc('month', parametros.data_controle)::date and (date_trunc('month', parametros.data_controle) + INTERVAL'1 month' - INTERVAL'1 day')::date"}
           and (parametros.job_id is null or parametros.job_id = job.job)
          group by job.empresa_id, controle_cli.cliente_id
      )
      select  case cli.status_empresa when 0 then 'EMPRESA IMPORTADA'
                     when 1 then 'AGUARDANDO LIGAÇÃO'
                     when 2 then 'EM NEGOCIAÇÃO'
                     when 3 then 'DESCARTADAS'
                     when 4 then 'SEM CONTATO INICIAL'
                     when 5 then 'FECHADO'
                     when 6 then 'IMPLANTAÇÃO EM ANDAMENTO'
                     when 7 then 'DESISTENTE'
                     when 8 then 'IMPLANTAÇÃO CONCLUÍDA' end as label, count(cli.id) as value, cli.status_empresa as id
          from sqlClientes sql
          left join parametros on true
          left join clientes cli on cli.id = sql.cliente_id
          where cli.status_id not in ( 8,9, 19,21,5)
            and (parametros.boas is null or parametros.boas is true)
          group by cli.status_empresa

       UNION ALL

       select  case cli.status_empresa when 0 then 'EMPRESA IMPORTADA'
                               when 1 then 'AGUARDANDO LIGAÇÃO'
                               when 2 then 'EM NEGOCIAÇÃO'
                               when 3 then 'DESCARTADAS'
                               when 4 then 'SEM CONTATO INICIAL'
                               when 5 then 'FECHADO'
                               when 6 then 'IMPLANTAÇÃO EM ANDAMENTO'
                               when 7 then 'DESISTENTE'
                               when 8 then 'IMPLANTAÇÃO CONCLUÍDA' end as label, count(cli.id) as value, cli.status_empresa as id
          from sqlClientes sql
          left join parametros on true
          left join clientes cli on cli.id = sql.cliente_id
          where cli.status_id in ( 8,9, 19,21,5)
            and (parametros.boas is null or parametros.boas is false)
          group by cli.status_empresa"
  end

  def self.get_empresas_boas_ruins_status_empresa(empresa_id, data_controle, job_id, boas, status, agrupar_mes)
    return "
      with parametros as (
          select #{empresa_id}::int as empresa_id,
              '#{data_controle}'::date as data_controle,
              #{ job_id.present? ? job_id : 'null' }::int as job_id,
              #{ boas.present? ? boas : 'null' }::boolean as boas,
              #{ status.present? ? status : 'null' }::int as status_geral

      ),
      sqlClientes as (
	        select job.empresa_id, controle_cli.cliente_id
          from controle_jobs job
          left join parametros on true
          left join jobs on jobs.job = job.job and jobs.empresa_id = job.empresa_id
          left join controle_job_clientes controle_cli on controle_cli.controle_job_id = job.id
          left join clientes cli on cli.id = controle_cli.cliente_id
          where job.empresa_id = parametros.empresa_id
	        #{ !agrupar_mes ? "and job.data_controle = parametros.data_controle" :
                                                                                                                                                                                                                                                  "and job.data_controle::date between date_trunc('month', parametros.data_controle)::date and (date_trunc('month', parametros.data_controle) + INTERVAL'1 month' - INTERVAL'1 day')::date"}
           and (parametros.job_id is null or parametros.job_id = job.job)
          group by job.empresa_id, controle_cli.cliente_id
      )
      select  coalesce(status.descricao, 'AGUARDANDO') as label, count(cli.id) as value, status.id as id
          from sqlClientes sql
          left join parametros on true
          left join clientes cli on cli.id = sql.cliente_id
          inner join status on status.id = cli.status_id
          where cli.status_id not in ( 8,9, 19,21,5)
            and (parametros.boas is null or parametros.boas is true)
            and (parametros.status_geral is null or cli.status_empresa = parametros.status_geral)
          group by status.descricao, status.id

       UNION ALL

          select  coalesce(status.descricao, 'AGUARDANDO') as label, count(cli.id) as value, status.id as id
          from sqlClientes sql
          left join parametros on true
          left join clientes cli on cli.id = sql.cliente_id
          inner join status status on status.id = cli.status_id
          where cli.status_id in ( 8,9, 19,21,5)
            and (parametros.boas is null or parametros.boas is false)
            and (parametros.status_geral is null or cli.status_empresa = parametros.status_geral)
          group by status.descricao, status.id"
  end

  def self.get_total_empresas_ligadas_job0(data_controle)
    return "
      with parametros as (
        select '#{data_controle}'::date as data_controle
      ),
      boas as (
        select coalesce(count(cli.id),0) as total, job.job
        from controle_jobs job
        left join parametros on true
        left join jobs on jobs.job = job.job and jobs.empresa_id = job.empresa_id
        left join controle_job_clientes controle_cli on controle_cli.controle_job_id = job.id
        left join clientes cli on cli.id = controle_cli.cliente_id
        inner join status status on status.id = cli.status_id
        where job.data_controle = parametros.data_controle
          and status.id not in ( 8,9, 19,21,5)
          group by job.job
      ),
      total as (
        select job.empresa_id, job.job, job.quantidade, coalesce(job.restante, count(fila.id)) as restam, job.quantidade - coalesce(job.restante, count(fila.id)) as ligado,
        case when job.quantidade = 0 then 0 else ROUND(((( job.quantidade - coalesce(job.restante, count(fila.id))) * 100)::numeric / job.quantidade), 2) end as percentual, coalesce(boas.total,0) as boas,
        case when (job.quantidade - coalesce(job.restante, count(fila.id))) = 0 or coalesce(boas.total,0) = 0 then 0.00 else  ROUND(((boas.total * 100)::numeric/ (job.quantidade - coalesce(job.restante, count(fila.id)))), 2) end as percentual_boas
        from controle_jobs job
        left join parametros on true
        left join jobs on jobs.job = job.job and jobs.empresa_id = job.empresa_id
        left join fila_empresas fila on fila.empresa_id = job.empresa_id and fila.numero_fila = ANY(jobs.filas)
        left join boas on boas.job = job.job
        where job.data_controle = parametros.data_controle and job.job = 0
        group by job.empresa_id, job.quantidade, job.job, job.restante, job.filas, boas.total
        order by job.job
      )
      select sum(quantidade) as total, sum(restam) as restantes, sum(ligado) as ligados
      from total
    "
  end

  def self.get_total_numeros_ativos
    return "
      select u.name as name, count(wpp.id) as total 
      from whatsapp_numeros wpp
      left join users u on u.id = wpp.user_id
      left join loja_itens li on li.id = wpp.loja_item_id
      where wpp.status = 'CONECTADO'
        and (
          (li.status = 'COMPRADO')
          OR (li.id is null and li.status is null)
        )
      group by u.name
      order by count(wpp.id) desc
    "
  end

  def self.get_qtd_clientes_por_tag_desistencia(datainicial, datafinal)
    return "
      WITH parametros AS (
        SELECT '#{datainicial}'::DATE AS datainicial,
        '#{datafinal}'::DATE AS datafinal
      )
      SELECT tags.descricao,
        COUNT(desistencia.id) AS qtd,
		    tags.id
      FROM solicitacao_desistencias desistencia
      INNER JOIN parametros ON true
      INNER JOIN tags_solicitacao_desistencias tags ON tags.id::text = ANY(
		    SELECT jsonb_array_elements_text(desistencia.tags::jsonb)
	    )
      WHERE desistencia.status = 'DESISTENTE'
      AND desistencia.data_desistencia BETWEEN parametros.datainicial AND parametros.datafinal
      AND user_id IS NULL
      GROUP BY tags.descricao, tags.id
      ORDER BY qtd DESC
    "
  end
end
