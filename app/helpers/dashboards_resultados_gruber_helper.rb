module DashboardsResultadosGruberHelper

  def self.cliente_12_meses(empresa)
    return "

      with meses as (
        select (a + INTERVAL'1 month' - INTERVAL'1 day')::date as final
        from generate_series((date_trunc('month', current_date - interval '13 month') + interval '1 month')::date, (date_trunc('month', current_date + interval '1 month') - interval '1 day')::date,INTERVAL'1 month') a
      ),
      totalHonorarios as (
        select count(honorario.id), sum(honorario.valor) as valor,  ROUND(sum(honorario.valor)/count(honorario.id),2) as media,
        TO_CHAR(meses.final, 'MM/YYYY') as final
        from honorariomensal honorario
        inner join meses on honorario.datavencimento::date <= meses.final
        and ((honorario.datainativacao is null and honorario.ativo is true) or (honorario.datainativacao > meses.final and honorario.ativo is false))
        inner join financeiro.clientefornecedorfinanceiro cliente on cliente.id = honorario.clifor_id
        inner join municipio on municipio.id = cliente.municipio_id
        where honorario.empresa_id in (#{empresa})
          and honorario.tipo_id = 2
		      and honorario.tipohonorario_id = 1 -- Somente tipo normal
        group by meses.final
        order by meses.final
      )
      select 	totalHonorarios.final,
        totalHonorarios.count as totalAtivos,
        totalHonorarios.valor as valorAtivos,
        ROUND(totalHonorarios.valor/totalHonorarios.count, 2) as mediaAtivos
      from totalHonorarios

    "
  end

  def self.table_clientes_gruber(empresa, competencia)
    return "
         WITH parametros AS
          ( SELECT '#{competencia}'::date AS competencia )
        SELECT honorario.id AS honorarioid,
               honorario.datavencimento,
               honorario.descricao,
               honorario.valor,
               honorario.cliforparceiro_id,
               cliente.id AS clienteid,
               cliente.razaosocial,
               cliente.cpfcnpj,
               CURRENT_DATE - honorario.datavencimento::date AS dias_cliente,
               municipio.nome || '-' || estado.sigla AS cidade
        FROM honorariomensal honorario
        INNER JOIN parametros ON TRUE
        INNER JOIN financeiro.clientefornecedorfinanceiro cliente ON cliente.id = honorario.clifor_id
        LEFT JOIN municipio ON municipio.id = cliente.municipio_id
        LEFT JOIN estado ON estado.id = municipio.estado_id
        WHERE honorario.empresa_id  in (#{empresa})
          AND honorario.tipo_id = 2
		      and honorario.tipohonorario_id = 1 -- Somente tipo normal
          AND honorario.datavencimento::date <= parametros.competencia
          AND ((honorario.datainativacao IS NULL and honorario.ativo is true)
               OR (honorario.datainativacao > parametros.competencia
                   AND honorario.ativo IS FALSE))
          ORDER BY honorario.datavencimento desc
            "
  end

  def self.get_efetivacoes_desativacoes_gruber(empresa)
    return "
          with parametros as (
            select 	2::int as tipo_id
          ),
           meses as (
            select a::date as inicial, (a + INTERVAL'1 month' - INTERVAL'1 day')::date as final
            from generate_series((date_trunc('month', current_date - interval '13 month') + interval '1 month')::date, (date_trunc('month', current_date + interval '1 month') - interval '1 day')::date,INTERVAL'1 month') a
	        ),
          sqlReativados as (
            select meses.final,
            cliente.id as cliente_id,
            cliente.razaosocial as razaosocial,
            cliente.cpfcnpj,
            municipio.id as municipio_id,
            municipio.nome as municipio,
            estado.nome as estado,
            estado.sigla,
            honorario.id as honorario_id,
            honorario.datavencimento as datainicial,
            honorario.datainativacao,
            honorario.valor,
            honorario.tipo_id,
            honorario.ativo,
            tipo.nome,
            current_date - honorario.datavencimento as dias,
            emp.razaosocial as empresaRazaoSocial
            from meses
            inner join  honorariomensal honorario on honorario.datavencimento between meses.inicial and meses.final and honorario.tipohonorario_id = 1
            inner join parametros on true
            inner join financeiro.clientefornecedorfinanceiro cliente on cliente.id = honorario.clifor_id
            inner join municipio on municipio.id = cliente.municipio_id
            inner join estado on municipio.estado_id = estado.id
            inner join tipocobranca tipo on tipo.id = honorario.tipo_id
            inner join empresa emp on emp.id = honorario.empresa_id
            left join honorariomensal hono on hono.clifor_id = honorario.clifor_id and hono.empresa_id = honorario.empresa_id and hono.tipo_id = honorario.tipo_id and hono.id <> honorario.id and hono.ativo is false
            where honorario.empresa_id in (#{empresa})
              and (parametros.tipo_id is null or honorario.tipo_id = parametros.tipo_id)
              and hono.id is not null
              and (honorario.datainativacao is null or honorario.datainativacao > honorario.datavencimento)
          ),
          sqlInativos as(
          select meses.final,
            cliente.id as cliente_id,
            cliente.razaosocial as razaosocial,
            cliente.cpfcnpj,
            municipio.id as municipio_id,
            municipio.nome as municipio,
            estado.nome as estado,
            estado.sigla,
            honorario.id as honorario_id,
            honorario.datavencimento as datainicial,
            honorario.datainativacao,
            honorario.valor,
            honorario.tipo_id,
            honorario.ativo,
            tipo.nome,
            honorario.datainativacao - honorario.datavencimento as dias,
            emp.razaosocial as empresaRazaoSocial
            from meses
            inner join parametros on true
            inner join honorariomensal honorario on honorario.datainativacao between meses.inicial and meses.final and honorario.tipohonorario_id = 1
            inner join financeiro.clientefornecedorfinanceiro cliente on cliente.id = honorario.clifor_id
            inner join municipio on municipio.id = cliente.municipio_id
            inner join estado on municipio.estado_id = estado.id
            inner join tipocobranca tipo on tipo.id = honorario.tipo_id
            inner join empresa emp on emp.id = honorario.empresa_id
            left join honorariomensal hono on hono.clifor_id = honorario.clifor_id and hono.empresa_id = honorario.empresa_id and hono.tipo_id = honorario.tipo_id and hono.id <> honorario.id
            where  honorario.empresa_id in (#{empresa})
              and (parametros.tipo_id is null or honorario.tipo_id = parametros.tipo_id)
              and hono.id is null
              and honorario.ativo is false
              and (honorario.datainativacao > honorario.datavencimento)
          ),
          sqlAtivos as (
            select meses.final,
            cliente.id as cliente_id,
            cliente.razaosocial as razaosocial,
            cliente.cpfcnpj,
            municipio.id as municipio_id,
            municipio.nome as municipio,
            estado.nome as estado,
            estado.sigla,
            honorario.id as honorario_id,
            honorario.datavencimento as datainicial,
            honorario.datainativacao,
            honorario.valor,
            honorario.tipo_id,
            honorario.ativo,
            tipo.nome,
            current_date - honorario.datavencimento as dias,
            emp.razaosocial as empresaRazaoSocial
            from meses
            inner join honorariomensal honorario on honorario.datavencimento between meses.inicial and meses.final and honorario.tipohonorario_id = 1
            inner join parametros on true
            inner join financeiro.clientefornecedorfinanceiro cliente on cliente.id = honorario.clifor_id
            inner join municipio on municipio.id = cliente.municipio_id
            inner join estado on municipio.estado_id = estado.id
            inner join tipocobranca tipo on tipo.id = honorario.tipo_id
            inner join empresa emp on emp.id = honorario.empresa_id
            left join honorariomensal hono on hono.clifor_id = honorario.clifor_id and hono.empresa_id = honorario.empresa_id and hono.tipo_id = honorario.tipo_id and hono.id <> honorario.id
            where honorario.empresa_id in (#{empresa})
              and (parametros.tipo_id is null or honorario.tipo_id = parametros.tipo_id)
              and hono.id is null
              and (honorario.datainativacao is null or honorario.datainativacao > honorario.datavencimento)
          ),
           totalReativados as (
            select sqlReativados.final, sum(sqlReativados.valor) as total, count(sqlReativados) as quantidade, ROUND(sum(sqlReativados.valor)/count(sqlReativados),2) as media, 'REATIVADOS'::varchar as desc
            from sqlReativados
            group by sqlReativados.final
          ),
          totalInativos as (
            select sqlInativos.final,sum(sqlInativos.valor) as total, count(sqlInativos) as quantidade, ROUND(sum(sqlInativos.valor)/count(sqlInativos),2) as media, 'DESATIVADOS'::varchar as desc
            from sqlInativos
            group by sqlInativos.final
          ),
          totalAtivos as (
            select sqlAtivos.final as data, (sum(sqlAtivos.valor) + coalesce(totalReativados.total,0)) as total, (count(sqlAtivos) + coalesce(totalReativados.quantidade,0)) as quantidade, ROUND((sum(sqlAtivos.valor) + coalesce(totalReativados.total,0))/(count(sqlAtivos) + coalesce(totalReativados.quantidade,0)),2) as media,  'ATIVADOS'::varchar as descricao
            from sqlAtivos
            left join totalReativados on sqlAtivos.final = totalReativados.final
            group by sqlAtivos.final, totalReativados.total, totalReativados.quantidade
          ),

            sqlFinal as (
            select 	totalAtivos.data,
            totalAtivos.total as valorefetivacoes,
            totalAtivos.quantidade as quantidadeefetivacoes,
            ROUND(totalAtivos.total/totalAtivos.quantidade,2) as mediaefetivacoes,
            coalesce(totalInativos.total,0) as valorinativos,
            coalesce(totalInativos.quantidade,0) as quantidadeinativos,
            coalesce(ROUND(totalInativos.total/totalInativos.quantidade,2),0) as mediainativos,
            coalesce(totalAtivos.quantidade,0) - coalesce(totalInativos.quantidade,0) as saldo_quantidade,
            coalesce(totalAtivos.total,0) - coalesce(totalInativos.total,0) as saldo_total,
            case when coalesce(totalAtivos.quantidade,0) - coalesce(totalInativos.quantidade,0)  = 0 then 0 else ROUND((coalesce(totalAtivos.total,0) - coalesce(totalInativos.total,0))/ (coalesce(totalAtivos.quantidade,0) - coalesce(totalInativos.quantidade,0)),2) end as saldo_media
            from totalAtivos
            left join totalInativos on totalInativos.final = totalAtivos.data
          )
          select  TO_CHAR(sqlFinal.data, 'MM/YYYY') as data,
                  sqlFinal.valorefetivacoes,
                  sqlFinal.quantidadeefetivacoes,
                  sqlFinal.mediaefetivacoes,
                  sqlFinal.valorinativos,
                  sqlFinal.quantidadeinativos,
                  sqlFinal.mediainativos,
                  sqlFinal.saldo_quantidade,
                  sqlFinal.saldo_total,
                  case when sqlFinal.saldo_total < 0 then sqlFinal.saldo_media * -1 else sqlFinal.saldo_media end as saldo_media
          from sqlFinal
          order by sqlFinal.data
    "
  end

  def self.table_efetivacoes_financeiro_gruber(empresa, data_inicio, data_fim)
    return "
          with parametros as (
            select 	2::int as tipo_id
          ),
          sql as (
            select  cliente.id as cliente_id,
            cliente.razaosocial as razaosocial,
            cliente.cpfcnpj,
            municipio.id as municipio_id,
            municipio.nome as municipio,
            estado.nome as estado,
            estado.sigla,
            honorario.id as honorario_id,
            honorario.datavencimento as datainicial,
            honorario.datainativacao,
            honorario.valor,
            honorario.tipo_id,
            honorario.ativo,
            tipo.nome,
            current_date - honorario.datavencimento as dias,
            emp.razaosocial as empresaRazaoSocial
    from honorariomensal honorario
    inner join parametros on true
    inner join financeiro.clientefornecedorfinanceiro cliente on cliente.id = honorario.clifor_id
    inner join municipio on municipio.id = cliente.municipio_id
    inner join estado on municipio.estado_id = estado.id
    inner join tipocobranca tipo on tipo.id = honorario.tipo_id
    inner join empresa emp on emp.id = honorario.empresa_id
    left join honorariomensal hono on hono.clifor_id = honorario.clifor_id and hono.empresa_id = honorario.empresa_id and hono.tipo_id = honorario.tipo_id and hono.id <> honorario.id and hono.ativo is false
    where honorario.empresa_id in (#{empresa})
      and (parametros.tipo_id is null or honorario.tipo_id = parametros.tipo_id)
      and hono.id is not null
      and honorario.tipohonorario_id = 1
      and honorario.datavencimento between '#{data_inicio}'::date and '#{data_fim}'::date
      and (honorario.datainativacao is null or honorario.datainativacao > honorario.datavencimento)

      UNION ALL

    select  cliente.id as cliente_id,
            cliente.razaosocial as razaosocial,
            cliente.cpfcnpj,
            municipio.id as municipio_id,
            municipio.nome as municipio,
            estado.nome as estado,
            estado.sigla,
            honorario.id as honorario_id,
            honorario.datavencimento as datainicial,
            honorario.datainativacao,
            honorario.valor,
            honorario.tipo_id,
            honorario.ativo,
            tipo.nome,
            current_date - honorario.datavencimento as dias,
            emp.razaosocial as empresaRazaoSocial
    from honorariomensal honorario
    inner join parametros on true
    inner join financeiro.clientefornecedorfinanceiro cliente on cliente.id = honorario.clifor_id
    inner join municipio on municipio.id = cliente.municipio_id
    inner join estado on municipio.estado_id = estado.id
    inner join tipocobranca tipo on tipo.id = honorario.tipo_id
    inner join empresa emp on emp.id = honorario.empresa_id
    left join honorariomensal hono on hono.clifor_id = honorario.clifor_id and hono.empresa_id = honorario.empresa_id and hono.tipo_id = honorario.tipo_id and hono.id <> honorario.id
    where honorario.empresa_id in (#{empresa})
      and (parametros.tipo_id is null or honorario.tipo_id = parametros.tipo_id)
      and hono.id is null
      and honorario.tipohonorario_id = 1
      and honorario.datavencimento between '#{data_inicio}'::date and '#{data_fim}'::date
      and (honorario.datainativacao is null or honorario.datainativacao > honorario.datavencimento)
  )
  select *
  from sql
  order by sql.datainicial desc
  "
  end

  def self.table_desistencia_financeiro_gruber(empresa, data_inicio, data_fim)
    return "
      with parametros as (
            select 	2::int as tipo_id
      )
    select  cliente.id as cliente_id,
            cliente.razaosocial as razaosocial,
            cliente.cpfcnpj,
            municipio.id as municipio_id,
            municipio.nome as municipio,
            estado.nome as estado,
            estado.sigla,
            honorario.id as honorario_id,
            honorario.datavencimento as datainicial,
            honorario.datainativacao,
            honorario.valor,
            honorario.tipo_id,
            honorario.ativo,
            tipo.nome,
            current_date - honorario.datavencimento as dias,
            honorario.datainativacao::date - honorario.datavencimento::date as dias_cliente,
            emp.razaosocial as empresaRazaoSocial,
            coalesce(honorario.motivoinativacao, '') as motivo
    from honorariomensal honorario
    inner join parametros on true
    inner join financeiro.clientefornecedorfinanceiro cliente on cliente.id = honorario.clifor_id
    inner join municipio on municipio.id = cliente.municipio_id
    inner join estado on municipio.estado_id = estado.id
    inner join tipocobranca tipo on tipo.id = honorario.tipo_id
    inner join empresa emp on emp.id = honorario.empresa_id
    left join honorariomensal hono on hono.clifor_id = honorario.clifor_id and hono.empresa_id = honorario.empresa_id and hono.tipo_id = honorario.tipo_id and hono.id <> honorario.id
    where honorario.empresa_id in (#{empresa})
      and honorario.datainativacao between '#{data_inicio}'::date and '#{data_fim}'::date
      and (parametros.tipo_id is null or honorario.tipo_id = parametros.tipo_id)
      and hono.id is null
      and honorario.tipohonorario_id = 1
      and honorario.ativo is false
      and (honorario.datainativacao > honorario.datavencimento)
      order by honorario.datainativacao desc"
  end

  def self.get_total_faturamento_12_meses_gruber(empresa)
    return "
        with meses as (
          select a::date as inicial, (a + INTERVAL'1 month' - INTERVAL'1 day')::date as final
          from generate_series((date_trunc('month', current_date - interval '13 month') + interval '1 month')::date, (date_trunc('month', current_date + interval '1 month') - interval '1 day')::date,INTERVAL'1 month') a
        ),
        totalizador AS (
          SELECT distinct
          debito.empresa_id as idEmpresa,
          debito.id as idDebito,
          tipo.id as idCobranca,
          tipo.nome as nomecobranca,
          cliente.id as idCliente,
          cliente.razaosocial as razaosocialcliente,
          cidade.nome || '-' || estado.sigla as cidade,
          estado.nome || '-' || estado.sigla as estado,
          estado.sigla,
          debito.datavencimento,
          debito.complemento,
          debito.saldo as saldoDebito,
          debito.valor as valorDebito,
          debito.status,
          case when tipo_valor.valor <> debito.valor then round(((tipo_valor.valor * 100)/(case when debito.valor = 0 then 1 else debito.valor end)),2) else 100 end as percentualPago,
            coalesce(debito_debitopago.valorjuros,0) as valorJurosTipo,
          SUM(
            coalesce(debito_debitopago.valor,0) +
            coalesce(debito_debitopago.valorjuros,0) +
            coalesce(debito_debitopago.valormulta,0) -
            coalesce(debito_debitopago.valordesconto,0)
          ) AS valorPago,
           debitopago.datapagamento,
           sum(coalesce(debito_debitopago.valor,0)) as valorpagodebito,
           sum(coalesce(debito_debitopago.valordesconto,0)) as valordescontodebito,
           sum(coalesce(debito_debitopago.valorjuros,0)) as valorjurosdebito,
           sum(coalesce(debito_debitopago.valorjuros,0) + coalesce(debito_debitopago.valor,0)) as valortotalpagodebito,
           0 as valorTipo,
           meses.final,
           TO_CHAR(meses.final, 'MM') AS finalFormatado
        FROM meses
        inner JOIN debitospagos debitopago ON debitopago.datapagamento::date between meses.inicial and meses.final and debitopago.empresa_id in (42,1706,3936)
        inner JOIN debito_debitospagos debito_debitopago ON debito_debitopago.debitopago_id = debitopago.id
        inner join debitos debito on debito.id = debito_debitopago.debito_id
        inner join tipocobrancavalor tipo_valor on tipo_valor.debito_id = debito.id
        inner join financeiro.clientefornecedorfinanceiro cliente ON cliente.id = debito.clifor_id
        LEFT JOIN tipocobranca tipo ON tipo.id = tipo_valor.tipocobranca_id
        left join municipio cidade on cidade.id = cliente.municipio_id
        left join estado estado on estado.id = cidade.estado_id
        where tipo_valor.tipocobranca_id not in (53, 54, 55, 58, 68, 56, 20, 23, 24, 25, 28, 37, 38, 39, 42, 26, 27, 29, 30, 35)
        group by idEmpresa, debito.id, idCobranca, nomecobranca, idCliente, razaosocialcliente, debito.status, debitopago.datapagamento, valorDebito,
                tipo_valor.valor, debito.parcela, cidade.nome, estado.sigla, estado.nome, meses.final, debito_debitopago.valor, debito_debitopago.valordesconto, debito_debitopago.valorjuros, debito_debitopago.valormulta
        ),
        sql as (
            SELECT distinct
                  debito.empresa_id as idEmpresa,
                  debito.id as idDebito,
                  tipo.id as idCobranca,
                  tipo.nome as nomecobranca,
                  cliente.id as idCliente,
                  cliente.razaosocial as razaosocialcliente,
                  cidade.nome || '-' || estado.sigla as cidade,
                  estado.nome || '-' || estado.sigla as estado,
                  estado.sigla,
                  debito.datavencimento,
                  debito.complemento,
                  debito.saldo as saldoDebito,
                  debito.valor as valorDebito,
                  debito.status,
                  case when tipo_valor.valor <> debito.valor then round(((tipo_valor.valor * 100)/(case when debito.valor = 0 then 1 else debito.valor end)),2) else 100 end as percentualPago,
                    coalesce(debito_debitopago.valorjuros,0) as valorJurosTipo,
                  SUM(
                    coalesce(debito_debitopago.valor,0) +
                    coalesce(debito_debitopago.valorjuros,0) +
                    coalesce(debito_debitopago.valormulta,0) -
                    coalesce(debito_debitopago.valordesconto,0)
                  ) AS valorPago,
                  debitopago.datapagamento,
                  debitopago.id,
                  sum(coalesce(debito_debitopago.valor,0)) as valorpagodebito,
                  sum(coalesce(debito_debitopago.valordesconto,0)) as valordescontodebito,
                  sum(coalesce(debito_debitopago.valorjuros,0)) as valorjurosdebito,
                  sum(coalesce(debito_debitopago.valorjuros,0) + coalesce(debito_debitopago.valor,0)) as valortotalpagodebito,
                  0 as valorTipo,
                  meses.final
          FROM meses
          inner JOIN debitospagos debitopago ON debitopago.datapagamento::date between meses.inicial and meses.final and debitopago.empresa_id in (42,3936,1706)
          inner JOIN debito_debitospagos debito_debitopago ON debito_debitopago.debitopago_id = debitopago.id
          inner join debitos debito on debito.id = debito_debitopago.debito_id
          inner join tipocobrancavalor tipo_valor on tipo_valor.debito_id = debito.id
          inner join financeiro.clientefornecedorfinanceiro cliente ON cliente.id = debito.clifor_id
          LEFT JOIN tipocobranca tipo ON tipo.id = tipo_valor.tipocobranca_id
          left join municipio cidade on cidade.id = cliente.municipio_id
          left join estado estado on estado.id = cidade.estado_id
          where tipo_valor.tipocobranca_id not in (53, 54, 55, 58, 68, 56, 20, 23, 24, 25, 28, 37, 38, 39, 42, 26, 27, 29, 30, 35)
          group by idEmpresa, debito.id, debitopago.id, idCobranca, nomecobranca, idCliente, razaosocialcliente, debito.status, debitopago.datapagamento, valorDebito,
                  tipo_valor.valor, debito.parcela, cidade.nome, estado.sigla, estado.nome, meses.final, debito_debitopago.valor, debito_debitopago.valordesconto, debito_debitopago.valorjuros, debito_debitopago.valormulta
          ),
          totalPorTipo as (
              with totalPorTipoid as (
                select sum(sql.valorpago) as totalGeral, sql.final, idcobranca, nomecobranca
                from sql
                  group by sql.final, sql.idcobranca, nomecobranca
                  order by sql.final
              )
              select 	sum(case when tipo.idcobranca = 1 then tipo.totalgeral else 0 end) as valorBalanco,
                sum(case when tipo.idcobranca = 2 then tipo.totalgeral else 0 end) as valorHonorario,
                sum(case when tipo.idcobranca not in (1,2) then tipo.totalgeral else 0 end) as valorOutros,
                tipo.final
              from totalPorTipoid tipo
              group by tipo.final
          ),
          totalFaturado as (
            select sum(totalizador.valorpago) as totalGeral, totalizador.final
            from totalizador
            group by totalizador.final
            order by totalizador.final
          )
          select TO_CHAR(meses.final, 'MM/YYYY') as data,
                coalesce(totalFaturado.totalGeral,0) as totalGeral,
                coalesce(tipo.valorBalanco,0) as valorBalanco,
                coalesce(tipo.valorHonorario,0) as valorHonorario,
                coalesce(tipo.valorOutros,0) as valorOutros
          from meses
          left join totalFaturado on totalFaturado.final = meses.final
          left join totalPorTipo tipo on tipo.final = totalFaturado.final
    "
  end

  def self.get_total_faturamento_mes_anterior_gruber(empresa)
    return "
       with meses as (
            select (date_trunc('month',current_date) - interval '1 month')::date as inicial,
                   case when extract('day' from current_date::date) = 1 then (current_date::date - interval '1 month')::date else ((current_date::date - interval '1 month'))::date end as final
	     ),
       sql as (
          SELECT distinct
                debito.empresa_id as idEmpresa,
                debito.id as idDebito,
                debitopago.id,
                tipo.id as idCobranca,
                tipo.nome as nomecobranca,
                cliente.id as idCliente,
                cliente.razaosocial as razaosocialcliente,
                cidade.nome || '-' || estado.sigla as cidade,
                estado.nome || '-' || estado.sigla as estado,
                estado.sigla,
                debito.datavencimento,
                debito.complemento,
                debito.saldo as saldoDebito,
                debito.valor as valorDebito,
                debito.status,
                case when tipo_valor.valor <> debito.valor then round(((tipo_valor.valor * 100)/(case when debito.valor = 0 then 1 else debito.valor end)),2) else 100 end as percentualPago,
                  coalesce(debito_debitopago.valorjuros,0) as valorJurosTipo,
                SUM(
                  coalesce(debito_debitopago.valor,0) +
                  coalesce(debito_debitopago.valorjuros,0) +
                  coalesce(debito_debitopago.valormulta,0) -
                  coalesce(debito_debitopago.valordesconto,0)
                ) AS valorPago,
                 debitopago.datapagamento,
                 sum(coalesce(debito_debitopago.valor,0)) as valorpagodebito,
                 sum(coalesce(debito_debitopago.valordesconto,0)) as valordescontodebito,
                 sum(coalesce(debito_debitopago.valorjuros,0)) as valorjurosdebito,
                 sum(coalesce(debito_debitopago.valorjuros,0) + coalesce(debito_debitopago.valor,0)) as valortotalpagodebito,
                 0 as valorTipo,
                 meses.final
        FROM meses
        inner JOIN debitospagos debitopago ON debitopago.datapagamento::date between meses.inicial and meses.final and debitopago.empresa_id in (#{empresa})
        inner JOIN debito_debitospagos debito_debitopago ON debito_debitopago.debitopago_id = debitopago.id
        inner join debitos debito on debito.id = debito_debitopago.debito_id
        inner join tipocobrancavalor tipo_valor on tipo_valor.debito_id = debito.id
        inner join financeiro.clientefornecedorfinanceiro cliente ON cliente.id = debito.clifor_id
        LEFT JOIN tipocobranca tipo ON tipo.id = tipo_valor.tipocobranca_id
        left join municipio cidade on cidade.id = cliente.municipio_id
        left join estado estado on estado.id = cidade.estado_id
        where tipo_valor.tipocobranca_id not in (53, 54, 55, 58, 68, 56, 20, 23, 24, 25, 28, 37, 38, 39, 42, 26, 27, 29, 30, 35)
        group by idEmpresa, debito.id, debitopago.id, idCobranca, nomecobranca, idCliente, razaosocialcliente, debito.status, debitopago.datapagamento, valorDebito,
		            tipo_valor.valor, debito.parcela, cidade.nome, estado.sigla, estado.nome, meses.final, debito_debitopago.valor, debito_debitopago.valordesconto, debito_debitopago.valorjuros, debito_debitopago.valormulta
        ),
	       totalPorTipo as (
            with totalPorTipoid as (
              select sum(sql.valorpago+sql.valorJurosTipo) as totalGeral, sql.final, idcobranca, nomecobranca
                from sql
                group by sql.final, sql.idcobranca, nomecobranca
                order by sql.final
            )
            select 	sum(case when tipo.idcobranca = 1 then tipo.totalgeral else 0 end) as valorBalanco,
              sum(case when tipo.idcobranca = 2 then tipo.totalgeral else 0 end) as valorHonorario,
              sum(case when tipo.idcobranca not in (1,2) then tipo.totalgeral else 0 end) as valorOutros,
              tipo.final
            from totalPorTipoid tipo
            group by tipo.final
	      ),
        totalFaturado as (
          select sum(sql.valorpago+sql.valorJurosTipo) as totalGeral, sql.final
          from sql
          group by sql.final
          order by sql.final
        )
        select TO_CHAR(meses.final, 'MM/YYYY') as data,
              coalesce(totalFaturado.totalGeral,0) as totalGeral,
              coalesce(tipo.valorBalanco,0) as valorBalanco,
              coalesce(tipo.valorHonorario,0) as valorHonorario,
              coalesce(tipo.valorOutros,0) as valorOutros
        from meses
        left join totalFaturado on totalFaturado.final = meses.final
        left join totalPorTipo tipo on tipo.final = totalFaturado.final
    "
  end

  def self.get_demonstrativo_12_meses_gruber(empresa)
    return "
    WITH meses as (
              select a::date as inicial, (a + INTERVAL'1 month' - INTERVAL'1 day')::date as final
              from generate_series((date_trunc('month', current_date - interval '13 month') + interval '1 month')::date, (date_trunc('month', current_date + interval '1 month') - interval '1 day')::date,INTERVAL'1 month') a
         ),
        SQL_RECEITA AS (
            SELECT distinct
            'RECEITA' as tipo,
            debito.empresa_id as idEmpresa,
            debito.id as idDebito,
            tipo.id as idCobranca,
            tipo.nome as nomecobranca,
            cliente.id as idCliente,
            cliente.razaosocial as razaosocialcliente,
            cidade.nome || '-' || estado.sigla as cidade,
            estado.nome || '-' || estado.sigla as estado,
            estado.sigla,
            debito.datavencimento,
            debito.complemento,
            debito.saldo as saldoDebito,
            debito.valor as valorDebito,
            debito.status,
            case when tipo_valor.valor <> debito.valor then round(((tipo_valor.valor * 100)/(case when debito.valor = 0 then 1 else debito.valor end)),2) else 100 end as percentualPago,
              coalesce(debito_debitopago.valorjuros,0) as valorJurosTipo,
            SUM(
              coalesce(debito_debitopago.valor,0) +
              coalesce(debito_debitopago.valorjuros,0) +
              coalesce(debito_debitopago.valormulta,0) -
              coalesce(debito_debitopago.valordesconto,0)
            ) AS valorPago,
            debitopago.datapagamento,
            sum(coalesce(debito_debitopago.valor,0)) as valorpagodebito,
            sum(coalesce(debito_debitopago.valordesconto,0)) as valordescontodebito,
            sum(coalesce(debito_debitopago.valorjuros,0)) as valorjurosdebito,
            sum(coalesce(debito_debitopago.valorjuros,0) + coalesce(debito_debitopago.valor,0)) as valortotalpagodebito,
            0 as valorTipo,
            meses.final,
            TO_CHAR(meses.final, 'MM') AS finalFormatado
          FROM meses
          inner JOIN debitospagos debitopago ON debitopago.datapagamento::date between meses.inicial and meses.final and debitopago.empresa_id in (42,1706,3936)
          inner JOIN debito_debitospagos debito_debitopago ON debito_debitopago.debitopago_id = debitopago.id
          inner join debitos debito on debito.id = debito_debitopago.debito_id
          inner join tipocobrancavalor tipo_valor on tipo_valor.debito_id = debito.id
          inner join financeiro.clientefornecedorfinanceiro cliente ON cliente.id = debito.clifor_id
          LEFT JOIN tipocobranca tipo ON tipo.id = tipo_valor.tipocobranca_id
          left join municipio cidade on cidade.id = cliente.municipio_id
          left join estado estado on estado.id = cidade.estado_id
          where tipo_valor.tipocobranca_id not in (53, 54, 55, 58, 68, 56, 20, 23, 24, 25, 28, 37, 38, 39, 42, 26, 27, 29, 30, 35)
          group by idEmpresa, debito.id, idCobranca, nomecobranca, idCliente, razaosocialcliente, debito.status, debitopago.datapagamento, valorDebito,
                  tipo_valor.valor, debito.parcela, cidade.nome, estado.sigla, estado.nome, meses.final, debito_debitopago.valor, debito_debitopago.valordesconto, debito_debitopago.valorjuros, debito_debitopago.valormulta
        ),
        SOMAR_RECEITA AS (
            SELECT
                tipo,
                final,
                sum(valorPago) AS valorpago
            FROM
                SQL_RECEITA
            GROUP BY
                tipo,
                final
            ORDER BY
                final
        ),
        SQL_DESPESAS AS (
            SELECT DISTINCT
                'DESPESA' AS tipo,
                TO_CHAR(despesa.datapagamento, 'MM/YYYY') AS DATA,
                despesa.empresa_id AS idEmpresa,
                despesa.id AS idDebito,
                tipodespesa.id AS idCobranca,
                tipodespesa.descricao AS nomecobranca,
                0.00::numeric AS saldoDebito,
                despesa.valor AS valorDebito,
                'PAGO' AS status,
                100 AS percentualPago,
                0.00::numeric AS valorJurosTipo,
                despesa.valor AS valorPago,
            meses.final
            FROM
            meses
                INNER JOIN despesa despesa ON despesa.datapagamento BETWEEN meses.inicial AND meses.final
                AND despesa.empresa_id in (#{empresa})
                INNER JOIN tipodespesa tipodespesa ON tipodespesa.id = despesa.tipodespesa_id
            GROUP BY
                idEmpresa,
                despesa.id,
                idCobranca,
                nomecobranca,
                despesa.datapagamento,
                valorDebito,
            meses.final
        ),
        SOMAR_DESPESA AS (
            SELECT
                tipo,
                final,
                sum(valorPago) AS valorpago
            FROM
                SQL_DESPESAS
            GROUP BY
                tipo,
                final
            ORDER BY
                final
        )
        SELECT TO_CHAR(rec.final, 'MM/YYYY') AS data, coalesce(rec.valorpago,0) as total_receitas, coalesce(des.valorpago,0) as total_despesas, coalesce(rec.valorpago-des.valorpago,0) as resultado
        FROM SOMAR_RECEITA rec
        LEFT JOIN SOMAR_DESPESA des ON des.final = rec.final
        order by rec.final
    "
  end
  
  def self.get_receitas_12_meses_gruber (empresa, script, ordem)
    return "
    WITH meses as (
              select a::date as inicial, (a + INTERVAL'1 month' - INTERVAL'1 day')::date as final
              from generate_series((date_trunc('month', current_date - interval '12 month') + interval '1 month')::date, (date_trunc('month', current_date + interval '1 month') - interval '1 day')::date,INTERVAL'1 month') a
         ),
        SQL_RECEITA AS (
          SELECT distinct
          debito.empresa_id as idEmpresa,
          debito.id as idDebito,
          tipo.id as idCobranca,
          tipo.nome as nomecobranca,
          cliente.id as idCliente,
          cliente.razaosocial as razaosocialcliente,
          cidade.nome || '-' || estado.sigla as cidade,
          estado.nome || '-' || estado.sigla as estado,
          estado.sigla,
          debito.datavencimento,
          debito.complemento,
          debito.saldo as saldoDebito,
          debito.valor as valorDebito,
          debito.status,
          case when tipo_valor.valor <> debito.valor then round(((tipo_valor.valor * 100)/(case when debito.valor = 0 then 1 else debito.valor end)),2) else 100 end as percentualPago,
            coalesce(debito_debitopago.valorjuros,0) as valorJurosTipo,
          SUM(
            coalesce(debito_debitopago.valor,0) +
            coalesce(debito_debitopago.valorjuros,0) +
            coalesce(debito_debitopago.valormulta,0) -
            coalesce(debito_debitopago.valordesconto,0)
          ) AS valorPago,
           debitopago.datapagamento,
           sum(coalesce(debito_debitopago.valor,0)) as valorpagodebito,
           sum(coalesce(debito_debitopago.valordesconto,0)) as valordescontodebito,
           sum(coalesce(debito_debitopago.valorjuros,0)) as valorjurosdebito,
           sum(coalesce(debito_debitopago.valorjuros,0) + coalesce(debito_debitopago.valor,0)) as valortotalpagodebito,
           0 as valorTipo,
           meses.final,
           TO_CHAR(meses.final, 'MM') AS finalFormatado
        FROM meses
        inner JOIN debitospagos debitopago ON debitopago.datapagamento::date between meses.inicial and meses.final and debitopago.empresa_id in (#{empresa})
        inner JOIN debito_debitospagos debito_debitopago ON debito_debitopago.debitopago_id = debitopago.id
        inner join debitos debito on debito.id = debito_debitopago.debito_id
        inner join tipocobrancavalor tipo_valor on tipo_valor.debito_id = debito.id
        inner join financeiro.clientefornecedorfinanceiro cliente ON cliente.id = debito.clifor_id
        LEFT JOIN tipocobranca tipo ON tipo.id = tipo_valor.tipocobranca_id
        left join municipio cidade on cidade.id = cliente.municipio_id
        left join estado estado on estado.id = cidade.estado_id
        where tipo_valor.tipocobranca_id not in (53, 54, 55, 58, 68, 56, 20, 23, 24, 25, 28, 37, 38, 39, 42, 26, 27, 29, 30, 35)
        group by idEmpresa, debito.id, idCobranca, nomecobranca, idCliente, razaosocialcliente, debito.status, debitopago.datapagamento, valorDebito,
                tipo_valor.valor, debito.parcela, cidade.nome, estado.sigla, estado.nome, meses.final, debito_debitopago.valor, debito_debitopago.valordesconto, debito_debitopago.valorjuros, debito_debitopago.valormulta
        ),
        SOMAR_RECEITA AS (
            SELECT
                idCobranca,
                nomecobranca,
                sum(case when finalFormatado = '01' then valorPago else 0 end) as m1,
                sum(case when finalFormatado = '02' then valorPago else 0 end) as m2,
                sum(case when finalFormatado = '03' then valorPago else 0 end) as m3,
                sum(case when finalFormatado = '04' then valorPago else 0 end) as m4,
                sum(case when finalFormatado = '05' then valorPago else 0 end) as m5,
                sum(case when finalFormatado = '06' then valorPago else 0 end) as m6,
                sum(case when finalFormatado = '07' then valorPago else 0 end) as m7,
                sum(case when finalFormatado = '08' then valorPago else 0 end) as m8,
                sum(case when finalFormatado = '09' then valorPago else 0 end) as m9,
                sum(case when finalFormatado = '10' then valorPago else 0 end) as m10,
                sum(case when finalFormatado = '11' then valorPago else 0 end) as m11,
                sum(case when finalFormatado = '12' then valorPago else 0 end) as m12
            FROM
                SQL_RECEITA
            GROUP BY
		idCobranca,
		nomecobranca			
            ORDER BY
                idCobranca
        ),
        SQL_DESPESAS AS (
          SELECT DISTINCT
              'DESPESA' AS tipo,
              TO_CHAR(despesa.datapagamento, 'MM/YYYY') AS DATA,
              despesa.empresa_id AS idEmpresa,
              despesa.id AS idDebito,
              tipodespesa.id AS idCobranca,
              tipodespesa.descricao AS nomecobranca,
              0.00::numeric AS saldoDebito,
              despesa.valor AS valorDebito,
              'PAGO' AS status,
              100 AS percentualPago,
              0.00::numeric AS valorJurosTipo,
              despesa.valor AS valorPago,
                      meses.final,
                      TO_CHAR(meses.final, 'MM') AS finalFormatado
          FROM
              meses
              INNER JOIN despesa despesa ON despesa.datapagamento BETWEEN meses.inicial AND meses.final
              AND despesa.empresa_id in (#{empresa})
              INNER JOIN tipodespesa tipodespesa ON tipodespesa.id = despesa.tipodespesa_id
          GROUP BY
              idEmpresa,
              despesa.id,
              idCobranca,
              nomecobranca,
              despesa.datapagamento,
              valorDebito,
          meses.final
      ),
        SOMAR_DESPESA AS (
            SELECT
                idCobranca,
                nomecobranca,
                sum(case when finalFormatado = '01' then valorPago else 0 end) as m1,
                        sum(case when finalFormatado = '02' then valorPago else 0 end) as m2,
                        sum(case when finalFormatado = '03' then valorPago else 0 end) as m3,
                        sum(case when finalFormatado = '04' then valorPago else 0 end) as m4,
                        sum(case when finalFormatado = '05' then valorPago else 0 end) as m5,
                        sum(case when finalFormatado = '06' then valorPago else 0 end) as m6,
                        sum(case when finalFormatado = '07' then valorPago else 0 end) as m7,
                        sum(case when finalFormatado = '08' then valorPago else 0 end) as m8,
                        sum(case when finalFormatado = '09' then valorPago else 0 end) as m9,
                        sum(case when finalFormatado = '10' then valorPago else 0 end) as m10,
                        sum(case when finalFormatado = '11' then valorPago else 0 end) as m11,
                        sum(case when finalFormatado = '12' then valorPago else 0 end) as m12
            FROM
                SQL_DESPESAS
            GROUP BY
                idCobranca,
                nomecobranca
            ORDER BY
                idCobranca
        )
        select * FROM #{script} order by #{ordem} desc
    "
  end

  def self.get_resultado_12_meses_gruber(empresa)
    return "
    WITH meses as (
      select a::date as inicial, (a + INTERVAL'1 month' - INTERVAL'1 day')::date as final
      from generate_series((date_trunc('month', current_date - interval '12 month') + interval '1 month')::date, (date_trunc('month', current_date + interval '1 month') - interval '1 day')::date,INTERVAL'1 month') a
    ),
    SQL_RECEITA AS (
      SELECT distinct
			'RECEITA' AS tipo,
          debito.empresa_id as idEmpresa,
          debito.id as idDebito,
          tipo.id as idCobranca,
          tipo.nome as nomecobranca,
          cliente.id as idCliente,
          cliente.razaosocial as razaosocialcliente,
          cidade.nome || '-' || estado.sigla as cidade,
          estado.nome || '-' || estado.sigla as estado,
          estado.sigla,
          debito.datavencimento,
          debito.complemento,
          debito.saldo as saldoDebito,
          debito.valor as valorDebito,
          debito.status,
          case when tipo_valor.valor <> debito.valor then round(((tipo_valor.valor * 100)/(case when debito.valor = 0 then 1 else debito.valor end)),2) else 100 end as percentualPago,
            coalesce(debito_debitopago.valorjuros,0) as valorJurosTipo,
          SUM(
            coalesce(debito_debitopago.valor,0) +
            coalesce(debito_debitopago.valorjuros,0) +
            coalesce(debito_debitopago.valormulta,0) -
            coalesce(debito_debitopago.valordesconto,0)
          ) AS valorPago,
           debitopago.datapagamento,
           sum(coalesce(debito_debitopago.valor,0)) as valorpagodebito,
           sum(coalesce(debito_debitopago.valordesconto,0)) as valordescontodebito,
           sum(coalesce(debito_debitopago.valorjuros,0)) as valorjurosdebito,
           sum(coalesce(debito_debitopago.valorjuros,0) + coalesce(debito_debitopago.valor,0)) as valortotalpagodebito,
           0 as valorTipo,
           meses.final,
           TO_CHAR(meses.final, 'MM') AS finalFormatado
        FROM meses
        inner JOIN debitospagos debitopago ON debitopago.datapagamento::date between meses.inicial and meses.final and debitopago.empresa_id in (#{empresa})
        inner JOIN debito_debitospagos debito_debitopago ON debito_debitopago.debitopago_id = debitopago.id
        inner join debitos debito on debito.id = debito_debitopago.debito_id
        inner join tipocobrancavalor tipo_valor on tipo_valor.debito_id = debito.id
        inner join financeiro.clientefornecedorfinanceiro cliente ON cliente.id = debito.clifor_id
        LEFT JOIN tipocobranca tipo ON tipo.id = tipo_valor.tipocobranca_id
        left join municipio cidade on cidade.id = cliente.municipio_id
        left join estado estado on estado.id = cidade.estado_id
        where tipo_valor.tipocobranca_id not in (53, 54, 55, 58, 68, 56, 20, 23, 24, 25, 28, 37, 38, 39, 42, 26, 27, 29, 30, 35)
        group by idEmpresa, debito.id, idCobranca, nomecobranca, idCliente, razaosocialcliente, debito.status, debitopago.datapagamento, valorDebito,
                tipo_valor.valor, debito.parcela, cidade.nome, estado.sigla, estado.nome, meses.final, debito_debitopago.valor, debito_debitopago.valordesconto, debito_debitopago.valorjuros, debito_debitopago.valormulta
    ),
    SOMAR_RECEITA AS (
        SELECT
            1 as categoria,
            'RECEITAS'::varchar as tipo,
            sum(case when finalFormatado = '01' then valorPago else 0 end) as m1,
            sum(case when finalFormatado = '02' then valorPago else 0 end) as m2,
            sum(case when finalFormatado = '03' then valorPago else 0 end) as m3,
            sum(case when finalFormatado = '04' then valorPago else 0 end) as m4,
            sum(case when finalFormatado = '05' then valorPago else 0 end) as m5,
            sum(case when finalFormatado = '06' then valorPago else 0 end) as m6,
            sum(case when finalFormatado = '07' then valorPago else 0 end) as m7,
            sum(case when finalFormatado = '08' then valorPago else 0 end) as m8,
            sum(case when finalFormatado = '09' then valorPago else 0 end) as m9,
            sum(case when finalFormatado = '10' then valorPago else 0 end) as m10,
            sum(case when finalFormatado = '11' then valorPago else 0 end) as m11,
            sum(case when finalFormatado = '12' then valorPago else 0 end) as m12
        FROM
            SQL_RECEITA
    ),
    SQL_DESPESAS AS (
      SELECT DISTINCT
          'DESPESA' AS tipo,
          TO_CHAR(despesa.datapagamento, 'MM/YYYY') AS DATA,
          despesa.empresa_id AS idEmpresa,
          despesa.id AS idDebito,
          tipodespesa.id AS idCobranca,
          tipodespesa.descricao AS nomecobranca,
          0.00::numeric AS saldoDebito,
          despesa.valor AS valorDebito,
          'PAGO' AS status,
          100 AS percentualPago,
          0.00::numeric AS valorJurosTipo,
          despesa.valor AS valorPago,
                  meses.final,
                  TO_CHAR(meses.final, 'MM') AS finalFormatado
      FROM
          meses
          INNER JOIN despesa despesa ON despesa.datapagamento BETWEEN meses.inicial AND meses.final
          AND despesa.empresa_id in (#{empresa})
          INNER JOIN tipodespesa tipodespesa ON tipodespesa.id = despesa.tipodespesa_id
      GROUP BY
          idEmpresa,
          despesa.id,
          idCobranca,
          nomecobranca,
          despesa.datapagamento,
          valorDebito,
      meses.final
    ),
    SOMAR_DESPESA AS (
        SELECT
            2 as categoria,
            'DESPESAS'::varchar as tipo,
            sum(case when finalFormatado = '01' then valorPago else 0 end) as m1,
                    sum(case when finalFormatado = '02' then valorPago else 0 end) as m2,
                    sum(case when finalFormatado = '03' then valorPago else 0 end) as m3,
                    sum(case when finalFormatado = '04' then valorPago else 0 end) as m4,
                    sum(case when finalFormatado = '05' then valorPago else 0 end) as m5,
                    sum(case when finalFormatado = '06' then valorPago else 0 end) as m6,
                    sum(case when finalFormatado = '07' then valorPago else 0 end) as m7,
                    sum(case when finalFormatado = '08' then valorPago else 0 end) as m8,
                    sum(case when finalFormatado = '09' then valorPago else 0 end) as m9,
                    sum(case when finalFormatado = '10' then valorPago else 0 end) as m10,
                    sum(case when finalFormatado = '11' then valorPago else 0 end) as m11,
                    sum(case when finalFormatado = '12' then valorPago else 0 end) as m12
        FROM
            SQL_DESPESAS
    ),
	resultado as (
		select 3 as categoria,
            'RESULTADOS'::varchar as tipo,
            (SOMAR_RECEITA.m1 - SOMAR_DESPESA.m1) as m1,
			(SOMAR_RECEITA.m2 - SOMAR_DESPESA.m2) as m2,
			(SOMAR_RECEITA.m3 - SOMAR_DESPESA.m3) as m3,
			(SOMAR_RECEITA.m4 - SOMAR_DESPESA.m4) as m4,
			(SOMAR_RECEITA.m5 - SOMAR_DESPESA.m5) as m5,
			(SOMAR_RECEITA.m6 - SOMAR_DESPESA.m6) as m6,
			(SOMAR_RECEITA.m7 - SOMAR_DESPESA.m7) as m7,
			(SOMAR_RECEITA.m8 - SOMAR_DESPESA.m8) as m8,
			(SOMAR_RECEITA.m9 - SOMAR_DESPESA.m9) as m9,
			(SOMAR_RECEITA.m10 - SOMAR_DESPESA.m10) as m10,
			(SOMAR_RECEITA.m11 - SOMAR_DESPESA.m11) as m11,
			(SOMAR_RECEITA.m12 - SOMAR_DESPESA.m12) as m12
		from ( select true ) x
		left join SOMAR_RECEITA on true
		left join SOMAR_DESPESA on true

		UNION

		select 4 as categoria,
            'MARGEM'::varchar as tipo,
            ROUND(((SOMAR_RECEITA.m1 - SOMAR_DESPESA.m1)/ (case when SOMAR_RECEITA.m1 = 0 then 1 else SOMAR_RECEITA.m1 end )) * 100,2) as m1,
            ROUND(((SOMAR_RECEITA.m2 - SOMAR_DESPESA.m2)/(case when SOMAR_RECEITA.m2 = 0 then 1 else SOMAR_RECEITA.m2 end )) * 100,2) as m2,
            ROUND(((SOMAR_RECEITA.m3 - SOMAR_DESPESA.m3)/(case when SOMAR_RECEITA.m3 = 0 then 1 else SOMAR_RECEITA.m3 end )) * 100,2) as m3,
            ROUND(((SOMAR_RECEITA.m4 - SOMAR_DESPESA.m4)/(case when SOMAR_RECEITA.m4 = 0 then 1 else SOMAR_RECEITA.m4 end )) * 100,2) as m4,
            ROUND(((SOMAR_RECEITA.m5 - SOMAR_DESPESA.m5)/(case when SOMAR_RECEITA.m5 = 0 then 1 else SOMAR_RECEITA.m5 end )) * 100,2) as m5,
            ROUND(((SOMAR_RECEITA.m6 - SOMAR_DESPESA.m6)/(case when SOMAR_RECEITA.m6 = 0 then 1 else SOMAR_RECEITA.m6 end )) * 100,2) as m6,
            ROUND(((SOMAR_RECEITA.m7 - SOMAR_DESPESA.m7)/(case when SOMAR_RECEITA.m7 = 0 then 1 else SOMAR_RECEITA.m7 end )) * 100,2) as m7,
            ROUND(((SOMAR_RECEITA.m8 - SOMAR_DESPESA.m8)/(case when SOMAR_RECEITA.m8 = 0 then 1 else SOMAR_RECEITA.m8 end )) * 100,2) as m8,
            ROUND(((SOMAR_RECEITA.m9 - SOMAR_DESPESA.m9)/(case when SOMAR_RECEITA.m9 = 0 then 1 else SOMAR_RECEITA.m9 end )) * 100,2) as m9,
            ROUND(((SOMAR_RECEITA.m10 - SOMAR_DESPESA.m10)/(case when SOMAR_RECEITA.m10 = 0 then 1 else SOMAR_RECEITA.m10 end )) * 100,2) as m10,
            ROUND(((SOMAR_RECEITA.m11 - SOMAR_DESPESA.m11)/(case when SOMAR_RECEITA.m11 = 0 then 1 else SOMAR_RECEITA.m11 end )) * 100,2) as m11,
            ROUND(((SOMAR_RECEITA.m12 - SOMAR_DESPESA.m12)/(case when SOMAR_RECEITA.m12 = 0 then 1 else SOMAR_RECEITA.m12 end )) * 100,2) as m12
		from ( select true ) x
		left join SOMAR_RECEITA on true
		left join SOMAR_DESPESA on true
	),
  sqlFinal as(
    select *
    FROM SOMAR_RECEITA

    UNION

    SELECT *
    from SOMAR_DESPESA

	UNION

	select *
	from resultado
  )
  select *
  from sqlFinal
  order by categoria

    "
  end

  def self.get_resumo_ultimos_5_anos(empresa)
    return "
    WITH meses as (
      select a::date as inicial,
      case when a < date_trunc('year', current_date)
          then (a + interval '1 year' - interval '1 day')::date
          else (date_trunc('month', current_date) - interval '1 day')::date
      end as final,
      TO_CHAR(a::date, 'YYYY') as ano
      from generate_series((date_trunc('year', current_date - interval '4 year'))::date, (date_trunc('month', current_date + interval '1 month'))::date,INTERVAL'1 year') a
),
    SQL_RECEITA AS (
      SELECT distinct
			'RECEITA' AS tipo,
                  debito.empresa_id as idEmpresa,
                  cliente.id as idCliente,
                  cliente.razaosocial as razaosocialcliente,
                  cidade.nome || '-' || estado.sigla as cidade,
                  estado.nome || '-' || estado.sigla as estado,
                  estado.sigla,
                  debitopago.valorrecebido AS valorPago,
                  debitopago.datapagamento,
                  debitopago.id,
                  0 as valorTipo,
                  meses.final,
				  TO_CHAR(meses.final, 'YYYY') AS finalFormatado	
          FROM meses
          inner JOIN debitospagos debitopago ON debitopago.datapagamento::date between meses.inicial and meses.final 
		  and debitopago.empresa_id in (#{empresa})
          inner JOIN debito_debitospagos debito_debitopago ON debito_debitopago.debitopago_id = debitopago.id
          inner join debitos debito on debito.id = debito_debitopago.debito_id
          inner join tipocobrancavalor tipo_valor on tipo_valor.debito_id = debito.id
          inner join financeiro.clientefornecedorfinanceiro cliente ON cliente.id = debito.clifor_id
          LEFT JOIN tipocobranca tipo ON tipo.id = tipo_valor.tipocobranca_id
          left join municipio cidade on cidade.id = cliente.municipio_id
          left join estado estado on estado.id = cidade.estado_id
          where tipo_valor.tipocobranca_id not in (53, 54, 55, 58, 68, 56, 20, 23, 24, 25, 28, 37, 38, 39, 42, 26, 27, 29, 30, 35)
          group by 
        idEmpresa, 
        debito.id, 
        debitopago.id,
        idCliente, 
        razaosocialcliente, 
        debito.status, 
        debitopago.datapagamento, 
        debitopago.valorrecebido,
        --tipo_valor.valor, 
        --debito.parcela, 
        cidade.nome, 
        estado.sigla, 
        estado.nome, 
        meses.final
    ),
    SOMAR_RECEITA AS (
        SELECT
             1 as categoria,
            'RECEITAS'::varchar as tipo,
			sum(valorPago) as total,
			sum(case when TO_CHAR(current_date, 'MM/YYYY') = TO_CHAR(SQL_RECEITA.datapagamento, 'MM/YYYY') then 0 else valorPago end) valorMedia,
			finalFormatado
        FROM
            SQL_RECEITA
		GROUP BY finalFormatado
    ),
    SQL_DESPESAS AS (
      SELECT DISTINCT
          'DESPESA' AS tipo,
          TO_CHAR(despesa.datapagamento, 'MM/YYYY') AS DATA,
          despesa.empresa_id AS idEmpresa,
          despesa.id AS idDebito,
          tipodespesa.id AS idCobranca,
          tipodespesa.descricao AS nomecobranca,
          0.00::numeric AS saldoDebito,
          despesa.valor AS valorDebito,
          'PAGO' AS status,
          100 AS percentualPago,
          0.00::numeric AS valorJurosTipo,
          despesa.valor AS valorPago,
		  meses.final,
		  TO_CHAR(meses.final, 'YYYY') AS finalFormatado
      FROM
          meses
          INNER JOIN despesa despesa ON despesa.datapagamento BETWEEN meses.inicial AND meses.final
          AND despesa.empresa_id in (#{empresa})
          INNER JOIN tipodespesa tipodespesa ON tipodespesa.id = despesa.tipodespesa_id
      GROUP BY
          idEmpresa,
          despesa.id,
          idCobranca,
          nomecobranca,
          despesa.datapagamento,
          valorDebito,
      	meses.final
    ),
    SOMAR_DESPESA AS (
		SELECT
             2 as categoria,
            'DESPESAS'::varchar as tipo,
			sum(valorPago) as total,
			sum(valorPago) valorMedia,
			finalFormatado
        FROM
            SQL_DESPESAS
		GROUP BY finalFormatado
    ),
	resultados as (
		select meses.ano,
			  coalesce(SOMAR_RECEITA.total,0) as receita,
				coalesce(SOMAR_DESPESA.total,0) as despesa,
				coalesce(SOMAR_RECEITA.total, 0) - coalesce(SOMAR_DESPESA.total, 0) as resultado,
				(coalesce(SOMAR_RECEITA.valorMedia,0) - coalesce(SOMAR_DESPESA.valorMedia, 0)) as resultadoSemMesAtual,
				(coalesce(SOMAR_RECEITA.total,0) - coalesce(SOMAR_DESPESA.total, 0)) / 12 as mediamensal

		from meses
		left join SOMAR_RECEITA on SOMAR_RECEITA.finalFormatado = meses.ano
		left join SOMAR_DESPESA on SOMAR_DESPESA.finalFormatado = meses.ano
	)

    select *
    FROM resultados
	order by ano
    "
  end

  def self.get_faturamento_por_tipo(empresa, data)
    return "

    with meses as (
      select a::date as inicial, (a + INTERVAL'1 month' - INTERVAL'1 day')::date as final
      from generate_series((date_trunc('month', current_date - interval '12 month') + interval '1 month')::date, (date_trunc('month', current_date + interval '1 month') - interval '1 day')::date,INTERVAL'1 month') a
    ),
    sql as (
      SELECT distinct
      debito.empresa_id as idEmpresa,
      debito.id as idDebito,
      tipo.id as idCobranca,
      tipo.nome as nomecobranca,
      cliente.id as idCliente,
      cliente.razaosocial as razaosocialcliente,
      cidade.nome || '-' || estado.sigla as cidade,
      estado.nome || '-' || estado.sigla as estado,
      estado.sigla,
      debito.datavencimento,
      debito.complemento,
      debito.saldo as saldoDebito,
      debito.valor as valorDebito,
      debito.status,
      case when tipo_valor.valor <> debito.valor then round(((tipo_valor.valor * 100)/(case when debito.valor = 0 then 1 else debito.valor end)),2) else 100 end as percentualPago,
      coalesce(debito_debitopago.valorjuros,0) as valorJurosTipo,
      SUM(
        coalesce(debito_debitopago.valor,0) +
        coalesce(debito_debitopago.valorjuros,0) +
        coalesce(debito_debitopago.valormulta,0) -
        coalesce(debito_debitopago.valordesconto,0)
      ) AS valorPago,
      debitopago.datapagamento,
      sum(coalesce(debito_debitopago.valor,0)) as valorpagodebito,
      sum(coalesce(debito_debitopago.valordesconto,0)) as valordescontodebito,
      sum(coalesce(debito_debitopago.valorjuros,0)) as valorjurosdebito,
      sum(coalesce(debito_debitopago.valorjuros,0) + coalesce(debito_debitopago.valor,0)) as valortotalpagodebito,
      0 as valorTipo,
      meses.final
      FROM meses
      inner JOIN debitospagos debitopago ON debitopago.datapagamento between meses.inicial and meses.final and debitopago.empresa_id in (#{empresa})
      inner JOIN debito_debitospagos debito_debitopago ON debito_debitopago.debitopago_id = debitopago.id
      inner join debitos debito on debito.id = debito_debitopago.debito_id
      inner join tipocobrancavalor tipo_valor on tipo_valor.debito_id = debito.id
      inner join financeiro.clientefornecedorfinanceiro cliente ON cliente.id = debito.clifor_id
      LEFT JOIN tipocobranca tipo ON tipo.id = tipo_valor.tipocobranca_id
      left join municipio cidade on cidade.id = cliente.municipio_id
      left join estado estado on estado.id = cidade.estado_id
      group by idEmpresa, debito.id, idCobranca, nomecobranca, idCliente, razaosocialcliente, debito.status, debitopago.datapagamento, valorDebito,
      tipo_valor.valor, debito.parcela, cidade.nome, estado.sigla, estado.nome, meses.final, debito_debitopago.valor, debito_debitopago.valordesconto, debito_debitopago.valorjuros, debito_debitopago.valormulta
    ),
    totalPorTipo as (
      select sum(sql.valorpago+sql.valorJurosTipo) as totalGeral, sql.final, idcobranca, nomecobranca
      from sql
      group by sql.final, sql.idcobranca, nomecobranca
      order by sql.final
    )
    select *
    from totalPorTipo
    where final =  '#{data}'
    order by totalgeral desc

    "
  end

  def self.get_inadimplencia_12_meses(empresa)
    return "
      with meses as (
        select a::date as inicial, (a + INTERVAL'1 month' - INTERVAL'1 day')::date as final
        from generate_series((date_trunc('month', current_date - interval '13 month') + interval '1 month')::date, (date_trunc('month', current_date + interval '1 month') - interval '1 day')::date,INTERVAL'1 month') a
      ),
      sqlSemBoleto as(
        select  debito.id as debito_id,
        debito.saldo saldoDebito,
        debito.valor valorDebito,
        debito.valorjurosboleto,
        debito.status as status_boleto,
        debito.datavencimento,
        tipo.id as idCobranca,
        tipo.nome as nomecobranca,
        cliente.id as idCliente,
        cliente.razaosocial as razaosocialcliente,
        cidade.nome || '-' || estado.sigla as cidade,
        estado.nome || '-' || estado.sigla as estado,
        estado.sigla,
        tipo_valor.tipocobranca_id,
        tipo_valor.valor as valorTipo,
        sum(coalesce(debito_debitopago.valor,0)) as valorpagodebito,
        sum(coalesce(debito_debitopago.valordesconto,0)) as valordescontodebito,
        sum(coalesce(debito_debitopago.valorjuros,0)) as valorjurosdebito,
        debitopago.datapagamento,
        meses.final
        from meses
        inner join debitos debito on debito.empresa_id in (#{empresa}) and debito.datavencimento < (current_date - interval '1 day')
        and debito.boletogerado_id is null and debito.status <> 'EXCLUIDO' and debito.status <> 'PARCELADO'
        left JOIN debito_debitospagos debito_debitopago ON debito_debitopago.debito_id = debito.id
        left JOIN debitospagos debitopago ON debitopago.id = debito_debitopago.debitopago_id
        inner join tipocobrancavalor tipo_valor on tipo_valor.debito_id = debito.id
        inner join financeiro.clientefornecedorfinanceiro cliente ON cliente.id = debito.clifor_id and cliente.parceiro is false
        LEFT JOIN tipocobranca tipo ON tipo.id = tipo_valor.tipocobranca_id
        left join municipio cidade on cidade.id = cliente.municipio_id
        left join estado estado on estado.id = cidade.estado_id
        where meses.final between debito.datavencimento and (case when debitopago.id is null then meses.final else debitopago.datapagamento end)
        and (debitopago.id is null or extract(month from debito.datavencimento) != extract(month from debitopago.datapagamento))
        and (debitopago.id is null or meses.final != debitopago.datapagamento)
        and (debitopago.id is not null or debito.datavencimento < current_date)
        group by debito.id, debito.saldo, debito.status, debito.valor, debito.datavencimento, debito.valorjurosboleto, tipo.id, tipo.nome, cliente.id,
        cliente.razaosocial, estado.sigla, cidade.nome, estado.nome, tipo_valor.tipocobranca_id, tipo_valor.valor, meses.final, debitopago.datapagamento
        order by meses.final
      ),
      sqlComBoleto as(
        select boleto.id as boleto_id,
        boleto.empresa_id,
        boleto.datavencimento,
        boleto.valorboleto,
        debito.id as debito_id,
        debito.saldo saldoDebito,
        debito.valor valorDebito,
        debito.valorjurosboleto,
        debito.status as status_boleto,
        tipo.id as idCobranca,
        tipo.nome as nomecobranca,
        cliente.id as idCliente,
        cliente.razaosocial as razaosocialcliente,
        cidade.nome || '-' || estado.sigla as cidade,
        estado.nome || '-' || estado.sigla as estado,
        estado.sigla,
        tipo_valor.tipocobranca_id,
        tipo_valor.valor as valorTipo,
        sum(coalesce(debito_debitopago.valor,0)) as valorpagodebito,
        sum(coalesce(debito_debitopago.valordesconto,0)) as valordescontodebito,
        sum(coalesce(debito_debitopago.valorjuros,0)) as valorjurosdebito,
        debitopago.datapagamento,
        meses.final
        from  meses
        inner join boletogerado boleto on meses.final between boleto.datavencimento and (case when boleto.status = 'PAGO' then boleto.datapagamento else meses.final end)
        and boleto.status <> 'EXCLUIDO' and  boleto.empresa_id in (#{empresa})
        inner join debitos debito on debito.boletogerado_id = boleto.id and boleto.clifor_id = debito.clifor_id and boleto.empresa_id = debito.empresa_id  and boleto.status = debito.status
        left JOIN debito_debitospagos debito_debitopago ON debito_debitopago.debito_id = debito.id
        left JOIN debitospagos debitopago ON debitopago.id = debito_debitopago.debitopago_id
        inner join tipocobrancavalor tipo_valor on tipo_valor.debito_id = debito.id
        inner join financeiro.clientefornecedorfinanceiro cliente ON cliente.id = debito.clifor_id
        LEFT JOIN tipocobranca tipo ON tipo.id = tipo_valor.tipocobranca_id
        left join municipio cidade on cidade.id = cliente.municipio_id
        left join estado estado on estado.id = cidade.estado_id
        where meses.final between boleto.datavencimento and (case when debitopago.id is null then meses.final else debitopago.datapagamento end)
        and (debitopago.id is null or extract(month from boleto.datavencimento) != extract(month from debitopago.datapagamento))
        and (debitopago.id is null or meses.final != debitopago.datapagamento)
        and (debitopago.id is not null or boleto.datavencimento < current_date)
        group by boleto.id, boleto.empresa_id, boleto.datavencimento,boleto.valorboleto, debito.id, debito.saldo, debito.status, debito.valor, debito.valorjurosboleto, tipo.id, tipo.nome, cliente.id,
        cliente.razaosocial, estado.sigla, cidade.nome, estado.nome, tipo_valor.tipocobranca_id, tipo_valor.valor, meses.final, debitopago.datapagamento
        order by meses.final
      ),
      totais as (
        select sum(sql.valorTipo) as totalGeral, sql.final
        from sqlComBoleto sql
        group by sql.final

        union all

        select sum(sql.valorTipo) as totalGeral, sql.final
        from sqlSemBoleto sql
        group by sql.final
      ),
      totaisPorTipo as (
        with totalPorTipoid as (
          select sum(sql.valorTipo) as valorTipo, sql.final, sql.idCobranca, sql.nomecobranca
          from sqlComBoleto sql
          group by sql.final, sql.idCobranca, sql.nomecobranca

          UNION ALL

          select sum(sql.valorTipo) as valorTipo, sql.final, sql.idCobranca, sql.nomecobranca
          from sqlSemBoleto sql
          group by sql.final, sql.idCobranca, sql.nomecobranca
        )
        select 	sum(case when sql.idCobranca = 1 then sql.valorTipo else 0 end) as valorBalanco,
        sum(case when sql.idCobranca = 2 then sql.valorTipo else 0 end) as valorHonorario,
        sum(case when sql.idCobranca not in (1,2) then sql.valorTipo else 0 end) as valorOutros,
        sql.final
        from totalPorTipoid sql
        group by sql.final
      )

      select TO_CHAR(totais.final, 'MM/YYYY') as data,
      sum(totais.totalGeral) as total,
      totais.final,
      tipo.valorBalanco,
      tipo.valorHonorario,
      tipo.valorOutros
      from totais
      left join totaisPorTipo tipo on tipo.final = totais.final
      group by totais.final, tipo.valorBalanco, tipo.valorHonorario, tipo.valorOutros
      order by totais.final

"
  end

  def self.get_primeira_parcela_honorario(empresa)
    return "
      with meses as (
        select a::date as inicial, (a + INTERVAL'1 month' - INTERVAL'1 day')::date as final
        from generate_series((date_trunc('month', current_date - interval '13 month') + interval '1 month')::date, (date_trunc('month', current_date + interval '1 month') - interval '1 day')::date,INTERVAL'1 month') a
      ),
      primeira_parcela_honorario as (
        with id_debito as (
          select distinct c.clifor_id, min(c.datacompetencia) as datacompetencia, min(c.id) as id
          from debitos c
          inner join tipocobrancavalor tc on tc.debito_id = c.id and tc.tipocobranca_id = 2

          where c.status in ('PENDENTE', 'PAGO', 'PARCIALMENTE_PAGO')
          and c.empresa_id in (#{empresa})
          group by c.clifor_id
          order by c.clifor_id
        )
        select 	debito.id, debito.datacompetencia, debito.clifor_id, coalesce(boleto.datavencimento, debito.datavencimento) as datavencimento,
        debitopago.datapagamento
        from id_debito
        inner join debitos debito on debito.id = id_debito.id and debito.clifor_id = id_debito.clifor_id
        left join boletogerado boleto on boleto.id = debito.boletogerado_id
        left join debito_debitospagos debito_debitopago on debito_debitopago.debito_id = debito.id
        left join debitospagos debitopago on debitopago.id = debito_debitopago.debitopago_id
        group by debito.id, debito.clifor_id, coalesce(boleto.datavencimento, debito.datavencimento), debitopago.datapagamento
      ),
      sqlHonorarioPaga as (
        select distinct	debito.id,
        debito.empresa_id as empresa_id,
        cliente.id as clifor_id,
        cliente.razaosocial,
        cidade.nome,
        (estado.nome || '-' || estado.sigla) as estado,
        estado.sigla,
        coalesce(boleto.datavencimento, debito.datavencimento) as datavencimento,
        debitopago.datapagamento::date,
        debito.valor,
        debito.status as status,
        debito_debitopago.valorjuros as jurosPago,
        debito_debitopago.valor as valorPago,
        meses.final
        from meses
        inner join primeira_parcela_honorario pri on pri.datapagamento between meses.inicial and meses.final
        inner join debitos debito on debito.id = pri.id
        inner join financeiro.clientefornecedorfinanceiro cliente on cliente.id = debito.clifor_id
        left join municipio cidade on cidade.id = cliente.municipio_id
        left join estado on estado.id = cidade.estado_id
        left join debito_debitospagos debito_debitopago on debito_debitopago.debito_id = debito.id
        left join debitospagos debitopago on debitopago.id = debito_debitopago.debitopago_id
        left join boletogerado boleto on boleto.id = debito.boletogerado_id
        where debito.status in ('PAGO')
        and debito.empresa_id in (#{empresa})
        group by debito.id,
        debito.empresa_id,
        cliente.id,
        cliente.razaosocial,
        cidade.nome,
        (estado.nome || '-' || estado.sigla),
        estado.sigla,
        coalesce(boleto.datavencimento, debito.datavencimento),
        debito.valor,
        debito.status,
        debitopago.datapagamento::date,
        debito_debitopago.valorjuros,
        debito_debitopago.valor,
        meses.final,
        debitopago.datapagamento
      ),
      sqlHonorarioPendente as (
        select distinct	debito.id,
        debito.empresa_id as empresa_id,
        cliente.id as clifor_id,
        cliente.razaosocial,
        cidade.nome,
        (estado.nome || '-' || estado.sigla) as estado,
        estado.sigla,
        coalesce(boleto.datavencimento, debito.datavencimento) as datavencimento,
        debito.valor,
        debito.status as status,
        meses.final
        from meses
        inner join primeira_parcela_honorario pri on pri.datavencimento <= current_date
        inner join debitos debito on debito.id = pri.id
        inner join financeiro.clientefornecedorfinanceiro cliente on cliente.id = debito.clifor_id
        left join municipio cidade on cidade.id = cliente.municipio_id
        left join estado on estado.id = cidade.estado_id
        left join boletogerado boleto on boleto.id = debito.boletogerado_id
        where debito.status in ('PENDENTE', 'PARCIALMENTE_PAGO')
        and debito.empresa_id in (#{empresa})
        and coalesce(boleto.datavencimento, debito.datavencimento) < current_date
        group by debito.id,
        debito.empresa_id,
        cliente.id,
        cliente.razaosocial,
        cidade.nome,
        (estado.nome || '-' || estado.sigla),
        estado.sigla,
        debito.datavencimento,
        debito.valor,
        debito.status,
        boleto.datavencimento,
        meses.final
      ),
      totalPagoHonorario as (
        select sum(sql.valorpago) as totalGeral, sql.final, count( distinct sql.clifor_id) as quantidade
        from sqlHonorarioPaga sql
        group by sql.final
        order by sql.final
      ),
      totalPendenteHonorario as (
        select sum(sql.valor) as totalGeral, sql.final, count( distinct sql.clifor_id) as quantidade
        from sqlHonorarioPendente sql
        group by sql.final
        order by sql.final
      )
      select  TO_CHAR(meses.final, 'MM/YYYY') as data,
      coalesce(totalPagoHonorario.totalGeral, 0) as valorHonorario,
      coalesce(totalPagoHonorario.quantidade, 0) as quantidadeHonorario,
      case when coalesce(totalPagoHonorario.quantidade,0) = 0 then 0 else ROUND((totalPagoHonorario.totalGeral / coalesce(totalPagoHonorario.quantidade,1)),2) end as mediaHonorario,
      coalesce(totalPendenteHonorario.totalGeral,0) as valorPendendeHonorario,
      coalesce(totalPendenteHonorario.quantidade,0) as quantidadePendenteHonorario,
      ROUND((totalPendenteHonorario.totalGeral / coalesce(totalPendenteHonorario.quantidade,1)),2) as mediaHonorarioPend
      from meses
      left join totalPagoHonorario on totalPagoHonorario.final = meses.final
      left join totalPendenteHonorario on totalPendenteHonorario.final = meses.final
    "
  end

  def self.get_primeira_parcela_honorario_anterior(empresa)
    return "with meses as (
        select (date_trunc('month',current_date) - interval '1 month')::date as inicial, (current_date - interval '1 month')::date as final
      ),
      primeira_parcela_honorario as (
        with id_debito as (
          select distinct c.clifor_id, min(c.datacompetencia) as datacompetencia, min(c.id) as id
          from debitos c
          inner join tipocobrancavalor tc on tc.debito_id = c.id and tc.tipocobranca_id = 2

          where c.status in ('PENDENTE', 'PAGO', 'PARCIALMENTE_PAGO')
          and c.empresa_id in (#{empresa})
          group by c.clifor_id
          order by c.clifor_id
        )
        select 	debito.id, debito.datacompetencia, debito.clifor_id, coalesce(boleto.datavencimento, debito.datavencimento) as datavencimento,
        debitopago.datapagamento
        from id_debito
        inner join debitos debito on debito.id = id_debito.id and debito.clifor_id = id_debito.clifor_id
        left join boletogerado boleto on boleto.id = debito.boletogerado_id
        left join debito_debitospagos debito_debitopago on debito_debitopago.debito_id = debito.id
        left join debitospagos debitopago on debitopago.id = debito_debitopago.debitopago_id
        group by debito.id, debito.clifor_id, coalesce(boleto.datavencimento, debito.datavencimento), debitopago.datapagamento
      ),
      sqlHonorarioPaga as (
        select distinct	debito.id,
        debito.empresa_id as empresa_id,
        cliente.id as clifor_id,
        cliente.razaosocial,
        cidade.nome,
        (estado.nome || '-' || estado.sigla) as estado,
        estado.sigla,
        coalesce(boleto.datavencimento, debito.datavencimento) as datavencimento,
        debitopago.datapagamento::date,
        debito.valor,
        debito.status as status,
        debito_debitopago.valorjuros as jurosPago,
        debito_debitopago.valor as valorPago,
        meses.final
        from meses
        inner join primeira_parcela_honorario pri on pri.datapagamento between meses.inicial and meses.final
        inner join debitos debito on debito.id = pri.id
        inner join financeiro.clientefornecedorfinanceiro cliente on cliente.id = debito.clifor_id
        left join municipio cidade on cidade.id = cliente.municipio_id
        left join estado on estado.id = cidade.estado_id
        left join debito_debitospagos debito_debitopago on debito_debitopago.debito_id = debito.id
        left join debitospagos debitopago on debitopago.id = debito_debitopago.debitopago_id
        left join boletogerado boleto on boleto.id = debito.boletogerado_id
        where debito.status in ('PAGO')
        and debito.empresa_id in (#{empresa})
        group by debito.id,
        debito.empresa_id,
        cliente.id,
        cliente.razaosocial,
        cidade.nome,
        (estado.nome || '-' || estado.sigla),
        estado.sigla,
        coalesce(boleto.datavencimento, debito.datavencimento),
        debito.valor,
        debito.status,
        debitopago.datapagamento::date,
        debito_debitopago.valorjuros,
        debito_debitopago.valor,
        meses.final,
        debitopago.datapagamento
      ),
      sqlHonorarioPendente as (
        select distinct	debito.id,
        debito.empresa_id as empresa_id,
        cliente.id as clifor_id,
        cliente.razaosocial,
        cidade.nome,
        (estado.nome || '-' || estado.sigla) as estado,
        estado.sigla,
        coalesce(boleto.datavencimento, debito.datavencimento) as datavencimento,
        debito.valor,
        debito.status as status,
        meses.final
        from meses
        inner join primeira_parcela_honorario pri on pri.datavencimento <= current_date
        inner join debitos debito on debito.id = pri.id
        inner join financeiro.clientefornecedorfinanceiro cliente on cliente.id = debito.clifor_id
        left join municipio cidade on cidade.id = cliente.municipio_id
        left join estado on estado.id = cidade.estado_id
        left join boletogerado boleto on boleto.id = debito.boletogerado_id
        where debito.status in ('PENDENTE', 'PARCIALMENTE_PAGO')
        and debito.empresa_id in (#{empresa})
        and coalesce(boleto.datavencimento, debito.datavencimento) < current_date
        group by debito.id,
        debito.empresa_id,
        cliente.id,
        cliente.razaosocial,
        cidade.nome,
        (estado.nome || '-' || estado.sigla),
        estado.sigla,
        debito.datavencimento,
        debito.valor,
        debito.status,
        boleto.datavencimento,
        meses.final
      ),
      totalPagoHonorario as (
        select sum(sql.valorpago) as totalGeral, sql.final, count( distinct sql.clifor_id) as quantidade
        from sqlHonorarioPaga sql
        group by sql.final
        order by sql.final
      ),
      totalPendenteHonorario as (
        select sum(sql.valor) as totalGeral, sql.final, count( distinct sql.clifor_id) as quantidade
        from sqlHonorarioPendente sql
        group by sql.final
        order by sql.final
      )
      select  TO_CHAR(meses.final, 'MM/YYYY') as data,
      coalesce(totalPagoHonorario.totalGeral, 0) as valorHonorario,
      coalesce(totalPagoHonorario.quantidade, 0) as quantidadeHonorario,
      case when coalesce(totalPagoHonorario.quantidade,0) = 0 then 0 else ROUND((totalPagoHonorario.totalGeral / coalesce(totalPagoHonorario.quantidade,1)),2) end as mediaHonorario,
      coalesce(totalPendenteHonorario.totalGeral,0) as valorPendendeHonorario,
      coalesce(totalPendenteHonorario.quantidade,0) as quantidadePendenteHonorario,
      ROUND((totalPendenteHonorario.totalGeral / coalesce(totalPendenteHonorario.quantidade,1)),2) as mediaHonorarioPend
      from meses
      left join totalPagoHonorario on totalPagoHonorario.final = meses.final
      left join totalPendenteHonorario on totalPendenteHonorario.final = meses.final"
  end

  def self.get_inadimplencia_por_tipo(empresa, data)
    return "
    with meses as (
        select a::date as inicial, (a + INTERVAL'1 month' - INTERVAL'1 day')::date as final
        from generate_series((date_trunc('month', current_date - interval '12 month') + interval '1 month')::date, (date_trunc('month', current_date + interval '1 month') - interval '1 day')::date,INTERVAL'1 month') a
      ),
      sqlSemBoleto as(
        select  debito.id as debito_id,
        debito.saldo saldoDebito,
        debito.valor valorDebito,
        debito.valorjurosboleto,
        debito.status as status_boleto,
        debito.datavencimento,
        tipo.id as idCobranca,
        tipo.nome as nomecobranca,
        cliente.id as idCliente,
        cliente.razaosocial as razaosocialcliente,
        cidade.nome || '-' || estado.sigla as cidade,
        estado.nome || '-' || estado.sigla as estado,
        estado.sigla,
        tipo_valor.tipocobranca_id,
        tipo_valor.valor as valorTipo,
        sum(coalesce(debito_debitopago.valor,0)) as valorpagodebito,
        sum(coalesce(debito_debitopago.valordesconto,0)) as valordescontodebito,
        sum(coalesce(debito_debitopago.valorjuros,0)) as valorjurosdebito,
        debitopago.datapagamento,
        meses.final
        from meses
        inner join debitos debito on debito.empresa_id in (#{empresa}) and debito.datavencimento < (current_date - interval '1 day')
        and debito.boletogerado_id is null and debito.status <> 'EXCLUIDO' and debito.status <> 'PARCELADO'
        left JOIN debito_debitospagos debito_debitopago ON debito_debitopago.debito_id = debito.id
        left JOIN debitospagos debitopago ON debitopago.id = debito_debitopago.debitopago_id
        inner join tipocobrancavalor tipo_valor on tipo_valor.debito_id = debito.id
        inner join financeiro.clientefornecedorfinanceiro cliente ON cliente.id = debito.clifor_id and cliente.parceiro is false
        LEFT JOIN tipocobranca tipo ON tipo.id = tipo_valor.tipocobranca_id
        left join municipio cidade on cidade.id = cliente.municipio_id
        left join estado estado on estado.id = cidade.estado_id
        where meses.final between debito.datavencimento and (case when debitopago.id is null then meses.final else debitopago.datapagamento end)
        and (debitopago.id is null or extract(month from debito.datavencimento) != extract(month from debitopago.datapagamento))
        and (debitopago.id is null or meses.final != debitopago.datapagamento)
        and (debitopago.id is not null or debito.datavencimento < current_date)
        group by debito.id, debito.saldo, debito.status, debito.valor, debito.datavencimento, debito.valorjurosboleto, tipo.id, tipo.nome, cliente.id,
        cliente.razaosocial, estado.sigla, cidade.nome, estado.nome, tipo_valor.tipocobranca_id, tipo_valor.valor, meses.final, debitopago.datapagamento
        order by meses.final
      ),
      sqlComBoleto as(
        select boleto.id as boleto_id,
        boleto.empresa_id,
        boleto.datavencimento,
        boleto.valorboleto,
        debito.id as debito_id,
        debito.saldo saldoDebito,
        debito.valor valorDebito,
        debito.valorjurosboleto,
        debito.status as status_boleto,
        tipo.id as idCobranca,
        tipo.nome as nomecobranca,
        cliente.id as idCliente,
        cliente.razaosocial as razaosocialcliente,
        cidade.nome || '-' || estado.sigla as cidade,
        estado.nome || '-' || estado.sigla as estado,
        estado.sigla,
        tipo_valor.tipocobranca_id,
        tipo_valor.valor as valorTipo,
        sum(coalesce(debito_debitopago.valor,0)) as valorpagodebito,
        sum(coalesce(debito_debitopago.valordesconto,0)) as valordescontodebito,
        sum(coalesce(debito_debitopago.valorjuros,0)) as valorjurosdebito,
        debitopago.datapagamento,
        meses.final
        from  meses
        inner join boletogerado boleto on meses.final between boleto.datavencimento and (case when boleto.status = 'PAGO' then boleto.datapagamento else meses.final end)
        and boleto.status <> 'EXCLUIDO' and  boleto.empresa_id in (#{empresa})
        inner join debitos debito on debito.boletogerado_id = boleto.id and boleto.clifor_id = debito.clifor_id and boleto.empresa_id = debito.empresa_id  and boleto.status = debito.status
        left JOIN debito_debitospagos debito_debitopago ON debito_debitopago.debito_id = debito.id
        left JOIN debitospagos debitopago ON debitopago.id = debito_debitopago.debitopago_id
        inner join tipocobrancavalor tipo_valor on tipo_valor.debito_id = debito.id
        inner join financeiro.clientefornecedorfinanceiro cliente ON cliente.id = debito.clifor_id
        LEFT JOIN tipocobranca tipo ON tipo.id = tipo_valor.tipocobranca_id
        left join municipio cidade on cidade.id = cliente.municipio_id
        left join estado estado on estado.id = cidade.estado_id
        where meses.final between boleto.datavencimento and (case when debitopago.id is null then meses.final else debitopago.datapagamento end)
        and (debitopago.id is null or extract(month from boleto.datavencimento) != extract(month from debitopago.datapagamento))
        and (debitopago.id is null or meses.final != debitopago.datapagamento)
        and (debitopago.id is not null or boleto.datavencimento < current_date)
        group by boleto.id, boleto.empresa_id, boleto.datavencimento,boleto.valorboleto, debito.id, debito.saldo, debito.status, debito.valor, debito.valorjurosboleto, tipo.id, tipo.nome, cliente.id,
        cliente.razaosocial, estado.sigla, cidade.nome, estado.nome, tipo_valor.tipocobranca_id, tipo_valor.valor, meses.final, debitopago.datapagamento
        order by meses.final
      ),
      totais as (
        select sum(sql.valorTipo) as totalGeral, sql.final, sql.idCobranca, sql.nomecobranca
        from sqlComBoleto sql
        group by sql.final, sql.idCobranca, sql.nomecobranca

        union all

        select sum(sql.valorTipo) as totalGeral, sql.final, sql.idCobranca, sql.nomecobranca
        from sqlSemBoleto sql
        group by sql.final, sql.idCobranca, sql.nomecobranca
      )
      select *
      from totais
      where final = '#{data}'
      order by totalgeral desc

    "
  end

  def self.table_primeira_parcela_honorario(tipo, empresa, data_inicio, data_fim)
    return "
with parametros as (
       select #{tipo}::integer as tipo
      ),
      primeira_parcela_honorario as (
              with id_debito as (
              select distinct c.clifor_id, min(c.datacompetencia) as datacompetencia, min(c.id) as id
              from debitos c
              inner join tipocobrancavalor tc on tc.debito_id = c.id and tc.tipocobranca_id = 2

              where c.status in ('PENDENTE', 'PAGO', 'PARCIALMENTE_PAGO')
              and c.empresa_id in (#{empresa})
              group by c.clifor_id
              order by c.clifor_id
              )
              select 	debito.id, debito.datacompetencia, debito.clifor_id, coalesce(boleto.datavencimento, debito.datavencimento) as datavencimento,
          debitopago.datapagamento
              from id_debito
              inner join debitos debito on debito.id = id_debito.id and debito.clifor_id = id_debito.clifor_id
              left join boletogerado boleto on boleto.id = debito.boletogerado_id
              left join debito_debitospagos debito_debitopago on debito_debitopago.debito_id = debito.id
              left join debitospagos debitopago on debitopago.id = debito_debitopago.debitopago_id
              group by debito.id, debito.clifor_id, coalesce(boleto.datavencimento, debito.datavencimento), debitopago.datapagamento
      ),
      sql as (
        select debito.id,
          debito.empresa_id as empresa_id,
          cliente.id as clifor_id,
          cliente.razaosocial,
          cliente.cpfcnpj,
          (cidade.nome || '-' || estado.sigla) as cidade,
          (estado.nome || '-' || estado.sigla) as estado,
          estado.sigla,
          coalesce(boleto.datavencimento, debito.datavencimento) as datavencimento,
          debitopago.datapagamento::date,
          debito.valor,
          debito.status as status,
          debito_debitopago.valorjuros as jurosPago,
          debito_debitopago.valor as valorPago,
          null::integer as qtd_dias,
          TO_CHAR(ligacao.data, 'DD/MM/YYYY HH24:MI') as ultima_ligacao,
          ligacao.historico,
          usuario_ligacao.nome as usuario_ligacao,
          retorno.dataretorno
        from primeira_parcela_honorario pri
        inner join debitos debito on debito.id = pri.id
        inner join parametros on true
        inner join financeiro.clientefornecedorfinanceiro cliente on cliente.id = debito.clifor_id
        left join municipio cidade on cidade.id = cliente.municipio_id
        left join estado on estado.id = cidade.estado_id
        left join debito_debitospagos debito_debitopago on debito_debitopago.debito_id = debito.id
        left join debitospagos debitopago on debitopago.id = debito_debitopago.debitopago_id
        left join boletogerado boleto on boleto.id = debito.boletogerado_id
        left join financeiro.cobranca cobranca on cobranca.id = (select max(c.id) from financeiro.cobranca c where  c.cliente_id = cliente.id and c.empresa_id = debito.empresa_id and c.finalizada is false)
        left join financeiro.ligacao ligacao on ligacao.id = (select l.id from financeiro.ligacao l where  l.cobranca_id = cobranca.id order by data desc limit 1)
        left join financeiro.retornocobranca retorno on retorno.id = ligacao.retornocobranca_id
        left join usuario usuario_ligacao on usuario_ligacao.id = ligacao.usuario_id
        where debito.status in ('PAGO')
        and debito.empresa_id in  (#{empresa})
        and pri.datapagamento between '#{data_inicio}'::date and '#{data_fim}'::date
        and parametros.tipo = 1
        group by debito.id,
           debito.empresa_id,
           cliente.id,
           cliente.razaosocial,
           cidade.nome,
           (estado.nome || '-' || estado.sigla),
           estado.sigla,
           coalesce(boleto.datavencimento, debito.datavencimento),
           debito.valor,
           debito.status,
           debitopago.datapagamento::date,
           debito_debitopago.valorjuros,
           debito_debitopago.valor,
           debitopago.datapagamento,
           ligacao.data,
           ligacao.historico,
           usuario_ligacao.nome,
           retorno.dataretorno

      union all

        select debito.id,
          debito.empresa_id as empresa_id,
          cliente.id as clifor_id,
          cliente.razaosocial,
          cliente.cpfcnpj,
          (cidade.nome || '-' || estado.sigla) as cidade,
          (estado.nome || '-' || estado.sigla) as estado,
          estado.sigla,
	        coalesce(boleto.datavencimento, debito.datavencimento) as datavencimento,
	        null::date as datapagamento,
          debito.valor,
          debito.status as status,
          null::numeric as jurosPago,
          null::numeric as valorPago,
          current_date - coalesce(boleto.datavencimento, debito.datavencimento) as qtd_dias,
          TO_CHAR(ligacao.data, 'DD/MM/YYYY HH24:MI') as ultima_ligacao,
          ligacao.historico,
          usuario_ligacao.nome as usuario_ligacao,
          retorno.dataretorno
      from primeira_parcela_honorario pri
      inner join debitos debito on debito.id = pri.id
      inner join parametros on true
      inner join financeiro.clientefornecedorfinanceiro cliente on cliente.id = debito.clifor_id
      left join municipio cidade on cidade.id = cliente.municipio_id
      left join estado on estado.id = cidade.estado_id
      left join boletogerado boleto on boleto.id = debito.boletogerado_id
      left join financeiro.cobranca cobranca on cobranca.id = (select max(c.id) from financeiro.cobranca c where  c.cliente_id = cliente.id and c.empresa_id = debito.empresa_id and c.finalizada is false)
      left join financeiro.ligacao ligacao on ligacao.id = (select l.id from financeiro.ligacao l where  l.cobranca_id = cobranca.id order by data desc limit 1)
      left join financeiro.retornocobranca retorno on retorno.id = ligacao.retornocobranca_id
      left join usuario usuario_ligacao on usuario_ligacao.id = ligacao.usuario_id
      where debito.status in ('PENDENTE', 'PARCIALMENTE_PAGO')
      and debito.empresa_id in (#{empresa})
      and pri.datavencimento < current_date
      and parametros.tipo = 2
      group by debito.id,
         debito.empresa_id,
         cliente.id,
         cliente.razaosocial,
         cidade.nome,
         (estado.nome || '-' || estado.sigla),
         estado.sigla,
         debito.datavencimento,
         debito.valor,
         debito.status,
         boleto.datavencimento,
         ligacao.data,
         ligacao.historico,
         usuario_ligacao.nome,
         retorno.dataretorno
      )
      select *
      from sql
      order by #{tipo == '1' ? 'sql.datapagamento desc' : 'sql.datavencimento desc'}

      "
  end
end
