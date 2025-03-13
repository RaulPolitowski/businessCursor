module DashboardsResultadosHelper

  def self.get_efetivacoes_desativacoes(empresa, estado, cnpjs)
    return "
          with parametros as (
            select 	16::int as tipo_id,
                    #{ estado.present? ? estado : 'null'}::int as estado
          ),
           meses as (
            select a::date as inicial, (a + INTERVAL'1 month' - INTERVAL'1 day')::date as final
            from generate_series((date_trunc('month', current_date - interval '14 month') + interval '1 month')::date, (date_trunc('month', current_date + interval '1 month') - interval '1 day')::date,INTERVAL'1 month') a
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
            inner join  honorariomensal honorario on honorario.datavencimento between meses.inicial and meses.final
            inner join parametros on true
            inner join financeiro.clientefornecedorfinanceiro cliente on cliente.id = honorario.clifor_id
            inner join municipio on municipio.id = cliente.municipio_id
            inner join estado on municipio.estado_id = estado.id
            inner join tipocobranca tipo on tipo.id = honorario.tipo_id
            inner join empresa emp on emp.id = honorario.empresa_id
            left join honorariomensal hono on hono.clifor_id = honorario.clifor_id and hono.empresa_id = honorario.empresa_id and hono.tipo_id = honorario.tipo_id and hono.id <> honorario.id and hono.ativo is false
            where honorario.empresa_id in (#{empresa})
              and (parametros.estado is null or estado.id = parametros.estado)
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
            inner join honorariomensal honorario on honorario.datainativacao between meses.inicial and meses.final
            inner join financeiro.clientefornecedorfinanceiro cliente on cliente.id = honorario.clifor_id
            inner join municipio on municipio.id = cliente.municipio_id
            inner join estado on municipio.estado_id = estado.id
            inner join tipocobranca tipo on tipo.id = honorario.tipo_id
            inner join empresa emp on emp.id = honorario.empresa_id
            --left join honorariomensal hono on hono.clifor_id = honorario.clifor_id and hono.empresa_id = honorario.empresa_id and hono.tipo_id = honorario.tipo_id and hono.id <> honorario.id
            where  honorario.empresa_id in (#{empresa})
              and (parametros.tipo_id is null or honorario.tipo_id = parametros.tipo_id)
              and (parametros.estado is null or estado.id = parametros.estado)
              --and hono.id is null
              and honorario.ativo is false
              and cpfcnpj::bigint NOT IN (#{cnpjs})
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
            inner join honorariomensal honorario on honorario.datavencimento between meses.inicial and meses.final
            inner join parametros on true
            inner join financeiro.clientefornecedorfinanceiro cliente on cliente.id = honorario.clifor_id
            inner join municipio on municipio.id = cliente.municipio_id
            inner join estado on municipio.estado_id = estado.id
            inner join tipocobranca tipo on tipo.id = honorario.tipo_id
            inner join empresa emp on emp.id = honorario.empresa_id
            --left join honorariomensal hono on hono.clifor_id = honorario.clifor_id and hono.empresa_id = honorario.empresa_id and hono.tipo_id = honorario.tipo_id and hono.id <> honorario.id
            where honorario.empresa_id in (#{empresa})
              and (parametros.tipo_id is null or honorario.tipo_id = parametros.tipo_id)
              and (parametros.estado is null or estado.id = parametros.estado)
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

  def self.get_efetivacoes_desativacoesReal(empresa, estado, cnpjs)
    return "
      with parametros as (
        select  #{ estado.present? ? estado : 'null'}::int as estado,
        16::int as tipo_id
      ),
      meses as (
        select a::date as inicial, (a + INTERVAL'1 month' - INTERVAL'1 day')::date as final
        from generate_series((date_trunc('month', current_date - interval '14 month') + interval '1 month')::date, (date_trunc('month', current_date + interval '1 month') - interval '1 day')::date,INTERVAL'1 month') a
      ),
      primeira_parcela_mensalidade as (
            with id_debito as (
              select distinct c.clifor_id, min(c.datacompetencia) as datacompetencia, min(c.id) as id
              from debitos c
              inner join tipocobrancavalor tc on tc.debito_id = c.id and tc.tipocobranca_id = 16

              where c.status in ('PENDENTE', 'PAGO', 'PARCIALMENTE_PAGO')
              and c.empresa_id in (#{empresa})
              group by c.clifor_id
              order by c.clifor_id
            )
            select  debito.id,
                    debito.datacompetencia,
                    debito.clifor_id,
                    coalesce(boleto.datavencimento, debito.datavencimento) as datavencimento,
                    debitopago.datapagamento::date as datapagamento,
		  			        debito.status
            from id_debito
            inner join debitos debito on debito.id = id_debito.id and debito.clifor_id = id_debito.clifor_id
            left join boletogerado boleto on boleto.id = debito.boletogerado_id
            left join debito_debitospagos debito_debitopago on debito_debitopago.debito_id = debito.id
            left join debitospagos debitopago on debitopago.id = debito_debitopago.debitopago_id
            where debito.id <> 499521
            group by debito.id, debito.clifor_id, coalesce(boleto.datavencimento, debito.datavencimento), debitopago.datapagamento
      ),
      sqlMensalidadePaga as (
        select distinct debito.id,
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
        inner join primeira_parcela_mensalidade pri on pri.datapagamento between meses.inicial and meses.final
        inner join debitos debito on debito.id = pri.id
        inner join parametros on true
        inner join financeiro.clientefornecedorfinanceiro cliente on cliente.id = debito.clifor_id
        left join municipio cidade on cidade.id = cliente.municipio_id
        left join estado on estado.id = cidade.estado_id
        left join debito_debitospagos debito_debitopago on debito_debitopago.debito_id = debito.id
        left join debitospagos debitopago on debitopago.id = debito_debitopago.debitopago_id
        left join boletogerado boleto on boleto.id = debito.boletogerado_id
        where debito.status in ('PAGO')
        and debito.empresa_id in (#{empresa})
        and (parametros.estado is null or parametros.estado = estado.id)
        group by debito.id, debito.empresa_id, cliente.id, cliente.razaosocial,
          cidade.nome,
          (estado.nome || '-' || estado.sigla),
          estado.sigla,
          coalesce(boleto.datavencimento, debito.datavencimento),
          debito.valor,
          debito.status,
          debito_debitopago.valorjuros,
          debito_debitopago.valor,
          meses.final,
          debitopago.datapagamento
      ),
      totalPagoMensalidade as (
          select sql.final, count( distinct sql.clifor_id) as qtd_men, sum(sql.valorpago) as totalMensalidades
          from sqlMensalidadePaga sql
          group by sql.final
          order by sql.final
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
          emp.id as empresa_id
          from meses
          inner join parametros on true
          inner join honorariomensal honorario on honorario.datainativacao between meses.inicial and meses.final
          inner join financeiro.clientefornecedorfinanceiro cliente on cliente.id = honorario.clifor_id
          inner join municipio on municipio.id = cliente.municipio_id
          inner join estado on municipio.estado_id = estado.id
          inner join tipocobranca tipo on tipo.id = honorario.tipo_id
          inner join empresa emp on emp.id = honorario.empresa_id
          --left join honorariomensal hono on hono.clifor_id = honorario.clifor_id and hono.empresa_id = honorario.empresa_id and hono.tipo_id = honorario.tipo_id and hono.id <> honorario.id
          where  honorario.empresa_id in (#{empresa})
            and (parametros.tipo_id is null or honorario.tipo_id = parametros.tipo_id)
            and (parametros.estado is null or estado.id = parametros.estado)
            --and hono.id is null
            and honorario.ativo is false
        ),
        debitosPagos as (select distinct sql.cliente_id,
                        final, datainativacao, sql.razaosocial, sql.sigla, honorario_id, sql.valor,
                        ativo, sql.empresa_id, nome, pri.status
          from sqlInativos sql
		      inner join primeira_parcela_mensalidade pri on pri.clifor_id = sql.cliente_id
          where pri.status = 'PAGO'
          	  and cpfcnpj::bigint NOT IN (#{cnpjs})
          order by final
        ),
      totaisDesistencia as (
        select final, count(distinct cliente_id) as  qtd_desistencia, sum(valor) as totalDes
        from debitosPagos
        group by final
        order by final
      )
      select TO_CHAR(meses.final, 'MM/YYYY') as data,
            coalesce(totalMensalidades,0) as valorefetivacoes,
            coalesce(qtd_men,0) as quantidadeefetivacoes,
            case when coalesce(qtd_men,0) = 0 then 0 else ROUND((totalMensalidades/coalesce(qtd_men,1)),2) end as mediaefetivacoes,
            coalesce(totalDes,0) as valorinativos,
            coalesce(qtd_desistencia,0) as quantidadeinativos,
            case when coalesce(qtd_desistencia,0) = 0 then 0 else ROUND((totalDes/coalesce(qtd_desistencia,1)),2) end as mediainativos,
            (coalesce(qtd_men,0)-coalesce(qtd_desistencia,0)) as saldo_quantidade,
            coalesce(totalMensalidades, 0)-coalesce(totalDes,0) as saldo_total,
            case when coalesce(qtd_men,0)-coalesce(qtd_desistencia, 0) = 0 then 0 else ROUND((coalesce(totalMensalidades,0)-coalesce(totalDes,0))/coalesce((coalesce(qtd_men,0)-coalesce(qtd_desistencia)),1),2) end as saldo_media
	    from meses
      left join totalPagoMensalidade tm on tm.final = meses.final
      left join totaisDesistencia td on td.final = meses.final

      order by tm.final
    "
  end

  def self.get_efetivacoes_desativacoes_2meses(empresa, estado, qtd_mes, cnpjs)
    return "
      with parametros as (
        select  #{ estado.present? ? estado : 'null'}::int as estado,
        16::int as tipo_id
      ),
      meses as (
        select a::date as inicial, (a + INTERVAL'1 month' - INTERVAL'1 day')::date as final
        from generate_series((date_trunc('month', current_date - interval '14 month') + interval '1 month')::date, (date_trunc('month', current_date + interval '1 month') - interval '1 day')::date,INTERVAL'1 month') a
      ),
      todos_debitos as (
        select distinct c.clifor_id, c.datacompetencia as datacompetencia, c.id as id,
            row_number() over (partition by c.clifor_id order by c.datacompetencia) as rownum
        from debitos c
        inner join tipocobrancavalor tc on tc.debito_id = c.id and tc.tipocobranca_id = 16
        where c.status in ('PENDENTE', 'PAGO', 'PARCIALMENTE_PAGO')
              and c.empresa_id in (#{empresa})
        order by c.clifor_id, c.datacompetencia
      ),
      qtd_debitos as (
        select clifor_id, count(clifor_id) as qtd, max(id) as id_debito
        from todos_debitos
        group by clifor_id
        having count(clifor_id) = #{qtd_mes}
      ),
      MENSALIDADES AS (
        select  debito.id, debito.datacompetencia, debito.clifor_id,
                          coalesce(boleto.datavencimento, debito.datavencimento) as datavencimento,
                          debitopago.datapagamento::date as datapagamento, debito.status
        from todos_debitos
        inner join debitos debito on debito.id = todos_debitos.id and debito.clifor_id = todos_debitos.clifor_id
        left join boletogerado boleto on boleto.id = debito.boletogerado_id
        left join debito_debitospagos debito_debitopago on debito_debitopago.debito_id = debito.id
        left join debitospagos debitopago on debitopago.id = debito_debitopago.debitopago_id
        where debito.id <> 499521 and rownum = #{qtd_mes}
        group by debito.id, debito.clifor_id, coalesce(boleto.datavencimento, debito.datavencimento), debitopago.datapagamento
      ),
      INFO_DEBITOS_2PAG AS (
        select  debito.id, debito.datacompetencia, debito.clifor_id,
                          coalesce(boleto.datavencimento, debito.datavencimento) as datavencimento,
                          debitopago.datapagamento::date as datapagamento, debito.status
                  from qtd_debitos
                  inner join debitos debito on debito.id = qtd_debitos.id_debito and debito.clifor_id = qtd_debitos.clifor_id
                  left join boletogerado boleto on boleto.id = debito.boletogerado_id
                  left join debito_debitospagos debito_debitopago on debito_debitopago.debito_id = debito.id
                  left join debitospagos debitopago on debitopago.id = debito_debitopago.debitopago_id
                  where debito.id <> 499521
                  group by debito.id, debito.clifor_id, coalesce(boleto.datavencimento, debito.datavencimento), debitopago.datapagamento
      ),
      MensalidadePaga as (
        select distinct debito.id, debito.empresa_id as empresa_id,
          cliente.id as clifor_id, cliente.razaosocial,
          cidade.nome, (estado.nome || '-' || estado.sigla) as estado, estado.sigla,
          coalesce(boleto.datavencimento, debito.datavencimento) as datavencimento,
          debitopago.datapagamento::date, debito.valor, debito.status as status,
          debito_debitopago.valorjuros as jurosPago, debito_debitopago.valor as valorPago,
          meses.final
        from meses
        inner join MENSALIDADES pri on pri.datapagamento between meses.inicial and meses.final
        inner join debitos debito on debito.id = pri.id
        inner join parametros on true
        inner join financeiro.clientefornecedorfinanceiro cliente on cliente.id = debito.clifor_id
        left join municipio cidade on cidade.id = cliente.municipio_id
        left join estado on estado.id = cidade.estado_id
        left join debito_debitospagos debito_debitopago on debito_debitopago.debito_id = debito.id
        left join debitospagos debitopago on debitopago.id = debito_debitopago.debitopago_id
        left join boletogerado boleto on boleto.id = debito.boletogerado_id
        where debito.status in ('PAGO')
        and debito.empresa_id in (#{empresa})
        and (parametros.estado is null or parametros.estado = estado.id)
        group by debito.id, debito.empresa_id, cliente.id, cliente.razaosocial,
          cidade.nome,
          (estado.nome || '-' || estado.sigla),
          estado.sigla,
          coalesce(boleto.datavencimento, debito.datavencimento),
          debito.valor,
          debito.status,
          debito_debitopago.valorjuros,
          debito_debitopago.valor,
          meses.final,
          debitopago.datapagamento
      ),
      totalPagoMensalidade as (
        select sql.final, count( distinct sql.clifor_id) as qtd_men, sum(sql.valorpago) as totalMensalidades
        from MensalidadePaga sql
        group by sql.final
        order by sql.final
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
              emp.id as empresa_id
        from meses
        inner join parametros on true
        inner join honorariomensal honorario on honorario.datainativacao between meses.inicial and meses.final
        inner join financeiro.clientefornecedorfinanceiro cliente on cliente.id = honorario.clifor_id
        inner join municipio on municipio.id = cliente.municipio_id
        inner join estado on municipio.estado_id = estado.id      
        inner join tipocobranca tipo on tipo.id = honorario.tipo_id
        inner join empresa emp on emp.id = honorario.empresa_id
        where  honorario.empresa_id in (#{empresa})
              and (parametros.tipo_id is null or honorario.tipo_id = parametros.tipo_id)
              and (parametros.estado is null or estado.id = parametros.estado)
              and honorario.ativo is false
              and cpfcnpj::bigint NOT IN (#{cnpjs})
      ),
      debitosPagos as (
        select distinct sql.cliente_id,
                final, datainativacao, sql.razaosocial, sql.sigla, honorario_id, sql.valor,
                ativo, sql.empresa_id, nome, pri.status
        from sqlInativos sql
        inner join INFO_DEBITOS_2PAG pri on pri.clifor_id = sql.cliente_id
        where pri.status = 'PAGO'
        order by final
      ),
      totaisDesistencia as (
        select final, count(distinct cliente_id) as  qtd_desistencia, sum(valor) as totalDes
        from debitosPagos
        group by final
        order by final
      )
      select TO_CHAR(meses.final, 'MM/YYYY') as data,
              coalesce(totalMensalidades,0) as valorefetivacoes,
              coalesce(qtd_men,0) as quantidadeefetivacoes,
              case when coalesce(qtd_men,0) = 0 then 0 else ROUND((totalMensalidades/coalesce(qtd_men,1)),2) end as mediaefetivacoes,
              coalesce(totalDes,0) as valorinativos,
              coalesce(qtd_desistencia,0) as quantidadeinativos,
              case when coalesce(qtd_desistencia,0) = 0 then 0 else ROUND((totalDes/coalesce(qtd_desistencia,1)),2) end as mediainativos,
              (coalesce(qtd_men,0)-coalesce(qtd_desistencia,0)) as saldo_quantidade,
              coalesce(totalMensalidades, 0)-coalesce(totalDes,0) as saldo_total,
              case when coalesce(qtd_men,0)-coalesce(qtd_desistencia, 0) = 0 then 0 else ROUND((coalesce(totalMensalidades,0)-coalesce(totalDes,0))/coalesce((coalesce(qtd_men,0)-coalesce(qtd_desistencia)),1),2) end as saldo_media
      from meses
      left join totalPagoMensalidade tm on tm.final = meses.final
      left join totaisDesistencia td on td.final = meses.final  
      order by meses.final
    "
  end

  def self.get_cliente_12_meses(empresa, estado)
    return "
    WITH meses AS (
      SELECT 
          (a + INTERVAL '1 month' - INTERVAL '1 day')::DATE AS final,
          #{ estado.present? ? estado : 'null'}::int AS estado
      FROM generate_series(
          (DATE_TRUNC('month', CURRENT_DATE - INTERVAL '14 month') + INTERVAL '1 month')::DATE, 
          (DATE_TRUNC('month', CURRENT_DATE + INTERVAL '1 month') - INTERVAL '1 day')::DATE,
          INTERVAL '1 month'
      ) a
    ),
    emp_bloqueada AS (
        SELECT
            COUNT(hon.id) AS qtd, 
            COALESCE(SUM(hon.valor), 0) AS valor,  
            ROUND(SUM(hon.valor)/COALESCE(COUNT(hon.id), 2), 2) AS media, 
            CURRENT_DATE AS final,
            'BLOQUEADO_ATUALMENTE'::VARCHAR AS tipo,
            ARRAY_AGG(hon.id) AS ids
        FROM honorariomensal hon
        INNER JOIN financeiro.empresabloqueada emp ON emp.contrato_id = hon.contrato_id
        WHERE hon.ativo IS true
        AND emp.databloqueio::DATE BETWEEN (CURRENT_DATE - INTERVAL '7 day') AND CURRENT_DATE
    ),
    sql AS (
        SELECT 
            COUNT(honorario.id) AS qtd, 
            COALESCE(SUM(honorario.valor), 0) AS valor,  
            ROUND(SUM(honorario.valor)/COALESCE(COUNT(honorario.id), 2), 2) AS media, 
            meses.final,
            controle.tipo
        FROM meses
        LEFT JOIN financeiro.controle_bloqueio_business controle ON controle.data_controle = meses.final
        LEFT JOIN financeiro.controle_bloqueio_business_clientes cliente ON controle.id = cliente.controle_bloqueio_business_id
        LEFT JOIN honorariomensal honorario ON honorario.id = cliente.honorario_id
        LEFT JOIN financeiro.clientefornecedorfinanceiro clifor ON clifor.id = honorario.clifor_id
        LEFT JOIN municipio ON municipio.id = clifor.municipio_id
        LEFT JOIN estado ON municipio.estado_id = estado.id
        WHERE controle.empresa_id IN (#{empresa})
        AND (meses.estado IS NULL OR estado.id = meses.estado)
        AND CASE
          WHEN to_char(meses.final, 'YYYY-MM') = to_char(current_date, 'YYYY-MM')
          THEN honorario.id NOT IN (
            SELECT UNNEST(ids) FROM emp_bloqueada
          )
          ELSE true
        END
        GROUP BY meses.final, controle.tipo
        ORDER BY meses.final
    ),
    sqlCompleta AS (
      SELECT *
      FROM sql
      WHERE tipo != 'BLOQUEADO_ATUALMENTE'
      UNION ALL
      SELECT qtd, valor, media, final, tipo FROM emp_bloqueada
    )
    SELECT TO_CHAR(meses.final, 'MM/YYYY') AS final,
        COALESCE(normal.qtd,0) + COALESCE(manutencao.qtd,0) AS normalQtd,
        COALESCE(normal.valor,0) + COALESCE(manutencao.valor,0) AS normalValor,
        case when normal.qtd is null then 0 else ROUND((COALESCE(normal.valor,0) + COALESCE(manutencao.valor,0))/(normal.qtd + COALESCE(manutencao.qtd,0)),2) end AS normalMedia,
        COALESCE(bloqueado.qtd,0) AS bloqueadoQtd,
        COALESCE(bloqueado.valor,0) AS bloqueadoValor,
        COALESCE(bloqueado.media,0) AS bloqueadoMedia,
        COALESCE(bloqueado_atualmente.qtd,0) AS bloqueadoAtualmenteQtd,
        COALESCE(bloqueado_atualmente.valor,0) AS bloqueadoAtualmenteValor,
        COALESCE(bloqueado_atualmente.media,0) AS bloqueadoAtualmenteMedia,
        COALESCE(paralisado.qtd,0) AS paralisadoQtd,
        COALESCE(paralisado.valor,0) AS paralisadoValor,
        COALESCE(paralisado.media,0) AS paralisadoMedia,
        coalesce(normal.qtd,0) + COALESCE(manutencao.qtd,0) + COALESCE(bloqueado.qtd,0) + CASE WHEN to_char(meses.final, 'YYYY-MM') = to_char(current_date, 'YYYY-MM') THEN COALESCE(bloqueado_atualmente.qtd,0) ELSE 0 END  AS totalQtd,
        COALESCE(normal.valor,0) + COALESCE(manutencao.valor,0) + COALESCE(bloqueado.valor,0) + CASE WHEN to_char(meses.final, 'YYYY-MM') = to_char(current_date, 'YYYY-MM') THEN COALESCE(bloqueado_atualmente.valor,0) ELSE 0 END AS totalValor,
        ROUND((COALESCE(normal.valor,0) + COALESCE(manutencao.valor,0) + COALESCE(bloqueado.valor,0))/(COALESCE(normal.qtd,1) + COALESCE(manutencao.qtd,0) + coalesce(bloqueado.qtd,0)),2) AS totalMedia
    FROM meses
    LEFT JOIN sqlCompleta normal ON normal.final = meses.final AND normal.tipo = 'NORMAL'
    LEFT JOIN sqlCompleta bloqueado ON bloqueado.final = meses.final AND bloqueado.tipo = 'BLOQUEADO'
    LEFT JOIN sqlCompleta bloqueado_atualmente ON bloqueado_atualmente.tipo = 'BLOQUEADO_ATUALMENTE'
    LEFT JOIN sqlCompleta paralisado ON paralisado.final = meses.final AND paralisado.tipo = 'PARALISADO'
    LEFT JOIN sqlCompleta manutencao ON manutencao.final = meses.final AND manutencao.tipo = 'EM_MANUTENCAO'
    "
  end
  # left join sql bloqueadoAtualmente on bloqueadoAtualmente.final = bloqueadoAtualmente.final and bloqueadoAtualmente.tipo = 'BLOQUEADO' and to_char(meses.final, 'MM') = to_char(current_date, 'MM')
  def self.get_clientes_ativos_cidade(empresa, estado, order)
    return "
       with parametros as (
          select 	16::int as tipo_id,
                  #{ estado.present? ? estado : 'null'}::int as estado
        ),
        sql as (
          select distinct honorario.id as honorarioId, honorario.descricao, honorario.valor, cliente.id, cliente.cpfcnpj, cliente.razaosocial, cliente.nomefantasia, municipio.nome, estado.sigla
          from honorariomensal honorario
          inner join parametros on true
          inner join financeiro.clientefornecedorfinanceiro cliente on cliente.id = honorario.clifor_id
          left join municipio on municipio.id = cliente.municipio_id
          left join estado on estado.id = municipio.estado_id
          where honorario.empresa_id in (#{empresa})
            and (parametros.tipo_id is null or parametros.tipo_id = honorario.tipo_id)
            and honorario.datavencimento <= (date_trunc('month', current_date) + interval '1 month') - interval '1 day'
            and (parametros.estado is null or estado.id = parametros.estado)
            and honorario.ativo is true
        ),
        total as (
          select count(sql.valor) as total
          from sql
        )
        select nome || '-' || sigla as nome, total, count(honorarioid) as quantidade, sum(sql.valor) as valor
        from sql
        inner join total on true
        group by nome, sigla, total
        order by #{order == 'QTD' ? 'count(honorarioid)' : 'sum(sql.valor)' } desc, nome || '-' || sigla
    "
  end

  def self.get_total_faturamento_12_meses(empresa, estado)
    return "
       with parametros as (
                 select  #{estado.present?  ? estado : 'null'}::int as estado_id
       ),
       meses as (
            select a::date as inicial, (a + INTERVAL'1 month' - INTERVAL'1 day')::date as final
            from generate_series((date_trunc('month', current_date - interval '14 month') + interval '1 month')::date, (date_trunc('month', current_date + interval '1 month') - interval '1 day')::date,INTERVAL'1 month') a
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
        inner join parametros on true
        inner JOIN debitospagos debitopago ON debitopago.datapagamento::date between meses.inicial and meses.final and debitopago.empresa_id in (#{empresa})
        inner JOIN debito_debitospagos debito_debitopago ON debito_debitopago.debitopago_id = debitopago.id
        inner join debitos debito on debito.id = debito_debitopago.debito_id
        inner join tipocobrancavalor tipo_valor on tipo_valor.debito_id = debito.id
        inner join financeiro.clientefornecedorfinanceiro cliente ON cliente.id = debito.clifor_id
        LEFT JOIN tipocobranca tipo ON tipo.id = tipo_valor.tipocobranca_id
        left join municipio cidade on cidade.id = cliente.municipio_id
        left join estado estado on estado.id = cidade.estado_id
        where (parametros.estado_id is null or parametros.estado_id = estado.id)
        group by idEmpresa, debito.id, idCobranca, nomecobranca, idCliente, razaosocialcliente, debito.status, debitopago.datapagamento, valorDebito,
		            tipo_valor.valor, debito.parcela, cidade.nome, estado.sigla, estado.nome, meses.final, debito_debitopago.valor, debito_debitopago.valordesconto, debito_debitopago.valorjuros, debito_debitopago.valormulta
        ),
	       totalPorTipo as (
            with totalPorTipoid as (
              select sum(sql.valorpago) as totalGeral, sql.final, idcobranca, nomecobranca
                from sql
                group by sql.final, sql.idcobranca, nomecobranca
                order by sql.final
            )
            select 	sum(case when tipo.idcobranca = 66 then tipo.totalgeral else 0 end) as valorInstalacao,
              sum(case when tipo.idcobranca = 16 then tipo.totalgeral else 0 end) as valorMensalidade,
              sum(case when tipo.idcobranca not in (16,66) then tipo.totalgeral else 0 end) as valorOutros,
              tipo.final
            from totalPorTipoid tipo
            group by tipo.final
	      ),
        totalFaturado as (
          select sum(sql.valorpago) as totalGeral, sql.final
          from sql
          group by sql.final
          order by sql.final
        )
        select TO_CHAR(meses.final, 'MM/YYYY') as data,
              coalesce(totalFaturado.totalGeral,0) as totalGeral,
              coalesce(tipo.valorInstalacao,0) as valorInstalacao,
              coalesce(tipo.valorMensalidade,0) as valorMensalidade,
              coalesce(tipo.valorOutros,0) as valorOutros
        from meses
        left join totalFaturado on totalFaturado.final = meses.final
        left join totalPorTipo tipo on tipo.final = totalFaturado.final
    "
  end

  def self.get_total_faturamento_UF(empresa, d_init, d_end)
    return "
    with SQL_FATURAMENTO as (
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
             coalesce(sistema.nome, '') AS sistema
          FROM debitospagos debitopago       
          inner JOIN debito_debitospagos debito_debitopago ON debito_debitopago.debitopago_id = debitopago.id
          inner join debitos debito on debito.id = debito_debitopago.debito_id
          inner join tipocobrancavalor tipo_valor on tipo_valor.debito_id = debito.id
          inner join financeiro.clientefornecedorfinanceiro cliente ON cliente.id = debito.clifor_id
          LEFT JOIN tipocobranca tipo ON tipo.id = tipo_valor.tipocobranca_id
          left join municipio cidade on cidade.id = cliente.municipio_id
          left join estado estado on estado.id = cidade.estado_id
          left join contrato on contrato.id= (select max(id) from contrato
                            where contrato.cliente_id = debito.clifor_id
                            and contrato.empresa_id = debito.empresa_id)
          LEFT JOIN sistema ON sistema.id = contrato.sistema_id
          where (debitopago.datapagamento::date between '#{d_init}' and '#{d_end}') and debitopago.empresa_id in (#{empresa})
          group by idEmpresa, debito.id, idCobranca, nomecobranca, idCliente, razaosocialcliente, debito.status, debitopago.datapagamento, valorDebito,
                  tipo_valor.valor, debito.parcela, cidade.nome, estado.sigla, estado.nome, sistema.nome, debito_debitopago.valor, debito_debitopago.valordesconto, debito_debitopago.valorjuros, debito_debitopago.valormulta     )
      select sigla, sum(valorPago) as faturamento
      from SQL_FATURAMENTO
      GROUP BY sigla
      order by faturamento desc
    "
  end

  def self.get_primeira_parcela_UF(empresa, d_init, d_end, script)
    return "
    with primeira_parcela_mensalidade as (
      with id_debito as (
      select distinct c.clifor_id, min(c.datacompetencia) as datacompetencia, min(c.id) as id
      from debitos c
      inner join tipocobrancavalor tc on tc.debito_id = c.id and tc.tipocobranca_id = 16

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
          where debito.id <> 499521
          group by debito.id, debito.clifor_id, coalesce(boleto.datavencimento, debito.datavencimento), debitopago.datapagamento
    ),
    sqlMensalidadePaga as (
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
      debito_debitopago.valor as valorPagoTotal
    from primeira_parcela_mensalidade pri 
    inner join debitos debito on debito.id = pri.id
    inner join financeiro.clientefornecedorfinanceiro cliente on cliente.id = debito.clifor_id
    left join municipio cidade on cidade.id = cliente.municipio_id
    left join estado on estado.id = cidade.estado_id
    left join debito_debitospagos debito_debitopago on debito_debitopago.debito_id = debito.id
    left join debitospagos debitopago on debitopago.id = debito_debitopago.debitopago_id
    left join boletogerado boleto on boleto.id = debito.boletogerado_id
    where debito.status in ('PAGO')
        and debito.empresa_id in (#{empresa})
      and pri.datapagamento::date between '#{d_init}' and '#{d_end}'
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
      debito_debitopago.valorjuros,
      debito_debitopago.valor,
      debitopago.datapagamento
    ),
    primeira_parcela_instalacao as (
    SELECT  d.id as idDebito,
              coalesce(boleto.datavencimento, d.datavencimento) as datavencimento,
              coalesce(d.parcela,1) as parcela,
              d.clifor_id,
              debitopago.datapagamento
    FROM debitos d
    inner join financeiro.clientefornecedorfinanceiro c ON c.id = d.clifor_id and c.parceiro is false
    inner join tipocobrancavalor tcv on tcv.debito_id = d.id and tcv.tipocobranca_id = 66
    left join boletogerado boleto on boleto.id = d.boletogerado_id
    left join debito_debitospagos debito_debitopago on debito_debitopago.debito_id = d.id
    left join debitospagos debitopago on debitopago.id = debito_debitopago.debitopago_id
    WHERE d.empresa_id in (#{empresa})
      and d.status in ('PENDENTE', 'PAGO', 'PARCIALMENTE_PAGO')
      and coalesce(d.parcela,1) = 1
    group by d.id, coalesce(boleto.datavencimento, d.datavencimento), parcela, d.clifor_id, debitopago.datapagamento
    ),
    sqlInstalacaoPaga as (
    select 	debito.id,
    debito.empresa_id as empresa_id,
          cliente.id as clifor_id,
          cliente.razaosocial,
    cidade.nome,
    (estado.nome || '-' || estado.sigla) as estado,
          estado.sigla,
    coalesce(boleto.datavencimento, debito.datavencimento) as datavencimento,
    debito.valor,
    debito.status as status,
    debitopago.datapagamento::date,
    tcv.valor as valorTipo,
    sum(debito_debitopago.valorjuros) as jurosPago,
    case when debito.valor = tcv.valor then (case when debito.status = 'PARCIALMENTE_PAGO' then (debito.valor - debito.saldo) else tcv.valor end)
    else (case when debito.status = 'PARCIALMENTE_PAGO' then round((((debito.valor - debito.saldo)/100)*trunc(((tcv.valor * 100)/(case when debito.valor = 0 then 1 else debito.valor end)),2)),2) else tcv.valor end)
    end as valorPagoTipo,
    sum(debito_debitopago.valor) as valorPagoTotal,
    coalesce(debito.parcela,1) as parcela
    from primeira_parcela_instalacao pri_parcela 
    INNER JOIN debitos debito on debito.id = pri_parcela.idDebito
    inner join tipocobrancavalor tcv on tcv.debito_id = debito.id and tcv.tipocobranca_id = 66
    inner join financeiro.clientefornecedorfinanceiro cliente ON cliente.id = debito.clifor_id
    LEFT JOIN debito_debitospagos debito_debitopago ON debito_debitopago.debito_id = pri_parcela.idDebito
    LEFT JOIN debitospagos debitopago ON debitopago.id  = debito_debitopago.debitopago_id
    left join municipio cidade on cidade.id = cliente.municipio_id
    left join estado on estado.id = cidade.estado_id
    left join boletogerado boleto on boleto.id = debito.boletogerado_id
    where debito.status in ('PAGO')
      and debito.empresa_id in (#{empresa})
      and coalesce(debito.parcela,1) = 1
      and pri_parcela.datapagamento::date between '#{d_init}' and '#{d_end}'
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
      tcv.valor,
      coalesce(debito.parcela,1)
    )
    select sigla, sum(sql.valorPagoTotal) as total
    from sql#{script}Paga sql
    group by sigla
    order by total desc

    "
  end

  def self.get_total_faturamento_12_meses_sistema(empresa, estado, d_init, d_end)
    return "
       with parametros as (
                 select  #{estado.present?  ? estado : 'null'}::int as estado_id
       )      
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
                 coalesce(sistema.nome, '') AS sistema
        FROM debitospagos debitopago
        inner join parametros on true        
        inner JOIN debito_debitospagos debito_debitopago ON debito_debitopago.debitopago_id = debitopago.id
        inner join debitos debito on debito.id = debito_debitopago.debito_id
        inner join tipocobrancavalor tipo_valor on tipo_valor.debito_id = debito.id
        inner join financeiro.clientefornecedorfinanceiro cliente ON cliente.id = debito.clifor_id
        LEFT JOIN tipocobranca tipo ON tipo.id = tipo_valor.tipocobranca_id
        left join municipio cidade on cidade.id = cliente.municipio_id
        left join estado estado on estado.id = cidade.estado_id
        left join contrato on contrato.id= (select max(id) from contrato
        									where contrato.cliente_id = debito.clifor_id
        									and contrato.empresa_id = debito.empresa_id)
        LEFT JOIN sistema ON sistema.id = contrato.sistema_id
        where (parametros.estado_id is null or parametros.estado_id = estado.id) and
          (debitopago.datapagamento::date between '#{d_init}' and '#{d_end}') and debitopago.empresa_id in (#{empresa}) and
          tipo.id = 16
        group by idEmpresa, debito.id, idCobranca, nomecobranca, idCliente, razaosocialcliente, debito.status, debitopago.datapagamento, valorDebito,
		            tipo_valor.valor, debito.parcela, cidade.nome, estado.sigla, estado.nome, sistema.nome, debito_debitopago.valor, debito_debitopago.valordesconto, debito_debitopago.valorjuros, debito_debitopago.valormulta
    "
  end

  def self.get_total_faturamento_mes_anterior(empresa, estado)
    return "
       with parametros as (
                 select  #{estado.present?  ? estado : 'null'}::int as estado_id
       ),
       meses as (
            select (date_trunc('month',current_date) - interval '1 month')::date as inicial,
                   case when extract('day' from current_date::date) = 1 then (current_date::date - interval '1 month')::date else (current_date::date - interval '1 month')::date end as final
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
                 debitopago.datapagamento as datapagamento,
                 sum(coalesce(debito_debitopago.valor,0)) as valorpagodebito,
                 sum(coalesce(debito_debitopago.valordesconto,0)) as valordescontodebito,
                 sum(coalesce(debito_debitopago.valorjuros,0)) as valorjurosdebito,
                 0 as valorTipo,
                 meses.final
        FROM meses
        inner join parametros on true
        inner JOIN debitospagos debitopago ON debitopago.datapagamento::date between meses.inicial and meses.final and debitopago.empresa_id in (#{empresa})
        inner JOIN debito_debitospagos debito_debitopago ON debito_debitopago.debitopago_id = debitopago.id
        inner join debitos debito on debito.id = debito_debitopago.debito_id
        inner join tipocobrancavalor tipo_valor on tipo_valor.debito_id = debito.id
        inner join financeiro.clientefornecedorfinanceiro cliente ON cliente.id = debito.clifor_id
        LEFT JOIN tipocobranca tipo ON tipo.id = tipo_valor.tipocobranca_id
        left join municipio cidade on cidade.id = cliente.municipio_id
        left join estado estado on estado.id = cidade.estado_id
        where (parametros.estado_id is null or parametros.estado_id = estado.id)
        group by idEmpresa, debito.id, idCobranca, nomecobranca, idCliente, razaosocialcliente, debito.status, debitopago.datapagamento, valorDebito,
		            tipo_valor.valor, debito.parcela, cidade.nome, estado.sigla, estado.nome, meses.final, debito_debitopago.valor, debito_debitopago.valordesconto, debito_debitopago.valorjuros, debito_debitopago.valormulta
        ),
	       totalPorTipo as (
            with totalPorTipoid as (
              select sum(sql.valorpago) as totalGeral, sql.final, idcobranca, nomecobranca
                from sql
                group by sql.final, sql.idcobranca, nomecobranca
                order by sql.final
            )
            select 	sum(case when tipo.idcobranca = 66 then tipo.totalgeral else 0 end) as valorInstalacao,
              sum(case when tipo.idcobranca = 16 then tipo.totalgeral else 0 end) as valorMensalidade,
              sum(case when tipo.idcobranca not in (16,66) then tipo.totalgeral else 0 end) as valorOutros,
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
              coalesce(tipo.valorInstalacao,0) as valorInstalacao,
              coalesce(tipo.valorMensalidade,0) as valorMensalidade,
              coalesce(tipo.valorOutros,0) as valorOutros
        from meses
        left join totalFaturado on totalFaturado.final = meses.final
        left join totalPorTipo tipo on tipo.final = totalFaturado.final
    "
  end

  def self.get_total_primeira_mensalidade_por_tipo(empresa, estado_id)
    return "
      with parametros as (
        select 	#{ estado_id.present? ? estado_id : 'null'}::int as estado_id
      ),
       meses as (
    select a::date as inicial, (a + INTERVAL'1 month' - INTERVAL'1 day')::date as final
    from generate_series((date_trunc('month', current_date - interval '14 month') + interval '1 month')::date, (date_trunc('month', current_date + interval '1 month') - interval '1 day')::date,INTERVAL'1 month') a
),
primeira_parcela_mensalidade as (
        with id_debito as (
        select distinct c.clifor_id, min(c.datacompetencia) as datacompetencia, min(c.id) as id
        from debitos c
        inner join tipocobrancavalor tc on tc.debito_id = c.id and tc.tipocobranca_id = 16

        where c.status in ('PENDENTE', 'PAGO', 'PARCIALMENTE_PAGO')
        and c.empresa_id in (#{empresa})
        group by c.clifor_id
        order by c.clifor_id
        )
        select 	debito.id, debito.datacompetencia, debito.clifor_id, coalesce(boleto.datavencimento, debito.datavencimento) as datavencimento,
		debitopago.datapagamento::date as datapagamento
        from id_debito
        inner join debitos debito on debito.id = id_debito.id and debito.clifor_id = id_debito.clifor_id
        left join boletogerado boleto on boleto.id = debito.boletogerado_id
        left join debito_debitospagos debito_debitopago on debito_debitopago.debito_id = debito.id
        left join debitospagos debitopago on debitopago.id = debito_debitopago.debitopago_id
        where debito.id <> 499521
        group by debito.id, debito.clifor_id, coalesce(boleto.datavencimento, debito.datavencimento), debitopago.datapagamento
),
sqlMensalidadePaga as (
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
  inner join primeira_parcela_mensalidade pri on pri.datapagamento::date between meses.inicial and meses.final
  inner join debitos debito on debito.id = pri.id
  inner join parametros on true
  inner join financeiro.clientefornecedorfinanceiro cliente on cliente.id = debito.clifor_id
  left join municipio cidade on cidade.id = cliente.municipio_id
  left join estado on estado.id = cidade.estado_id
  left join debito_debitospagos debito_debitopago on debito_debitopago.debito_id = debito.id
  left join debitospagos debitopago on debitopago.id = debito_debitopago.debitopago_id
  left join boletogerado boleto on boleto.id = debito.boletogerado_id
  where debito.status in ('PAGO')
  and debito.empresa_id in (#{empresa})
  and (parametros.estado_id is null or parametros.estado_id = estado.id)
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
     debito_debitopago.valorjuros,
     debito_debitopago.valor,
     meses.final,
     debitopago.datapagamento
),
sqlMensalidadePendente as (
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
  inner join primeira_parcela_mensalidade pri on pri.datavencimento <= current_date
  inner join debitos debito on debito.id = pri.id
  inner join parametros on true
  inner join financeiro.clientefornecedorfinanceiro cliente on cliente.id = debito.clifor_id
  left join municipio cidade on cidade.id = cliente.municipio_id
  left join estado on estado.id = cidade.estado_id
  left join boletogerado boleto on boleto.id = debito.boletogerado_id
  where debito.status in ('PENDENTE', 'PARCIALMENTE_PAGO')
  and debito.empresa_id in (#{empresa})
  and (parametros.estado_id is null or parametros.estado_id = estado.id)
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
totalPagoMensalidade as (
	select sum(sql.valorpago) as totalGeral, sql.final, count( distinct sql.clifor_id) as quantidade
	from sqlMensalidadePaga sql
	group by sql.final
	order by sql.final
),
totalPendenteMensalidade as (
	select sum(sql.valor) as totalGeral, sql.final, count( distinct sql.clifor_id) as quantidade
	from sqlMensalidadePendente sql
	group by sql.final
	order by sql.final
),
primeira_parcela_instalacao as (
  SELECT  d.id as idDebito,
            coalesce(boleto.datavencimento, d.datavencimento) as datavencimento,
            coalesce(d.parcela,1) as parcela,
            d.clifor_id,
            debitopago.datapagamento
  FROM debitos d
  inner join financeiro.clientefornecedorfinanceiro c ON c.id = d.clifor_id and c.parceiro is false
  inner join tipocobrancavalor tcv on tcv.debito_id = d.id and tcv.tipocobranca_id = 66
  left join boletogerado boleto on boleto.id = d.boletogerado_id
  left join debito_debitospagos debito_debitopago on debito_debitopago.debito_id = d.id
  left join debitospagos debitopago on debitopago.id = debito_debitopago.debitopago_id
  WHERE d.empresa_id in (#{empresa})
    and d.status in ('PENDENTE', 'PAGO', 'PARCIALMENTE_PAGO')
    and coalesce(d.parcela,1) = 1
  group by d.id, coalesce(boleto.datavencimento, d.datavencimento), parcela, d.clifor_id, debitopago.datapagamento
),
sqlInstalacaoPaga as (
select 	debito.id,
	debito.empresa_id as empresa_id,
        cliente.id as clifor_id,
        cliente.razaosocial,
	cidade.nome,
	(estado.nome || '-' || estado.sigla) as estado,
        estado.sigla,
	coalesce(boleto.datavencimento, debito.datavencimento) as datavencimento,
	debito.valor,
	debito.status as status,
	debitopago.datapagamento::date,
	tcv.valor as valorTipo,
	sum(debito_debitopago.valorjuros) as jurosPago,
	case when debito.valor = tcv.valor then (case when debito.status = 'PARCIALMENTE_PAGO' then (debito.valor - debito.saldo) else tcv.valor end)
	else (case when debito.status = 'PARCIALMENTE_PAGO' then round((((debito.valor - debito.saldo)/100)*trunc(((tcv.valor * 100)/(case when debito.valor = 0 then 1 else debito.valor end)),2)),2) else tcv.valor end)
	end as valorPagoTipo,
	sum(debito_debitopago.valor) as valorPagoTotal,
	coalesce(debito.parcela,1) as parcela,
	meses.final
  from meses
  inner join parametros on true
  inner join primeira_parcela_instalacao pri_parcela on pri_parcela.datapagamento::date between meses.inicial and meses.final
  INNER JOIN debitos debito on debito.id = pri_parcela.idDebito
  inner join tipocobrancavalor tcv on tcv.debito_id = debito.id and tcv.tipocobranca_id = 66
  inner join financeiro.clientefornecedorfinanceiro cliente ON cliente.id = debito.clifor_id
  LEFT JOIN debito_debitospagos debito_debitopago ON debito_debitopago.debito_id = pri_parcela.idDebito
  LEFT JOIN debitospagos debitopago ON debitopago.id  = debito_debitopago.debitopago_id
  left join municipio cidade on cidade.id = cliente.municipio_id
  left join estado on estado.id = cidade.estado_id
  left join boletogerado boleto on boleto.id = debito.boletogerado_id
  where debito.status in ('PAGO')
  and debito.empresa_id in (#{empresa})
  and coalesce(debito.parcela,1) = 1
  and (parametros.estado_id is null or parametros.estado_id = estado.id)
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
    tcv.valor,
    coalesce(debito.parcela,1),
    meses.final,
    meses.inicial
),
sqlInstalacaoPendente as (
          select 	debito.id,
            debito.empresa_id as empresa_id,
            cliente.id as clifor_id,
            cliente.razaosocial,
            cidade.nome,
            (estado.nome || '-' || estado.sigla) as estado,
            estado.sigla,
            coalesce(boleto.datavencimento, debito.datavencimento) as datavencimento,
            debito.valor,
            debito.status as status,
            debitopago.datapagamento::date,
            tcv.valor as valorTipo,
            sum(debito_debitopago.valorjuros) as jurosPago,
            case when debito.valor = tcv.valor then (case when debito.status = 'PARCIALMENTE_PAGO' then (debito.valor - debito.saldo) else tcv.valor end)
            else (case when debito.status = 'PARCIALMENTE_PAGO' then round((((debito.valor - debito.saldo)/100)*trunc(((tcv.valor * 100)/(case when debito.valor = 0 then 1 else debito.valor end)),2)),2) else tcv.valor end)
             end as valorPagoTipo,
            sum(debito_debitopago.valor) as valorPagoTotal,
            coalesce(debito.parcela,1) as parcela,
            meses.final,
            meses.inicial
          from meses
          inner join parametros on true
          inner join primeira_parcela_instalacao pri_parcela on pri_parcela.datavencimento <= current_date
          INNER JOIN debitos debito on debito.id = pri_parcela.idDebito
          inner join tipocobrancavalor tcv on tcv.debito_id = debito.id and tcv.tipocobranca_id = 66
          inner join financeiro.clientefornecedorfinanceiro cliente ON cliente.id = debito.clifor_id
          LEFT JOIN debito_debitospagos debito_debitopago ON debito_debitopago.debito_id = pri_parcela.idDebito
          LEFT JOIN debitospagos debitopago ON debitopago.id  = debito_debitopago.debitopago_id
          left join municipio cidade on cidade.id = cliente.municipio_id
          left join estado on estado.id = cidade.estado_id
          left join boletogerado boleto on boleto.id = debito.boletogerado_id
          where debito.status in ('PENDENTE', 'PARCIALMENTE_PAGO')
          and debito.empresa_id in (#{empresa})
          and coalesce(debito.parcela,1) = 1
          and (parametros.estado_id is null or parametros.estado_id = estado.id)
          and coalesce(boleto.datavencimento, debito.datavencimento) < current_date
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
            tcv.valor,
            coalesce(debito.parcela,1),
            meses.final,
            meses.inicial
),
totalPagoInstalacao as (
	select sum(sql.valorPagoTipo) as totalGeral, sql.final, count(sql.clifor_id) as quantidade
	from sqlInstalacaoPaga sql
	group by sql.final
	order by sql.final
),
totalPendenteInstalacao as (
	select sum(sql.valortipo) as totalGeral, sql.final, count(sql.clifor_id) as quantidade
	from sqlInstalacaoPendente sql
	group by sql.final
	order by sql.final
)
  select  TO_CHAR(meses.final, 'MM/YYYY') as data,
          coalesce(totalPagoMensalidade.totalGeral, 0) as valorMensalidade,
          coalesce(totalPagoMensalidade.quantidade, 0) as quantidadeMensalidade,
          case when coalesce(totalPagoMensalidade.quantidade,0) = 0 then 0 else ROUND((totalPagoMensalidade.totalGeral / coalesce(totalPagoMensalidade.quantidade,1)),2) end as mediaMensalidade,
          coalesce(totalPagoInstalacao.totalGeral,0) as valorInstalacao,
          coalesce(totalPagoInstalacao.quantidade,0) as quantidadeInstalacao,
          case when coalesce(totalPagoInstalacao.quantidade,0) = 0 then 0 else ROUND((totalPagoInstalacao.totalGeral / coalesce(totalPagoInstalacao.quantidade,1)),2) end as mediaInstalacao,
          coalesce(totalPendenteMensalidade.totalGeral,0) as valorPendendeMensalidade,
          coalesce(totalPendenteMensalidade.quantidade,0) as quantidadePendenteMensalidade,
          ROUND((totalPendenteMensalidade.totalGeral / coalesce(totalPendenteMensalidade.quantidade,1)),2) as mediaMensalidadePend,
          coalesce(totalPendenteInstalacao.totalGeral,0) as valorPendenteInstalacao,
          coalesce(totalPendenteInstalacao.quantidade,0) as quantidadePendenteInstalacao,
          ROUND((totalPendenteInstalacao.totalGeral / coalesce(totalPendenteInstalacao.quantidade,1)),2) as mediaInstalacaoPend
    from meses
  left join totalPagoMensalidade on totalPagoMensalidade.final = meses.final
  left join totalPendenteMensalidade on totalPendenteMensalidade.final = meses.final
  left join totalPagoInstalacao on totalPagoInstalacao.final = meses.final
  left join totalPendenteInstalacao on totalPendenteInstalacao.final = meses.final
    "
  end

  def self.get_total_primeira_mensalidade_por_tipo_mes_anterior(empresa, estado_id)
    return "
          with parametros as (
                  select 	#{ estado_id.present? ? estado_id : 'null'}::int as estado_id
                ),
                 meses as (
          select (date_trunc('month',current_date) - interval '1 month')::date as inicial, (current_date - interval '1 month')::date as final
          ),
          primeira_parcela_mensalidade as (
                  with id_debito as (
                  select distinct c.clifor_id, min(c.datacompetencia) as datacompetencia, min(c.id) as id
                  from debitos c
                  inner join tipocobrancavalor tc on tc.debito_id = c.id and tc.tipocobranca_id = 16

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
          sqlMensalidadePaga as (
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
            inner join primeira_parcela_mensalidade pri on pri.datapagamento::date between meses.inicial and meses.final
            inner join debitos debito on debito.id = pri.id
            inner join parametros on true
            inner join financeiro.clientefornecedorfinanceiro cliente on cliente.id = debito.clifor_id
            left join municipio cidade on cidade.id = cliente.municipio_id
            left join estado on estado.id = cidade.estado_id
            left join debito_debitospagos debito_debitopago on debito_debitopago.debito_id = debito.id
            left join debitospagos debitopago on debitopago.id = debito_debitopago.debitopago_id
            left join boletogerado boleto on boleto.id = debito.boletogerado_id
            where debito.status in ('PAGO')
            and debito.empresa_id in (#{empresa})
            and (parametros.estado_id is null or parametros.estado_id = estado.id)
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
               debito_debitopago.valorjuros,
               debito_debitopago.valor,
               meses.final,
               debitopago.datapagamento
          ),
          totalPagoMensalidade as (
            select sum(sql.valorpago) as totalGeral, sql.final, count( distinct sql.clifor_id) as quantidade
            from sqlMensalidadePaga sql
            group by sql.final
            order by sql.final
          ),
          primeira_parcela_instalacao as (
            SELECT  d.id as idDebito,
                      coalesce(boleto.datavencimento, d.datavencimento) as datavencimento,
                      coalesce(d.parcela,1) as parcela,
                      d.clifor_id,
                      debitopago.datapagamento
            FROM debitos d
            inner join financeiro.clientefornecedorfinanceiro c ON c.id = d.clifor_id and c.parceiro is false
            inner join tipocobrancavalor tcv on tcv.debito_id = d.id and tcv.tipocobranca_id = 66
            left join boletogerado boleto on boleto.id = d.boletogerado_id
            left join debito_debitospagos debito_debitopago on debito_debitopago.debito_id = d.id
            left join debitospagos debitopago on debitopago.id = debito_debitopago.debitopago_id
            WHERE d.empresa_id in (#{empresa})
              and d.status in ('PENDENTE', 'PAGO', 'PARCIALMENTE_PAGO')
              and coalesce(d.parcela,1) = 1
            group by d.id, coalesce(boleto.datavencimento, d.datavencimento), parcela, d.clifor_id, debitopago.datapagamento
          ),
          sqlInstalacaoPaga as (
          select 	debito.id,
            debito.empresa_id as empresa_id,
                  cliente.id as clifor_id,
                  cliente.razaosocial,
            cidade.nome,
            (estado.nome || '-' || estado.sigla) as estado,
                  estado.sigla,
            coalesce(boleto.datavencimento, debito.datavencimento) as datavencimento,
            debito.valor,
            debito.status as status,
            debitopago.datapagamento::date,
            tcv.valor as valorTipo,
            sum(debito_debitopago.valorjuros) as jurosPago,
            case when debito.valor = tcv.valor then (case when debito.status = 'PARCIALMENTE_PAGO' then (debito.valor - debito.saldo) else tcv.valor end)
            else (case when debito.status = 'PARCIALMENTE_PAGO' then round((((debito.valor - debito.saldo)/100)*trunc(((tcv.valor * 100)/(case when debito.valor = 0 then 1 else debito.valor end)),2)),2) else tcv.valor end)
            end as valorPagoTipo,
            sum(debito_debitopago.valor) as valorPagoTotal,
            coalesce(debito.parcela,1) as parcela,
            meses.final
            from meses
            inner join parametros on true
            inner join primeira_parcela_instalacao pri_parcela on pri_parcela.datapagamento::date between meses.inicial and meses.final
            INNER JOIN debitos debito on debito.id = pri_parcela.idDebito
            inner join tipocobrancavalor tcv on tcv.debito_id = debito.id and tcv.tipocobranca_id = 66
            inner join financeiro.clientefornecedorfinanceiro cliente ON cliente.id = debito.clifor_id
            LEFT JOIN debito_debitospagos debito_debitopago ON debito_debitopago.debito_id = pri_parcela.idDebito
            LEFT JOIN debitospagos debitopago ON debitopago.id  = debito_debitopago.debitopago_id
            left join municipio cidade on cidade.id = cliente.municipio_id
            left join estado on estado.id = cidade.estado_id
            left join boletogerado boleto on boleto.id = debito.boletogerado_id
            where debito.status in ('PAGO')
            and debito.empresa_id in (#{empresa})
            and coalesce(debito.parcela,1) = 1
            and (parametros.estado_id is null or parametros.estado_id = estado.id)
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
              tcv.valor,
              coalesce(debito.parcela,1),
              meses.final,
              meses.inicial
          ),
          totalPagoInstalacao as (
            select sum(sql.valorPagoTipo) as totalGeral, sql.final, count(sql.clifor_id) as quantidade
            from sqlInstalacaoPaga sql
            group by sql.final
            order by sql.final
          )
            select  TO_CHAR(meses.final, 'MM/YYYY') as data,
                    coalesce(totalPagoMensalidade.totalGeral, 0) as valorMensalidade,
                    coalesce(totalPagoMensalidade.quantidade, 0) as quantidadeMensalidade,
                    case when coalesce(totalPagoMensalidade.quantidade,0) = 0 then 0 else ROUND((totalPagoMensalidade.totalGeral / coalesce(totalPagoMensalidade.quantidade,1)),2) end as mediaMensalidade,
                    coalesce(totalPagoInstalacao.totalGeral,0) as valorInstalacao,
                    coalesce(totalPagoInstalacao.quantidade,0) as quantidadeInstalacao,
                    case when coalesce(totalPagoInstalacao.quantidade,0) = 0 then 0 else ROUND((totalPagoInstalacao.totalGeral / coalesce(totalPagoInstalacao.quantidade,1)),2) end as mediaInstalacao
              from meses
            left join totalPagoMensalidade on totalPagoMensalidade.final = meses.final
            left join totalPagoInstalacao on totalPagoInstalacao.final = meses.final
    "
  end


  def self.get_inadimplencia_12_meses(empresa, estado_id)
    return "
       with meses as (
            select a::date as inicial, (a + INTERVAL'1 month' - INTERVAL'1 day')::date as final,
                    #{ estado_id.present? ? estado_id : 'null'}::int as estado_id
            from generate_series((date_trunc('month', current_date - interval '14 month') + interval '1 month')::date, (date_trunc('month', current_date + interval '1 month') - interval '1 day')::date,INTERVAL'1 month') a
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
	where meses.final between debito.datavencimento and (case when debitopago.id is null then meses.final else debitopago.datapagamento::date end)
    and (debitopago.id is null or extract(month from debito.datavencimento) != extract(month from debitopago.datapagamento))
    and (debitopago.id is null or meses.final != debitopago.datapagamento::date)
		and (debitopago.id is not null or debito.datavencimento < current_date)
    and (meses.estado_id is null or estado.id = meses.estado_id)
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
		where meses.final between boleto.datavencimento and (case when debitopago.id is null then meses.final else debitopago.datapagamento::date end)
		      and (debitopago.id is null or extract(month from boleto.datavencimento) != extract(month from debitopago.datapagamento))
		      and (debitopago.id is null or meses.final != debitopago.datapagamento::date)
		      and (debitopago.id is not null or boleto.datavencimento < current_date)
          and (meses.estado_id is null or estado.id = meses.estado_id)
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
	  select 	sum(case when sql.idCobranca = 66 then sql.valorTipo else 0 end) as valorInstalacao,
		        sum(case when sql.idCobranca = 16 then sql.valorTipo else 0 end) as valorMensalidade,
            sum(case when sql.idCobranca not in (66,16) then sql.valorTipo else 0 end) as valorOutros,
            sql.final
    from totalPorTipoid sql
    group by sql.final
  )

select TO_CHAR(meses.final, 'MM/YYYY') as data,
		coalesce(sum(totais.totalGeral),0) as total,
		meses.final,
		coalesce(tipo.valorInstalacao,0) valorInstalacao,
		coalesce(tipo.valorMensalidade,0) as valorMensalidade,
		coalesce(tipo.valorOutros,0) as valorOutros
from meses
left join totais on totais.final = meses.final
left join totaisPorTipo tipo on tipo.final = totais.final
group by meses.final, tipo.valorInstalacao, tipo.valorMensalidade, tipo.valorOutros
order by meses.final

"
  end

  def self.implantacoes_conluidas_12_meses(empresa, estado_id, vendedor_id, implantador_id)
    return "
        with meses as (
          select a::date as inicial, (a + INTERVAL'1 month' - INTERVAL'1 day')::date as final
          from generate_series((date_trunc('month', current_date - interval '14 month') + interval '1 month')::date, (date_trunc('month', current_date + interval '1 month') - interval '1 day')::date,INTERVAL'1 month') a
        ),
         sql as (
        select 	implantacao.id,
          implantacao.data_inicio,
          implantacao.data_fim,
          implantacao.status,
          implantacao.empresa_id,
          cliente.razao_social,
          cliente.cnpj,
          proposta.valor_mensalidade as mensalidade,
          proposta.valor_implantacao as implantacao,
          sistema.nome as sistema,
          meses.final
        from meses
        left join implantacoes implantacao on implantacao.data_fim::date between meses.inicial and meses.final and implantacao.status = 9 and implantacao.empresa_id in (#{ApplicationHelper.get_empresas_by_codigo(empresa)})
        left join clientes cliente on cliente.id = implantacao.cliente_id
        left join cidades cidade on cidade.id = cliente.cidade_id
        left join fechamentos f on f.id =  (select max(id) from fechamentos where cliente_id = cliente.id)
        left join propostas proposta on proposta.id = (select id from propostas where propostas.cliente_id = cliente.id and propostas.ativa is true order by id desc limit 1)
        left join pacotes pacote on pacote.id = proposta.pacote_id
        left join sistemas sistema on sistema.id = pacote.sistema_id
        where (#{ApplicationHelper.get_estado_by_codigo(estado_id)} is null or #{ApplicationHelper.get_estado_by_codigo(estado_id)} = cidade.estado_id)
          and (#{vendedor_id.blank? ? 'null' : vendedor_id} is null or #{vendedor_id.blank? ? 'null' : vendedor_id} = f.user_id)
          and (#{implantador_id.blank? ? 'null' : implantador_id} is null or #{implantador_id.blank? ? 'null' : implantador_id} = implantacao.user_id)
        ),
        totais as (
          select 	coalesce(count(sql.id),0) as quantidade,
            coalesce(sum(sql.mensalidade),0) as mensalidade,
            coalesce(sum(sql.implantacao),0) as implantacao,
            sql.final
          from sql
          group by sql.final
        ),
        totaisSistema as (
          select sql.final, upper(sql.sistema) as sistema, count(id) quantidade
          from sql
          group by sql.final, sql.sistema

        )
        select  TO_CHAR(meses.final, 'MM/YYYY') as data,
          coalesce(totais.quantidade,0) as quantidade,
          coalesce(totais.mensalidade,0) as mensalidade,
          coalesce(totais.implantacao,0) as implantacao,
          case when totais.quantidade = 0 then 0 else ROUND((totais.mensalidade / totais.quantidade),2) end as mediaMensalidade,
          case when totais.quantidade = 0 then 0 else ROUND((totais.implantacao / totais.quantidade),2) end as mediaImplantacao,
          coalesce(emissor.quantidade,0) as emissor,
          coalesce(gourmet.quantidade,0) as gourmet,
          coalesce(manager.quantidade,0) as manager,
          coalesce(ligth.quantidade,0) as light,
          (coalesce(outros.quantidade,0) + coalesce(trade.quantidade,0) + coalesce(web.quantidade,0) + coalesce(provendas.quantidade,0)) as outros
        from meses
          left join totais on totais.final = meses.final
          left join totaisSistema emissor on emissor.final = totais.final and emissor.sistema = 'EMISSOR'
          left join totaisSistema gourmet on gourmet.final = totais.final and gourmet.sistema = 'GOURMET'
          left join totaisSistema manager on manager.final = totais.final and manager.sistema = 'MANAGER'
          left join totaisSistema ligth on ligth.final = totais.final and ligth.sistema = 'LIGHT'
          left join totaisSistema trade on trade.final = totais.final and trade.sistema = 'TRADE'
          left join totaisSistema web on web.final = totais.final and web.sistema = 'EMISSOR WEB'
          left join totaisSistema provendas on provendas.final = totais.final and provendas.sistema = 'PRÓ-VENDAS'
          left join totaisSistema outros on outros.final = totais.final and outros.sistema not in ('EMISSOR', 'GOURMET', 'MANAGER', 'LIGHT', 'TRADE', 'EMISSOR WEB', 'PRÓ-VENDAS')
          order by meses.final
"
  end

  def self.implantacoes_conluidas_12_meses_mes_anterior(empresa, estado_id, vendedor_id, implantador_id)
    return "
        with meses as (
          select (date_trunc('month',current_date) - interval '1 month')::date as inicial, (current_date - interval '1 month')::date as final
        ),
         sql as (
        select 	implantacao.id,
          implantacao.data_inicio,
          implantacao.data_fim,
          implantacao.status,
          implantacao.empresa_id,
          cliente.razao_social,
          cliente.cnpj,
          proposta.valor_mensalidade as mensalidade,
          proposta.valor_implantacao as implantacao,
          sistema.nome as sistema,
          meses.final
        from meses
        left join implantacoes implantacao on implantacao.data_fim::date between meses.inicial and meses.final and implantacao.status = 9 and implantacao.empresa_id in (#{ApplicationHelper.get_empresas_by_codigo(empresa)})
        left join clientes cliente on cliente.id = implantacao.cliente_id
        left join cidades cidade on cidade.id = cliente.cidade_id
        left join fechamentos f on f.id =  (select max(id) from fechamentos where cliente_id = cliente.id)
        left join propostas proposta on proposta.id = (select id from propostas where propostas.cliente_id = cliente.id and propostas.ativa is true order by id desc limit 1)
        left join pacotes pacote on pacote.id = proposta.pacote_id
        left join sistemas sistema on sistema.id = pacote.sistema_id
        where (#{ApplicationHelper.get_estado_by_codigo(estado_id)} is null or #{ApplicationHelper.get_estado_by_codigo(estado_id)} = cidade.estado_id)
          and (#{vendedor_id.blank? ? 'null' : vendedor_id} is null or #{vendedor_id.blank? ? 'null' : vendedor_id} = f.user_id)
          and (#{implantador_id.blank? ? 'null' : implantador_id} is null or #{implantador_id.blank? ? 'null' : implantador_id} = implantacao.user_id)
        ),
        totais as (
          select 	coalesce(count(sql.id),0) as quantidade,
            coalesce(sum(sql.mensalidade),0) as mensalidade,
            coalesce(sum(sql.implantacao),0) as implantacao,
            sql.final
          from sql
          group by sql.final
        )
        select  TO_CHAR(meses.final, 'MM/YYYY') as data,
          coalesce(totais.quantidade,0) as quantidade,
          coalesce(totais.mensalidade,0) as mensalidade,
          coalesce(totais.implantacao,0) as implantacao,
          case when totais.quantidade = 0 then 0 else ROUND((totais.mensalidade / totais.quantidade),2) end as mediaMensalidade,
          case when totais.quantidade = 0 then 0 else ROUND((totais.implantacao / totais.quantidade),2) end as mediaImplantacao
        from meses
        left join totais on totais.final = meses.final
        order by meses.final
"
  end

  def self.get_demonstrativo_12_meses (empresa, estado)
    return "
    WITH meses as (
              select a::date as inicial, (a + INTERVAL'1 month' - INTERVAL'1 day')::date as final
              from generate_series((date_trunc('month', current_date - interval '14 month') + interval '1 month')::date, (date_trunc('month', current_date + interval '1 month') - interval '1 day')::date,INTERVAL'1 month') a
         ),
        SQL_RECEITA AS (
            SELECT DISTINCT
                'RECEITA' AS tipo,
                TO_CHAR(debitopago.datapagamento, 'MM/YYYY') AS DATA,
                debito.empresa_id AS idEmpresa,
                debito.id AS idDebito,
                tipo.id AS idCobranca,
                tipo.nome AS nomecobranca,
                debito.saldo AS saldoDebito,
                debito.valor AS valorDebito,
                debito.status,
                CASE
                    WHEN tipo_valor.valor <> debito.valor THEN round(((tipo_valor.valor * 100)/(case when debito.valor = 0 then 1 else debito.valor end)),2)
                    ELSE 100
                END AS percentualPago,
                coalesce(debito_debitopago.valorjuros,0) as valorJurosTipo,
                SUM(
                  coalesce(debito_debitopago.valor,0) +
                  coalesce(debito_debitopago.valorjuros,0) +
                  coalesce(debito_debitopago.valormulta,0) -
                  coalesce(debito_debitopago.valordesconto,0)
                ) AS valorPago,
                meses.final
            FROM
            meses
                INNER JOIN debitospagos debitopago ON debitopago.datapagamento::date BETWEEN meses.inicial AND meses.final
                AND debitopago.empresa_id in (#{empresa})
                INNER JOIN debito_debitospagos debito_debitopago ON debito_debitopago.debitopago_id = debitopago.id
                INNER JOIN debitos debito ON debito.id = debito_debitopago.debito_id
                INNER JOIN tipocobrancavalor tipo_valor ON tipo_valor.debito_id = debito.id
                LEFT JOIN tipocobranca tipo ON tipo.id = tipo_valor.tipocobranca_id
            GROUP BY
                idEmpresa,
                debito.id,
                idCobranca,
                nomecobranca,
                debito.status,
                debitopago.datapagamento,
                valorDebito,
                tipo_valor.valor,
                debito.parcela,
                meses.final,
                debito_debitopago.valor, debito_debitopago.valordesconto, debito_debitopago.valorjuros, debito_debitopago.valormulta
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
                INNER JOIN despesa despesa ON despesa.datapagamento::date BETWEEN meses.inicial AND meses.final
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

  def self.get_demonstrativo_mes_anterior (empresa, estado, dt_inicio, dt_final)
    return "
    WITH SQL_RECEITA AS (
            SELECT DISTINCT
                'RECEITA' AS tipo,
                TO_CHAR(debitopago.datapagamento, 'MM/YYYY') AS DATA,
                debito.empresa_id AS idEmpresa,
                cliente.id as idCliente,
                cliente.razaosocial as razaosocialcliente,
                cidade.nome || '-' || estado.sigla as cidade,
                estado.nome || '-' || estado.sigla as estado,
                estado.sigla,
                debitopago.id,
                debitopago.valorrecebido AS valorPago
            FROM
                debitospagos debitopago                
                INNER JOIN debito_debitospagos debito_debitopago ON debito_debitopago.debitopago_id = debitopago.id
                INNER JOIN debitos debito ON debito.id = debito_debitopago.debito_id
                INNER JOIN tipocobrancavalor tipo_valor ON tipo_valor.debito_id = debito.id
                inner join financeiro.clientefornecedorfinanceiro cliente ON cliente.id = debito.clifor_id
                LEFT JOIN tipocobranca tipo ON tipo.id = tipo_valor.tipocobranca_id
                left join municipio cidade on cidade.id = cliente.municipio_id
				        left join estado estado on estado.id = cidade.estado_id
            WHERE debitopago.datapagamento::date BETWEEN '#{dt_inicio}' AND '#{dt_final}'
            AND tipo_valor.tipocobranca_id not in (53, 54, 55, 58, 68, 56, 20, 23, 24, 25, 28, 37, 38, 39, 42, 26, 27, 29, 30, 35)
            AND debitopago.empresa_id in (#{empresa})
            GROUP BY
              idEmpresa,
              debito.id,
              debitopago.id,
              idCliente,
              razaosocialcliente,
              cidade.nome, 
              estado.sigla, 
              estado.nome, 
              debitopago.datapagamento,
              tipo_valor.valor,
              debitopago.valorrecebido,
              debitopago.id,
              debito_debitopago.valor
        ),
        SOMAR_RECEITA AS (
            SELECT
                tipo,
                data,
                sum(valorPago) AS valorpago
            FROM
                SQL_RECEITA
            GROUP BY
                tipo,
                data
            ORDER BY
                data
        ),
        SQL_DESPESAS AS (
            SELECT DISTINCT
                'DESPESA' AS tipo,
                TO_CHAR(despesa.datapagamento, 'MM/YYYY') AS data,
                despesa.empresa_id AS idEmpresa,
                despesa.id AS idDebito,
                tipodespesa.id AS idCobranca,
                tipodespesa.descricao AS nomecobranca,
                0.00::numeric AS saldoDebito,
                despesa.valor AS valorDebito,
                'PAGO' AS status,
                100 AS percentualPago,
                0.00::numeric AS valorJurosTipo,
                despesa.valor AS valorPago
            FROM
                despesa despesa                 
                INNER JOIN tipodespesa tipodespesa ON tipodespesa.id = despesa.tipodespesa_id
                WHERE despesa.datapagamento::date BETWEEN '#{dt_inicio}' AND '#{dt_final}'
                AND despesa.empresa_id in (#{empresa})
            GROUP BY
                idEmpresa,
                despesa.id,
                idCobranca,
                nomecobranca,
                despesa.datapagamento,
                valorDebito
        ),
        SOMAR_DESPESA AS (
            SELECT
                tipo,
                data,
                sum(valorPago) AS valorpago
            FROM
                SQL_DESPESAS
            GROUP BY
                tipo,
                data
            ORDER BY
                data
        )
        SELECT rec.data, rec.valorpago as total_receitas, des.valorpago as total_despesas, rec.valorpago-des.valorpago as resultado
        FROM SOMAR_RECEITA rec
        LEFT JOIN SOMAR_DESPESA des ON des.data = rec.data
        order by rec.data
    "
  end

  def self.get_receitas_12_meses (empresa, script, ordem)
    return "
    WITH meses as (
              select a::date as inicial, (a + INTERVAL'1 month' - INTERVAL'1 day')::date as final
              from generate_series((date_trunc('month', current_date - interval '12 month') + interval '1 month')::date, (date_trunc('month', current_date + interval '1 month') - interval '1 day')::date,INTERVAL'1 month') a
         ),
        SQL_RECEITA AS (
            SELECT DISTINCT
                'RECEITA' AS tipo,
                TO_CHAR(debitopago.datapagamento, 'MM/YYYY') AS DATA,
                debito.empresa_id AS idEmpresa,
                debito.id AS idDebito,
                tipo.id AS idCobranca,
                tipo.nome AS nomecobranca,
                debito.saldo AS saldoDebito,
                debito.valor AS valorDebito,
                debito.status,
                CASE
                    WHEN tipo_valor.valor <> debito.valor THEN round(((tipo_valor.valor * 100)/(case when debito.valor = 0 then 1 else debito.valor end)),2)
                    ELSE 100
                END AS percentualPago,
                coalesce(debito_debitopago.valorjuros,0) as valorJurosTipo,
                SUM(
                  coalesce(debito_debitopago.valor,0) +
                  coalesce(debito_debitopago.valorjuros,0) +
                  coalesce(debito_debitopago.valormulta,0) -
                  coalesce(debito_debitopago.valordesconto,0)
                ) AS valorPago,
                meses.final,
                TO_CHAR(meses.final, 'MM') AS finalFormatado
            FROM
            meses
                INNER JOIN debitospagos debitopago ON debitopago.datapagamento::date BETWEEN meses.inicial AND meses.final
                AND debitopago.empresa_id in (#{empresa})
                INNER JOIN debito_debitospagos debito_debitopago ON debito_debitopago.debitopago_id = debitopago.id
                INNER JOIN debitos debito ON debito.id = debito_debitopago.debito_id
                INNER JOIN tipocobrancavalor tipo_valor ON tipo_valor.debito_id = debito.id
                LEFT JOIN tipocobranca tipo ON tipo.id = tipo_valor.tipocobranca_id
            GROUP BY
                idEmpresa,
                debito.id,
                idCobranca,
                nomecobranca,
                debito.status,
                debitopago.datapagamento,
                valorDebito,
                tipo_valor.valor,
                debito.parcela,
                meses.final,
                debito_debitopago.valor, debito_debitopago.valordesconto, debito_debitopago.valorjuros, debito_debitopago.valormulta
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
              INNER JOIN despesa despesa ON despesa.datapagamento::date BETWEEN meses.inicial AND meses.final
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

  def self.get_receita_12_meses_sistema(empresa, tipo, ordem)
    return "
      WITH contratosId as (
        select max(id), cliente_id from contrato group by cliente_id
      ),
      meses as (
        select a::date as inicial, (a + INTERVAL'1 month' - INTERVAL'1 day')::date as final
        from generate_series((date_trunc('month', current_date - interval '12 month') + interval '1 month')::date, (date_trunc('month', current_date + interval '1 month') - interval '1 day')::date,INTERVAL'1 month') a
      ),
      SQL_RECEITA AS (
          SELECT DISTINCT
              'RECEITA' AS tipo,
              TO_CHAR(debitopago.datapagamento, 'MM/YYYY') AS DATA,
              debito.empresa_id AS idEmpresa,
              debito.id AS idDebito,
              tipo.id AS idCobranca,
              tipo.nome AS nomecobranca,
              debito.saldo AS saldoDebito,
              debito.valor AS valorDebito,
              debito.status,
              CASE
                  WHEN tipo_valor.valor <> debito.valor THEN round(((tipo_valor.valor * 100)/(case when debito.valor = 0 then 1 else debito.valor end)),2)
                  ELSE 100
              END AS percentualPago,
              coalesce(debito_debitopago.valorjuros,0) as valorJurosTipo,
              SUM(
                coalesce(debito_debitopago.valor,0) +
                coalesce(debito_debitopago.valorjuros,0) +
                coalesce(debito_debitopago.valormulta,0) -
                coalesce(debito_debitopago.valordesconto,0)
              ) AS valorPago,
              meses.final,
              sistema.nome as sistema,
              TO_CHAR(meses.final, 'MM') AS finalFormatado
          FROM
          meses
              INNER JOIN debitospagos debitopago ON debitopago.datapagamento::date BETWEEN meses.inicial AND meses.final
              AND debitopago.empresa_id in (#{empresa})
              INNER JOIN debito_debitospagos debito_debitopago ON debito_debitopago.debitopago_id = debitopago.id
              INNER JOIN debitos debito ON debito.id = debito_debitopago.debito_id
              INNER JOIN tipocobrancavalor tipo_valor ON tipo_valor.debito_id = debito.id
              LEFT JOIN tipocobranca tipo ON tipo.id = tipo_valor.tipocobranca_id
              LEFT JOIN contrato on contrato.cliente_id = debito.clifor_id
              LEFT JOIN sistema on sistema.id = contrato.sistema_id
          where tipo.id = #{tipo} AND contrato.id in (select max from contratosId)
          GROUP BY
              idEmpresa,
              debito.id,
              idCobranca,
              nomecobranca,
              debito.status,
              debitopago.datapagamento,
              valorDebito,
              tipo_valor.valor,
              debito.parcela,
      sistema.nome,
              meses.final,
              debito_debitopago.valor, debito_debitopago.valordesconto, debito_debitopago.valorjuros, debito_debitopago.valormulta
      ),
      SOMAR_RECEITA AS (
          SELECT
              idCobranca,
              nomecobranca,
      sistema,
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
      nomecobranca,
      sistema
          ORDER BY
              idCobranca
      )
      select * fROM SOMAR_RECEITA order by #{ordem} desc
    "
  end

  def self.get_outras_receitas_12_meses(empresa)
    return "
    WITH meses as (
        select a::date as inicial, (a + INTERVAL'1 month' - INTERVAL'1 day')::date as final
        from generate_series((date_trunc('month', current_date - interval '12 month') + interval '1 month')::date, (date_trunc('month', current_date + interval '1 month') - interval '1 day')::date,INTERVAL'1 month') a
      ),
      SQL_RECEITA AS (
          SELECT DISTINCT
              'RECEITA' AS tipo,
              TO_CHAR(debitopago.datapagamento, 'MM/YYYY') AS DATA,
              debito.empresa_id AS idEmpresa,
              debito.id AS idDebito,
              tipo.id AS idCobranca,
              tipo.nome AS nomecobranca,
              debito.saldo AS saldoDebito,
              debito.valor AS valorDebito,
              debito.status,
              CASE
                  WHEN tipo_valor.valor <> debito.valor THEN round(((tipo_valor.valor * 100)/(case when debito.valor = 0 then 1 else debito.valor end)),2)
                  ELSE 100
              END AS percentualPago,
              CASE
                  WHEN debito.valor = tipo_valor.valor THEN sum(coalesce(debito_debitopago.valorjuros, 0))
                  ELSE round((sum(coalesce(debito_debitopago.valorjuros, 0))/100) * (CASE
                                                                                          WHEN tipo_valor.valor <> debito.valor THEN round(((tipo_valor.valor * 100)/(case when debito.valor = 0 then 1 else debito.valor end)),2)
                                                                                          ELSE 100
                                                                                      END), 2)
              END AS valorJurosTipo,
              SUM(
                coalesce(debito_debitopago.valor,0) +
                coalesce(debito_debitopago.valorjuros,0) +
                coalesce(debito_debitopago.valormulta,0) -
                coalesce(debito_debitopago.valordesconto,0)
              ) AS valorPago,
              meses.final,
              TO_CHAR(meses.final, 'MM') AS finalFormatado
          FROM
          meses
              INNER JOIN debitospagos debitopago ON debitopago.datapagamento::date BETWEEN meses.inicial AND meses.final
              AND debitopago.empresa_id in (#{empresa})
              INNER JOIN debito_debitospagos debito_debitopago ON debito_debitopago.debitopago_id = debitopago.id
              INNER JOIN debitos debito ON debito.id = debito_debitopago.debito_id
              INNER JOIN tipocobrancavalor tipo_valor ON tipo_valor.debito_id = debito.id
              LEFT JOIN tipocobranca tipo ON tipo.id = tipo_valor.tipocobranca_id
      where tipo.id <> 16 and tipo.id <> 66
          GROUP BY
              idEmpresa,
              debito.id,
              idCobranca,
              nomecobranca,
              debito.status,
              debitopago.datapagamento,
              valorDebito,
              tipo_valor.valor,
              debito.parcela,
              meses.final,
              debito_debitopago.valor, debito_debitopago.valordesconto, debito_debitopago.valorjuros, debito_debitopago.valormulta
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
      )
      select * fROM SOMAR_RECEITA
    "
  end

  def self.acompanhamentos_concluidos_12_meses(empresa, estado_id, vendedor_id, implantador_id)
      return "
            with meses as (
          select a::date as inicial, (a + INTERVAL'1 month' - INTERVAL'1 day')::date as final
          from generate_series((date_trunc('month', current_date - interval '14 month') + interval '1 month')::date, (date_trunc('month', current_date + interval '1 month') - interval '1 day')::date,INTERVAL'1 month') a
        ),
         sql as (
            select 	acompanhamento.id,
              acompanhamento.data_inicio,
              acompanhamento.data_fim,
              acompanhamento.status,
              acompanhamento.empresa_id,
              cliente.razao_social,
              cliente.cnpj,
              proposta.valor_mensalidade as mensalidade,
              proposta.valor_implantacao as implantacao,
              sistema.nome as sistema,
              meses.final,
              'ACOMPANHAMENTO' as tipo
            from meses
            left join acompanhamentos acompanhamento on acompanhamento.data_fim::date between meses.inicial and meses.final and acompanhamento.status = 5 and acompanhamento.empresa_id in (#{ApplicationHelper.get_empresas_by_codigo(empresa)})
            left join clientes cliente on cliente.id = acompanhamento.cliente_id
            left join cidades cidade on cidade.id = cliente.cidade_id
            left join fechamentos f on f.id =  (select max(id) from fechamentos where cliente_id = cliente.id)
            left join implantacoes implantacao on implantacao.id =  (select max(id) from implantacoes where cliente_id = cliente.id)
            left join propostas proposta on proposta.id = (select id from propostas where propostas.cliente_id = cliente.id and propostas.ativa is true order by id desc limit 1)
            left join pacotes pacote on pacote.id = proposta.pacote_id
            left join sistemas sistema on sistema.id = pacote.sistema_id
            where (#{ApplicationHelper.get_estado_by_codigo(estado_id)} is null or #{ApplicationHelper.get_estado_by_codigo(estado_id)} = cidade.estado_id)
              and (#{vendedor_id.blank? ? 'null' : vendedor_id} is null or #{vendedor_id.blank? ? 'null' : vendedor_id} = f.user_id)
              and (#{implantador_id.blank? ? 'null' : implantador_id} is null or #{implantador_id.blank? ? 'null' : implantador_id} = implantacao.user_id)

            union all

            select 	implantacao.id,
              implantacao.data_inicio,
              implantacao.data_fim,
              implantacao.status,
              implantacao.empresa_id,
              cliente.razao_social,
              cliente.cnpj,
              proposta.valor_mensalidade as mensalidade,
              proposta.valor_implantacao as implantacao,
              sistema.nome as sistema,
              meses.final,
              true as efetivo,
              'IMPLANTACAO' as tipo
            from meses
            left join implantacoes implantacao on implantacao.data_fim::date between meses.inicial and meses.final and implantacao.status = 9 and implantacao.empresa_id in (#{ApplicationHelper.get_empresas_by_codigo(empresa)})
            left join acompanhamentos acompanhamento on acompanhamento.cliente_id = implantacao.cliente_id
            left join clientes cliente on cliente.id = implantacao.cliente_id
            left join cidades cidade on cidade.id = cliente.cidade_id
            left join fechamentos f on f.id =  (select max(id) from fechamentos where cliente_id = cliente.id)
            left join propostas proposta on proposta.id = (select id from propostas where propostas.cliente_id = cliente.id and propostas.ativa is true order by id desc limit 1)
            left join pacotes pacote on pacote.id = proposta.pacote_id
            left join sistemas sistema on sistema.id = pacote.sistema_id
            where (#{ApplicationHelper.get_estado_by_codigo(estado_id)} is null or #{ApplicationHelper.get_estado_by_codigo(estado_id)} = cidade.estado_id)
              and acompanhamento.status not in (3,4)
              and (#{vendedor_id.blank? ? 'null' : vendedor_id} is null or #{vendedor_id.blank? ? 'null' : vendedor_id} = f.user_id)
              and (#{implantador_id.blank? ? 'null' : implantador_id} is null or #{implantador_id.blank? ? 'null' : implantador_id} = implantacao.user_id)
        ),
        totais as (
          select 	coalesce(count(sql.id),0) as quantidade,
                  coalesce(sum(sql.mensalidade),0) as mensalidade,
                  coalesce(sum(sql.implantacao),0) as implantacao,
                  sql.final
          from sql
          where sql.efetivo is true
          group by sql.final
        ),
        total_acomp as (
          select 	coalesce(count(sql.id),0) as quantidade,
                  coalesce(sum(sql.mensalidade),0) as mensalidade,
                  coalesce(sum(sql.implantacao),0) as implantacao,
                  sql.final
          from sql
          where tipo = 'ACOMPANHAMENTO'
          group by sql.final
        ),
        totaisSistema as (
          select sql.final, upper(sql.sistema) as sistema, count(id) quantidade
          from sql
          group by sql.final, sql.sistema

        )
        select  TO_CHAR(meses.final, 'MM/YYYY') as data,
          coalesce(totais.quantidade,0) as quantidade,
          coalesce(totais.mensalidade,0) as mensalidade,
          coalesce(totais.implantacao,0) as implantacao,
          case when totais.quantidade = 0 then 0 else ROUND((totais.mensalidade / totais.quantidade),2) end as mediaMensalidade,
          case when totais.quantidade = 0 then 0 else ROUND((totais.implantacao / totais.quantidade),2) end as mediaImplantacao,
          coalesce(emissor.quantidade,0) as emissor,
          coalesce(gourmet.quantidade,0) as gourmet,
          coalesce(manager.quantidade,0) as manager,
          coalesce(ligth.quantidade,0) as light,
          (coalesce(outros.quantidade,0) + coalesce(trade.quantidade,0) + coalesce(web.quantidade,0) + coalesce(provendas.quantidade,0)) as outros,
          coalesce(acomp.quantidade, 0) as total_acomp
        from meses
        left join totais on totais.final = meses.final
        left join totaisSistema emissor on emissor.final = totais.final and emissor.sistema = 'EMISSOR'
        left join totaisSistema gourmet on gourmet.final = totais.final and gourmet.sistema = 'GOURMET'
        left join totaisSistema manager on manager.final = totais.final and manager.sistema = 'MANAGER'
        left join totaisSistema ligth on ligth.final = totais.final and ligth.sistema = 'LIGHT'
        left join totaisSistema trade on trade.final = totais.final and trade.sistema = 'TRADE'
        left join totaisSistema web on web.final = totais.final and web.sistema = 'EMISSOR WEB'
        left join totaisSistema provendas on provendas.final = totais.final and provendas.sistema = 'PRÓ-VENDAS'
        left join totaisSistema outros on outros.final = totais.final and outros.sistema not in ('EMISSOR', 'GOURMET', 'MANAGER', 'LIGHT', 'TRADE', 'EMISSOR WEB', 'PRÓ-VENDAS')
        left join total_acomp acomp on acomp.final = meses.final
        order by meses.final
      "
  end

  def self.acompanhamentos_concluidos_12_meses_mes_anterior(empresa, estado_id, vendedor_id, implantador_id)
    return "
            with meses as (
          select (date_trunc('month',current_date) - interval '1 month')::date as inicial, (current_date - interval '1 month')::date as final
        ),
         sql as (
            select 	acompanhamento.id,
              acompanhamento.data_inicio,
              acompanhamento.data_fim,
              acompanhamento.status,
              acompanhamento.empresa_id,
              cliente.razao_social,
              cliente.cnpj,
              proposta.valor_mensalidade as mensalidade,
              proposta.valor_implantacao as implantacao,
              sistema.nome as sistema,
              meses.final,
              'ACOMPANHAMENTO' as tipo
            from meses
            left join acompanhamentos acompanhamento on acompanhamento.data_fim::date between meses.inicial and meses.final and acompanhamento.status = 5 and acompanhamento.empresa_id in (#{ApplicationHelper.get_empresas_by_codigo(empresa)})
            left join clientes cliente on cliente.id = acompanhamento.cliente_id
            left join cidades cidade on cidade.id = cliente.cidade_id
            left join fechamentos f on f.id =  (select max(id) from fechamentos where cliente_id = cliente.id)
            left join implantacoes implantacao on implantacao.id =  (select max(id) from implantacoes where cliente_id = cliente.id)
            left join propostas proposta on proposta.id = (select id from propostas where propostas.cliente_id = cliente.id and propostas.ativa is true order by id desc limit 1)
            left join pacotes pacote on pacote.id = proposta.pacote_id
            left join sistemas sistema on sistema.id = pacote.sistema_id
            where (#{ApplicationHelper.get_estado_by_codigo(estado_id)} is null or #{ApplicationHelper.get_estado_by_codigo(estado_id)} = cidade.estado_id)
              and (#{vendedor_id.blank? ? 'null' : vendedor_id} is null or #{vendedor_id.blank? ? 'null' : vendedor_id} = f.user_id)
              and (#{implantador_id.blank? ? 'null' : implantador_id} is null or #{implantador_id.blank? ? 'null' : implantador_id} = implantacao.user_id)

            union all

            select 	implantacao.id,
              implantacao.data_inicio,
              implantacao.data_fim,
              implantacao.status,
              implantacao.empresa_id,
              cliente.razao_social,
              cliente.cnpj,
              proposta.valor_mensalidade as mensalidade,
              proposta.valor_implantacao as implantacao,
              sistema.nome as sistema,
              meses.final,
              true as efetivo,
              'IMPLANTACAO' as tipo
            from meses
            left join implantacoes implantacao on implantacao.data_fim::date between meses.inicial and meses.final and implantacao.status = 9 and implantacao.empresa_id in (#{ApplicationHelper.get_empresas_by_codigo(empresa)})
            left join clientes cliente on cliente.id = implantacao.cliente_id
            left join cidades cidade on cidade.id = cliente.cidade_id
            left join fechamentos f on f.id =  (select max(id) from fechamentos where cliente_id = cliente.id)
            left join propostas proposta on proposta.id = (select id from propostas where propostas.cliente_id = cliente.id and propostas.ativa is true order by id desc limit 1)
            left join pacotes pacote on pacote.id = proposta.pacote_id
            left join sistemas sistema on sistema.id = pacote.sistema_id
            where (#{ApplicationHelper.get_estado_by_codigo(estado_id)} is null or #{ApplicationHelper.get_estado_by_codigo(estado_id)} = cidade.estado_id)
              and (#{vendedor_id.blank? ? 'null' : vendedor_id} is null or #{vendedor_id.blank? ? 'null' : vendedor_id} = f.user_id)
              and (#{implantador_id.blank? ? 'null' : implantador_id} is null or #{implantador_id.blank? ? 'null' : implantador_id} = implantacao.user_id)
        ),
        totais as (
          select 	coalesce(count(sql.id),0) as quantidade,
                  coalesce(sum(sql.mensalidade),0) as mensalidade,
                  coalesce(sum(sql.implantacao),0) as implantacao,
                  sql.final
          from sql
          where sql.efetivo is true
          group by sql.final
        ),
        total_acomp as (
          select 	coalesce(count(sql.id),0) as quantidade,
                  coalesce(sum(sql.mensalidade),0) as mensalidade,
                  coalesce(sum(sql.implantacao),0) as implantacao,
                  sql.final
          from sql
          where tipo = 'ACOMPANHAMENTO'
          group by sql.final
        )
        select  TO_CHAR(meses.final, 'MM/YYYY') as data,
          coalesce(totais.quantidade,0) as quantidade,
          coalesce(totais.mensalidade,0) as mensalidade,
          coalesce(totais.implantacao,0) as implantacao,
          case when totais.quantidade = 0 then 0 else ROUND((totais.mensalidade / totais.quantidade),2) end as mediaMensalidade,
          case when totais.quantidade = 0 then 0 else ROUND((totais.implantacao / totais.quantidade),2) end as mediaImplantacao,
          coalesce(acomp.quantidade, 0) as total_acomp
        from meses
        left join totais on totais.final = meses.final
        left join total_acomp acomp on acomp.final = meses.final
        order by meses.final"
  end

  def self.desistencia_12_meses(empresa, estado_id, vendedor_id, implantador_id)
    return "
     with meses as (
        select a::date as inicial, (a + INTERVAL'1 month' - INTERVAL'1 day')::date as final
        from generate_series((date_trunc('month', current_date - interval '14 month') + interval '1 month')::date, (date_trunc('month', current_date + interval '1 month') - interval '1 day')::date,INTERVAL'1 month') a
      ),
       sqlAcompanhamento as (
              select 	acompanhamento.id,
                acompanhamento.data_inicio,
                acompanhamento.data_fim,
                acompanhamento.status,
                acompanhamento.empresa_id,
                cliente.razao_social,
                cliente.cnpj,
                proposta.valor_mensalidade as mensalidade,
                proposta.valor_implantacao as implantacao,
                sistema.nome as sistema,
                'Acompanhamento'::varchar as tipo,
                meses.final
              from meses
              left join acompanhamentos acompanhamento on acompanhamento.data_fim::date between meses.inicial and meses.final and acompanhamento.status in (3,4) and acompanhamento.empresa_id in (#{ApplicationHelper.get_empresas_by_codigo(empresa)})
              left join clientes cliente on cliente.id = acompanhamento.cliente_id
              left join cidades cidade on cidade.id = cliente.cidade_id
              left join fechamentos f on f.id =  (select max(id) from fechamentos where cliente_id = cliente.id)
              left join implantacoes implantacao on implantacao.id =  (select max(id) from implantacoes where cliente_id = cliente.id)
              left join propostas proposta on proposta.id = (select id from propostas where propostas.cliente_id = cliente.id and propostas.ativa is true order by id desc limit 1)
              left join pacotes pacote on pacote.id = proposta.pacote_id
              left join sistemas sistema on sistema.id = pacote.sistema_id
              where (#{ApplicationHelper.get_estado_by_codigo(estado_id)} is null or #{ApplicationHelper.get_estado_by_codigo(estado_id)} = cidade.estado_id)
                and (#{vendedor_id.blank? ? 'null' : vendedor_id} is null or #{vendedor_id.blank? ? 'null' : vendedor_id} = f.user_id)
                and (#{implantador_id.blank? ? 'null' : implantador_id} is null or #{implantador_id.blank? ? 'null' : implantador_id} = implantacao.user_id)
      ),
       sqlImplantacaoPre as (
              select 	implantacao.id,
                implantacao.data_inicio,
                implantacao.data_fim,
                implantacao.status,
                implantacao.empresa_id,
                cliente.razao_social,
                cliente.cnpj,
                proposta.valor_mensalidade as mensalidade,
                proposta.valor_implantacao as implantacao,
                sistema.nome as sistema,
                'Pré Implantação'::varchar as tipo,
                meses.final
              from meses
              left join implantacoes implantacao on implantacao.data_fim::date between meses.inicial and meses.final and implantacao.status in (7) and implantacao.empresa_id in (#{ApplicationHelper.get_empresas_by_codigo(empresa)})
              left join clientes cliente on cliente.id = implantacao.cliente_id
              left join cidades cidade on cidade.id = cliente.cidade_id
              left join fechamentos f on f.id =  (select max(id) from fechamentos where cliente_id = cliente.id)
              left join propostas proposta on proposta.id = (select id from propostas where propostas.cliente_id = cliente.id and propostas.ativa is true order by id desc limit 1)
              left join pacotes pacote on pacote.id = proposta.pacote_id
              left join sistemas sistema on sistema.id = pacote.sistema_id
              where (#{ApplicationHelper.get_estado_by_codigo(estado_id)} is null or #{ApplicationHelper.get_estado_by_codigo(estado_id)} = cidade.estado_id)
                and (#{vendedor_id.blank? ? 'null' : vendedor_id} is null or #{vendedor_id.blank? ? 'null' : vendedor_id} = f.user_id)
                and (#{implantador_id.blank? ? 'null' : implantador_id} is null or #{implantador_id.blank? ? 'null' : implantador_id} = implantacao.user_id)
       ),
        sqlImplantacaoPos as (
              select 	implantacao.id,
                implantacao.data_inicio,
                implantacao.data_fim,
                implantacao.status,
                implantacao.empresa_id,
                cliente.razao_social,
                cliente.cnpj,
                proposta.valor_mensalidade as mensalidade,
                proposta.valor_implantacao as implantacao,
                sistema.nome as sistema,
                'Durante Implantação'::varchar as tipo,
                meses.final
              from meses
              left join implantacoes implantacao on implantacao.data_fim::date between meses.inicial and meses.final and implantacao.status in (8) and implantacao.empresa_id in (#{ApplicationHelper.get_empresas_by_codigo(empresa)})
              left join clientes cliente on cliente.id = implantacao.cliente_id
              left join cidades cidade on cidade.id = cliente.cidade_id
              left join fechamentos f on f.id =  (select max(id) from fechamentos where cliente_id = cliente.id)
              left join propostas proposta on proposta.id = (select id from propostas where propostas.cliente_id = cliente.id and propostas.ativa is true order by id desc limit 1)
              left join pacotes pacote on pacote.id = proposta.pacote_id
              left join sistemas sistema on sistema.id = pacote.sistema_id
              where (#{ApplicationHelper.get_estado_by_codigo(estado_id)} is null or #{ApplicationHelper.get_estado_by_codigo(estado_id)} = cidade.estado_id)
                and (#{vendedor_id.blank? ? 'null' : vendedor_id} is null or #{vendedor_id.blank? ? 'null' : vendedor_id} = f.user_id)
                and (#{implantador_id.blank? ? 'null' : implantador_id} is null or #{implantador_id.blank? ? 'null' : implantador_id} = implantacao.user_id)
       ),
      totaisAcompanhamento as (
        select 	coalesce(count(sql.id),0) as quantidade,
          coalesce(sum(sql.mensalidade),0) as mensalidade,
          coalesce(sum(sql.implantacao),0) as implantacao,
          sql.final
        from sqlAcompanhamento sql
        group by sql.final, sql.tipo
      ),
      totaisImplantacaoPre as (
        select 	coalesce(count(sql.id),0) as quantidade,
          coalesce(sum(sql.mensalidade),0) as mensalidade,
          coalesce(sum(sql.implantacao),0) as implantacao,
          sql.final
        from sqlImplantacaoPre sql
        group by sql.final, sql.tipo
      ),
      totaisImplantacaoPos as (
        select 	coalesce(count(sql.id),0) as quantidade,
          coalesce(sum(sql.mensalidade),0) as mensalidade,
          coalesce(sum(sql.implantacao),0) as implantacao,
          sql.final
        from sqlImplantacaoPos sql
        group by sql.final, sql.tipo
      )

      select    TO_CHAR(meses.final, 'MM/YYYY') as data,
          coalesce(pre.quantidade,0) as qtd_pre,
          coalesce(pre.mensalidade,0) as mens_pre,
          coalesce(pre.implantacao,0) as inst_pre,
          case when pre.quantidade = 0 then 0 else ROUND((pre.mensalidade / pre.quantidade),2) end as pre_media_mens,
          case when pre.quantidade = 0 then 0 else ROUND((pre.implantacao / pre.quantidade),2) end as pre_media_inst,
          coalesce(pos.quantidade,0) as qtd_pos,
          coalesce(pos.mensalidade,0) as mens_pos,
          coalesce(pos.implantacao,0) as inst_pos,
          case when pos.quantidade = 0 then 0 else ROUND((pos.mensalidade / pos.quantidade),2) end as pos_media_mens,
          case when pos.quantidade = 0 then 0 else ROUND((pos.implantacao / pos.quantidade),2) end as pos_media_inst,
          coalesce(acomp.quantidade,0) as qtd_acomp,
          coalesce(acomp.mensalidade,0) as mens_acomp,
          coalesce(acomp.implantacao,0) as inst_acomp,
          case when acomp.quantidade = 0 then 0 else ROUND((acomp.mensalidade / acomp.quantidade),2) end as acomp_media_mens,
          case when acomp.quantidade = 0 then 0 else ROUND((acomp.implantacao / acomp.quantidade),2) end as acomp_media_inst
      from meses
      left join totaisImplantacaoPre pre on pre.final = meses.final
      left join totaisImplantacaoPos pos on pos.final = meses.final
      left join totaisAcompanhamento acomp on acomp.final = meses.final
      order by meses.final

    "
  end

  def self.desistencia_12_meses_mes_anterior(empresa, estado_id, vendedor_id, implantador_id)
    return "
     with meses as (
      select (date_trunc('month',current_date) - interval '1 month')::date as inicial, (current_date - interval '1 month')::date as final
      ),
       sqlAcompanhamento as (
              select 	acompanhamento.id,
                acompanhamento.data_inicio,
                acompanhamento.data_fim,
                acompanhamento.status,
                acompanhamento.empresa_id,
                cliente.razao_social,
                cliente.cnpj,
                proposta.valor_mensalidade as mensalidade,
                proposta.valor_implantacao as implantacao,
                sistema.nome as sistema,
                'Acompanhamento'::varchar as tipo,
                meses.final
              from meses
              left join acompanhamentos acompanhamento on acompanhamento.data_fim::date between meses.inicial and meses.final and acompanhamento.status in (3,4) and acompanhamento.empresa_id in (#{ApplicationHelper.get_empresas_by_codigo(empresa)})
              left join clientes cliente on cliente.id = acompanhamento.cliente_id
              left join cidades cidade on cidade.id = cliente.cidade_id
              left join fechamentos f on f.id =  (select max(id) from fechamentos where cliente_id = cliente.id)
              left join implantacoes implantacao on implantacao.id =  (select max(id) from implantacoes where cliente_id = cliente.id)
              left join propostas proposta on proposta.id = (select id from propostas where propostas.cliente_id = cliente.id and propostas.ativa is true order by id desc limit 1)
              left join pacotes pacote on pacote.id = proposta.pacote_id
              left join sistemas sistema on sistema.id = pacote.sistema_id
              where (#{ApplicationHelper.get_estado_by_codigo(estado_id)} is null or #{ApplicationHelper.get_estado_by_codigo(estado_id)} = cidade.estado_id)
                and (#{vendedor_id.blank? ? 'null' : vendedor_id} is null or #{vendedor_id.blank? ? 'null' : vendedor_id} = f.user_id)
                and (#{implantador_id.blank? ? 'null' : implantador_id} is null or #{implantador_id.blank? ? 'null' : implantador_id} = implantacao.user_id)
      ),
       sqlImplantacaoPre as (
              select 	implantacao.id,
                implantacao.data_inicio,
                implantacao.data_fim,
                implantacao.status,
                implantacao.empresa_id,
                cliente.razao_social,
                cliente.cnpj,
                proposta.valor_mensalidade as mensalidade,
                proposta.valor_implantacao as implantacao,
                sistema.nome as sistema,
                'Pré Implantação'::varchar as tipo,
                meses.final
              from meses
              left join implantacoes implantacao on implantacao.data_fim::date between meses.inicial and meses.final and implantacao.status in (7) and implantacao.empresa_id in (#{ApplicationHelper.get_empresas_by_codigo(empresa)})
              left join clientes cliente on cliente.id = implantacao.cliente_id
              left join cidades cidade on cidade.id = cliente.cidade_id
              left join fechamentos f on f.id =  (select max(id) from fechamentos where cliente_id = cliente.id)
              left join propostas proposta on proposta.id = (select id from propostas where propostas.cliente_id = cliente.id and propostas.ativa is true order by id desc limit 1)
              left join pacotes pacote on pacote.id = proposta.pacote_id
              left join sistemas sistema on sistema.id = pacote.sistema_id
              where (#{ApplicationHelper.get_estado_by_codigo(estado_id)} is null or #{ApplicationHelper.get_estado_by_codigo(estado_id)} = cidade.estado_id)
                and (#{vendedor_id.blank? ? 'null' : vendedor_id} is null or #{vendedor_id.blank? ? 'null' : vendedor_id} = f.user_id)
                and (#{implantador_id.blank? ? 'null' : implantador_id} is null or #{implantador_id.blank? ? 'null' : implantador_id} = implantacao.user_id)
       ),
        sqlImplantacaoPos as (
              select 	implantacao.id,
                implantacao.data_inicio,
                implantacao.data_fim,
                implantacao.status,
                implantacao.empresa_id,
                cliente.razao_social,
                cliente.cnpj,
                proposta.valor_mensalidade as mensalidade,
                proposta.valor_implantacao as implantacao,
                sistema.nome as sistema,
                'Durante Implantação'::varchar as tipo,
                meses.final
              from meses
              left join implantacoes implantacao on implantacao.data_fim::date between meses.inicial and meses.final and implantacao.status in (8) and implantacao.empresa_id in (#{ApplicationHelper.get_empresas_by_codigo(empresa)})
              left join clientes cliente on cliente.id = implantacao.cliente_id
              left join cidades cidade on cidade.id = cliente.cidade_id
              left join fechamentos f on f.id =  (select max(id) from fechamentos where cliente_id = cliente.id)
              left join propostas proposta on proposta.id = (select id from propostas where propostas.cliente_id = cliente.id and propostas.ativa is true order by id desc limit 1)
              left join pacotes pacote on pacote.id = proposta.pacote_id
              left join sistemas sistema on sistema.id = pacote.sistema_id
              where (#{ApplicationHelper.get_estado_by_codigo(estado_id)} is null or #{ApplicationHelper.get_estado_by_codigo(estado_id)} = cidade.estado_id)
                and (#{vendedor_id.blank? ? 'null' : vendedor_id} is null or #{vendedor_id.blank? ? 'null' : vendedor_id} = f.user_id)
                and (#{implantador_id.blank? ? 'null' : implantador_id} is null or #{implantador_id.blank? ? 'null' : implantador_id} = implantacao.user_id)
       ),
      totaisAcompanhamento as (
        select 	coalesce(count(sql.id),0) as quantidade,
          coalesce(sum(sql.mensalidade),0) as mensalidade,
          coalesce(sum(sql.implantacao),0) as implantacao,
          sql.final
        from sqlAcompanhamento sql
        group by sql.final, sql.tipo
      ),
      totaisImplantacaoPre as (
        select 	coalesce(count(sql.id),0) as quantidade,
          coalesce(sum(sql.mensalidade),0) as mensalidade,
          coalesce(sum(sql.implantacao),0) as implantacao,
          sql.final
        from sqlImplantacaoPre sql
        group by sql.final, sql.tipo
      ),
      totaisImplantacaoPos as (
        select 	coalesce(count(sql.id),0) as quantidade,
          coalesce(sum(sql.mensalidade),0) as mensalidade,
          coalesce(sum(sql.implantacao),0) as implantacao,
          sql.final
        from sqlImplantacaoPos sql
        group by sql.final, sql.tipo
      )

      select    TO_CHAR(meses.final, 'MM/YYYY') as data,
          coalesce(pre.quantidade,0) as qtd_pre,
          coalesce(pre.mensalidade,0) as mens_pre,
          coalesce(pre.implantacao,0) as inst_pre,
          case when pre.quantidade = 0 then 0 else ROUND((pre.mensalidade / pre.quantidade),2) end as pre_media_mens,
          case when pre.quantidade = 0 then 0 else ROUND((pre.implantacao / pre.quantidade),2) end as pre_media_inst,
          coalesce(pos.quantidade,0) as qtd_pos,
          coalesce(pos.mensalidade,0) as mens_pos,
          coalesce(pos.implantacao,0) as inst_pos,
          case when pos.quantidade = 0 then 0 else ROUND((pos.mensalidade / pos.quantidade),2) end as pos_media_mens,
          case when pos.quantidade = 0 then 0 else ROUND((pos.implantacao / pos.quantidade),2) end as pos_media_inst,
          coalesce(acomp.quantidade,0) as qtd_acomp,
          coalesce(acomp.mensalidade,0) as mens_acomp,
          coalesce(acomp.implantacao,0) as inst_acomp,
          case when acomp.quantidade = 0 then 0 else ROUND((acomp.mensalidade / acomp.quantidade),2) end as acomp_media_mens,
          case when acomp.quantidade = 0 then 0 else ROUND((acomp.implantacao / acomp.quantidade),2) end as acomp_media_inst
      from meses
      left join totaisImplantacaoPre pre on pre.final = meses.final
      left join totaisImplantacaoPos pos on pos.final = meses.final
      left join totaisAcompanhamento acomp on acomp.final = meses.final
      order by meses.final

    "
  end

  def self.fechamentos_12_meses(empresa, estado_id, vendedor_id)
    return "
     with meses as (
          select a::date as inicial, (a + INTERVAL'1 month' - INTERVAL'1 day')::date as final
          from generate_series((date_trunc('month', current_date - interval '14 month') + interval '1 month')::date, (date_trunc('month', current_date + interval '1 month') - interval '1 day')::date,INTERVAL'1 month') a
        ),
         sql as (
        select 	fechamento.id,
          fechamento.data_fechamento,
          fechamento.status_id,
          fechamento.empresa_id,
          cliente.razao_social,
          cliente.cnpj,
          proposta.valor_mensalidade as mensalidade,
          proposta.valor_implantacao as implantacao,
          sistema.nome as sistema,
          meses.final
        from meses
        left join fechamentos fechamento on fechamento.data_fechamento::date between meses.inicial and meses.final and fechamento.empresa_id in (#{ApplicationHelper.get_empresas_by_codigo(empresa)})
        left join clientes cliente on cliente.id = fechamento.cliente_id
        left join cidades cidade on cidade.id = cliente.cidade_id
        left join fechamentos f on f.id =  (select max(id) from fechamentos where cliente_id = cliente.id)
        left join propostas proposta on proposta.id = (select id from propostas where propostas.cliente_id = cliente.id and propostas.ativa is true order by id desc limit 1)
        left join pacotes pacote on pacote.id = proposta.pacote_id
        left join sistemas sistema on sistema.id = pacote.sistema_id
        where (#{ApplicationHelper.get_estado_by_codigo(estado_id)} is null or #{ApplicationHelper.get_estado_by_codigo(estado_id)} = cidade.estado_id)
          and (#{vendedor_id.blank? ? 'null' : vendedor_id} is null or #{vendedor_id.blank? ? 'null' : vendedor_id} = fechamento.user_id)
        ),
        totais as (
          select 	coalesce(count(sql.id),0) as quantidade,
			coalesce(sum(sql.mensalidade),0) as mensalidade,
			coalesce(sum(sql.implantacao),0) as implantacao,
			sql.final
          from sql
          group by sql.final
        ),
        totaisSistema as (
          select sql.final, upper(sql.sistema) as sistema, count(id) quantidade
          from sql
          group by sql.final, sql.sistema

        )
        select  TO_CHAR(meses.final, 'MM/YYYY') as data,
          coalesce(totais.quantidade,0) as quantidade,
          coalesce(totais.mensalidade,0) as mensalidade,
          coalesce(totais.implantacao,0) as implantacao,
          case when totais.quantidade = 0 then 0 else ROUND((totais.mensalidade / totais.quantidade),2) end as mediaMensalidade,
          case when totais.quantidade = 0 then 0 else ROUND((totais.implantacao / totais.quantidade),2) end as mediaImplantacao,
          coalesce(emissor.quantidade,0) as emissor,
          coalesce(gourmet.quantidade,0) as gourmet,
          coalesce(manager.quantidade,0) as manager,
          coalesce(ligth.quantidade,0) as light,
          (coalesce(outros.quantidade,0) + coalesce(trade.quantidade,0) + coalesce(web.quantidade,0) + coalesce(provendas.quantidade,0)) as outros
        from meses
        left join totais on totais.final = meses.final
        left join totaisSistema emissor on emissor.final = totais.final and emissor.sistema = 'EMISSOR'
        left join totaisSistema gourmet on gourmet.final = totais.final and gourmet.sistema = 'GOURMET'
        left join totaisSistema manager on manager.final = totais.final and manager.sistema = 'MANAGER'
        left join totaisSistema ligth on ligth.final = totais.final and ligth.sistema = 'LIGHT'
        left join totaisSistema trade on trade.final = totais.final and trade.sistema = 'TRADE'
        left join totaisSistema web on web.final = totais.final and web.sistema = 'EMISSOR WEB'
        left join totaisSistema provendas on provendas.final = totais.final and provendas.sistema = 'PRÓ-VENDAS'
        left join totaisSistema outros on outros.final = totais.final and outros.sistema not in ('EMISSOR', 'GOURMET', 'MANAGER', 'LIGHT', 'TRADE', 'EMISSOR WEB', 'PRÓ-VENDAS')
        order by meses.final
    "
  end

  def self.fechamentos_12_meses_mes_anterior(empresa, estado_id, vendedor_id)
    return "
     with meses as (
        select (date_trunc('month',current_date) - interval '1 month')::date as inicial, (current_date - interval '1 month')::date as final
        ),
         sql as (
        select 	fechamento.id,
          fechamento.data_fechamento,
          fechamento.status_id,
          fechamento.empresa_id,
          cliente.razao_social,
          cliente.cnpj,
          proposta.valor_mensalidade as mensalidade,
          proposta.valor_implantacao as implantacao,
          sistema.nome as sistema,
          meses.final
        from meses
        left join fechamentos fechamento on fechamento.data_fechamento::date between meses.inicial and meses.final and fechamento.empresa_id in (#{ApplicationHelper.get_empresas_by_codigo(empresa)})
        left join clientes cliente on cliente.id = fechamento.cliente_id
        left join cidades cidade on cidade.id = cliente.cidade_id
        left join fechamentos f on f.id =  (select max(id) from fechamentos where cliente_id = cliente.id)
        left join propostas proposta on proposta.id = (select id from propostas where propostas.cliente_id = cliente.id and propostas.ativa is true order by id desc limit 1)
        left join pacotes pacote on pacote.id = proposta.pacote_id
        left join sistemas sistema on sistema.id = pacote.sistema_id
        where (#{ApplicationHelper.get_estado_by_codigo(estado_id)} is null or #{ApplicationHelper.get_estado_by_codigo(estado_id)} = cidade.estado_id)
          and (#{vendedor_id.blank? ? 'null' : vendedor_id} is null or #{vendedor_id.blank? ? 'null' : vendedor_id} = fechamento.user_id)
        ),
        totais as (
          select 	coalesce(count(sql.id),0) as quantidade,
			coalesce(sum(sql.mensalidade),0) as mensalidade,
			coalesce(sum(sql.implantacao),0) as implantacao,
			sql.final
          from sql
          group by sql.final
        )
        select  TO_CHAR(meses.final, 'MM/YYYY') as data,
          coalesce(totais.quantidade,0) as quantidade,
          coalesce(totais.mensalidade,0) as mensalidade,
          coalesce(totais.implantacao,0) as implantacao,
          case when totais.quantidade = 0 then 0 else ROUND((totais.mensalidade / totais.quantidade),2) end as mediaMensalidade,
          case when totais.quantidade = 0 then 0 else ROUND((totais.implantacao / totais.quantidade),2) end as mediaImplantacao
        from meses
        left join totais on totais.final = meses.final
        order by meses.final
    "
  end

  def self.top_vendedores_acompanhamentos(data_inicio, data_fim, estado, empresa, tipo)
    return "with parametros as (
            select '#{data_inicio}'::date as dataInicio,
              '#{data_fim}'::date as dataFim,
              #{ estado.present? ? (ApplicationHelper.get_estado_by_codigo(estado)) : 'null'}::int as estado
          ),
      sql as (
        select 	acompanhamento.id,
          acompanhamento.data_inicio,
          acompanhamento.data_fim,
          acompanhamento.status,
          acompanhamento.empresa_id,
          cliente.razao_social,
          cliente.cnpj,
          proposta.valor_mensalidade as mensalidade,
          proposta.valor_implantacao as implantacao,
          usuario.name as user,
          usuario.id as user_id
      from acompanhamentos acompanhamento
      inner join parametros on true
      left join clientes cliente on cliente.id = acompanhamento.cliente_id
      left join cidades cidade on cidade.id = cliente.cidade_id
      left join implantacoes implantacao on implantacao.id =  (select max(id) from implantacoes where cliente_id = cliente.id)
      left join fechamentos f on f.id =  (select max(id) from fechamentos where cliente_id = cliente.id)
      left join users usuario on usuario.id = #{tipo == '1' ? 'f.user_id' : 'implantacao.user_id' }
      left join propostas proposta on proposta.id = (select id from propostas where propostas.cliente_id = cliente.id and propostas.ativa is true order by id desc limit 1)
      where acompanhamento.data_fim::date between parametros.dataInicio and parametros.dataFim
        and acompanhamento.status = 5
        and acompanhamento.empresa_id in (#{ApplicationHelper.get_empresas_by_codigo(empresa)})
        and (parametros.estado is null or parametros.estado = cidade.estado_id)

      UNION ALL

      select 	implantacao.id,
              implantacao.data_inicio,
              implantacao.data_fim,
              implantacao.status,
              implantacao.empresa_id,
              cliente.razao_social,
              cliente.cnpj,
              proposta.valor_mensalidade as mensalidade,
              proposta.valor_implantacao as implantacao,
              usuario.name as user,
              usuario.id as user_id
      from implantacoes implantacao
      inner join parametros on true
            left join clientes cliente on cliente.id = implantacao.cliente_id
            left join cidades cidade on cidade.id = cliente.cidade_id
            left join fechamentos f on f.id =  (select max(id) from fechamentos where cliente_id = cliente.id)
            left join users usuario on usuario.id = #{tipo == '1' ? 'f.user_id' : 'implantacao.user_id' }
            left join propostas proposta on proposta.id = (select id from propostas where propostas.cliente_id = cliente.id and propostas.ativa is true order by id desc limit 1)
            where implantacao.data_fim::date between parametros.dataInicio and parametros.dataFim
        and implantacao.status = 9
        and implantacao.empresa_id in (#{ApplicationHelper.get_empresas_by_codigo(empresa)})
        and (parametros.estado is null or parametros.estado = cidade.estado_id)
    ),
    totais as (
              select 	coalesce(count(sql.id),0) as quantidade,
          coalesce(sum(sql.mensalidade),0) as mensalidade,
          coalesce(sum(sql.implantacao),0) as implantacao,
          sql.user,
          sql.user_id
              from sql
              group by sql.user, sql.user_id
    )
    select *
    from totais
    order by totais.quantidade desc, totais.mensalidade desc
    "
  end

  def self.top_vendedores_implantacoes(data_inicio, data_fim, estado, empresa, tipo)
    return "with parametros as (
            select '#{data_inicio}'::date as dataInicio,
              '#{data_fim}'::date as dataFim,
              #{ estado.present? ? (ApplicationHelper.get_estado_by_codigo(estado)) : 'null'}::int as estado
          ),
      sql as (
        select 	implantacao.id,
          implantacao.data_inicio,
          implantacao.data_fim,
          implantacao.status,
          implantacao.empresa_id,
          cliente.razao_social,
          cliente.cnpj,
          proposta.valor_mensalidade as mensalidade,
          proposta.valor_implantacao as implantacao,
          usuario.name as user,
          usuario.id as user_id
      from implantacoes implantacao
      inner join parametros on true
            left join clientes cliente on cliente.id = implantacao.cliente_id
            left join cidades cidade on cidade.id = cliente.cidade_id
            left join fechamentos f on f.id =  (select max(id) from fechamentos where cliente_id = cliente.id)
            left join users usuario on usuario.id = #{tipo == '1' ? 'f.user_id' : 'implantacao.user_id' }
            left join propostas proposta on proposta.id = (select id from propostas where propostas.cliente_id = cliente.id and propostas.ativa is true order by id desc limit 1)
            where implantacao.data_fim::date between parametros.dataInicio and parametros.dataFim
        and implantacao.status = 9
        and implantacao.empresa_id in (#{ApplicationHelper.get_empresas_by_codigo(empresa)})
        and (parametros.estado is null or parametros.estado = cidade.estado_id)
    ),
    totais as (
              select 	coalesce(count(sql.id),0) as quantidade,
          coalesce(sum(sql.mensalidade),0) as mensalidade,
          coalesce(sum(sql.implantacao),0) as implantacao,
          sql.user,
          sql.user_id
              from sql
              group by sql.user, sql.user_id
    )
    select *
    from totais
    order by totais.quantidade desc, totais.mensalidade desc
    "
  end

  def self.get_projecao_honorario_12_meses(estado, empresa, tipo)
    return "
      with meses as (
          select (date_trunc('month',(a + INTERVAL'1 month' - INTERVAL'1 day')::date))::date as inicial,
		  (a + INTERVAL'1 month' - INTERVAL'1 day')::date as final,
                    #{ estado.present? ? estado : 'null'}::int as estado
          from generate_series((date_trunc('month', current_date - interval '11 month') + interval '1 month')::date, (date_trunc('month', current_date + interval '2 month') - interval '1 day')::date,INTERVAL'1 month') a
        ),
      SQL AS (
        SELECT date_trunc('month', honorario.datavencimento)::date AS competencia,
                                    to_char( date_trunc('month', honorario.datavencimento)::date, 'MM/YYYY') as competencia_desc,
                                    honorario.datavencimento,
                                    honorario.descricao,
                                    honorario.id,
                                    0 AS tipo,
                                    honorario.valor,
                                    cliente.cpfcnpj,
                                    cliente.razaosocial,
                                    (cidade.nome || '-' || estado.sigla) AS cidade,
                                    meses.inicial,
                                    meses.final
                   FROM meses
                   LEFT JOIN honorariomensal honorario ON honorario.datavencimento BETWEEN meses.inicial AND meses.final
                   INNER JOIN financeiro.clientefornecedorfinanceiro cliente ON cliente.id = honorario.clifor_id
                   LEFT JOIN municipio cidade ON cidade.id = cliente.municipio_id
                   LEFT JOIN estado ON estado.id = cidade.estado_id
                   WHERE honorario.empresa_id in (17)
                     AND honorario.tipo_id = 16
                     AND honorario.ativo IS TRUE
                     AND (meses.estado IS NULL OR meses.estado = estado.id) )

                SELECT meses.final,
                      TO_CHAR(meses.final, 'MM/YYYY') as data,
                      count(sql.id) as qtd,
                      coalesce(sum(sql.valor),0) as valorTotal,
                      coalesce(ROUND(sum(sql.valor)/count(sql.id),2),0) as media
				from meses
                left join sql on sql.final = meses.final
                group by meses.final
                order by meses.final
    "
  end


  def self.get_projecao_instalacao_6_meses(estado, empresa)
    return "
    with meses as (
      select (date_trunc('month',(a + INTERVAL'1 month' - INTERVAL'1 day')::date))::date as inicial,
        (a + INTERVAL'1 month' - INTERVAL'1 day')::date as final,
          #{ estado.present? ? estado : 'null'}::int as estado
      from generate_series((date_trunc('month', current_date - interval '1 month') + interval '1 month')::date, (date_trunc('month', current_date + interval '3 month') - interval '1 day')::date,INTERVAL'1 month') a
    ),

      primeira_parcela_instalacao as (
        SELECT  d.id as idDebito,
            coalesce(boleto.datavencimento, d.datavencimento) as datavencimento,
            coalesce(d.parcela,1) as parcela,
            d.clifor_id,
            debitopago.datapagamento
        FROM debitos d
        inner join financeiro.clientefornecedorfinanceiro c ON c.id = d.clifor_id and c.parceiro is false
        inner join tipocobrancavalor tcv on tcv.debito_id = d.id and tcv.tipocobranca_id = 66
        left join boletogerado boleto on boleto.id = d.boletogerado_id
        left join debito_debitospagos debito_debitopago on debito_debitopago.debito_id = d.id
        left join debitospagos debitopago on debitopago.id = debito_debitopago.debitopago_id
        WHERE d.empresa_id in (17,3253)
          and d.status in ('PENDENTE', 'PAGO', 'PARCIALMENTE_PAGO')
          and coalesce(d.parcela,1) = 1
        group by d.id, coalesce(boleto.datavencimento, d.datavencimento), parcela, d.clifor_id, debitopago.datapagamento
      ),
    sqlInstalacaoPrimeira as (
              select 	debito.id,
                debito.empresa_id as empresa_id,
                cliente.id as clifor_id,
                cliente.razaosocial,
                cidade.nome,
                (estado.nome || '-' || estado.sigla) as estado,
                estado.sigla,
                pri_parcela.datavencimento,
                debito.valor,
                debito.status as status,
                tcv.valor as valorTipo,
                coalesce(debito.parcela,1) as parcela,
                meses.final,
                meses.inicial
              from meses
              inner join primeira_parcela_instalacao pri_parcela on pri_parcela.datavencimento between meses.inicial and meses.final
              INNER JOIN debitos debito on debito.id = pri_parcela.idDebito
              inner join tipocobrancavalor tcv on tcv.debito_id = debito.id and tcv.tipocobranca_id = 66
              inner join financeiro.clientefornecedorfinanceiro cliente ON cliente.id = debito.clifor_id
              left join municipio cidade on cidade.id = cliente.municipio_id
              left join estado on estado.id = cidade.estado_id
              left join boletogerado boleto on boleto.id = debito.boletogerado_id
              where debito.empresa_id in (17,3253)
              and coalesce(debito.parcela,1) = 1
              and (meses.estado is null or meses.estado = estado.id)
              group by debito.id,
                debito.empresa_id,
                cliente.id,
                cliente.razaosocial,
                cidade.nome,
                (estado.nome || '-' || estado.sigla),
                estado.sigla,
                pri_parcela.datavencimento,
                debito.valor,
                debito.status,
                tcv.valor,
                coalesce(debito.parcela,1),
                meses.final,
                meses.inicial
    ),
    sqlInstalacao as (
              select 	debito.id,
                debito.empresa_id as empresa_id,
                cliente.id as clifor_id,
                cliente.razaosocial,
                cidade.nome,
                (estado.nome || '-' || estado.sigla) as estado,
                estado.sigla,
                coalesce(boleto.datavencimento, debito.datavencimento) as datavencimento,
                debito.valor,
                debito.status as status,
                tcv.valor as valorTipo,
                coalesce(debito.parcela,1) as parcela,
                estado.id as estado_id
        FROM DEBITOS debito
              inner join tipocobrancavalor tcv on tcv.debito_id = debito.id and tcv.tipocobranca_id = 66
              inner join financeiro.clientefornecedorfinanceiro cliente ON cliente.id = debito.clifor_id
              left join municipio cidade on cidade.id = cliente.municipio_id
              left join estado on estado.id = cidade.estado_id
              left join boletogerado boleto on boleto.id = debito.boletogerado_id
              where debito.empresa_id in (17,3253)
              and debito.status in ('PENDENTE', 'PAGO', 'PARCIALMENTE_PAGO')
              group by debito.id,
                debito.empresa_id,
                cliente.id,
                cliente.razaosocial,
                cidade.nome,
                (estado.nome || '-' || estado.sigla),
                estado.sigla,
                coalesce(boleto.datavencimento, debito.datavencimento) ,
                debito.valor,
                debito.status,
                tcv.valor,
                estado.id
    ),
     qtdClienteInstalacao as (
      select distinct meses.final, debito.clifor_id
      from meses
      left join sqlInstalacao debito on debito.datavencimento between meses.inicial and meses.final
      where (meses.estado is null or meses.estado = debito.estado_id)
    ),
    qtdTotalClienteInstalacao as(
      select final, count(clifor_id) as qtd_cliente
      from qtdClienteInstalacao
      group by final
    ),
	clientesInstalacao as (
	  select *
      from meses
      left join sqlInstalacao debito on debito.datavencimento between meses.inicial and meses.final
      where (meses.estado is null or meses.estado = debito.estado_id)
	),
    sqlInstalacaoMeses as(

      select meses.final,
        sum(valortipo) as total,
        count(id) as qtd,
        cli.qtd_cliente
      from meses
      left join clientesInstalacao debito on debito.datavencimento between meses.inicial and meses.final
      left join qtdTotalClienteInstalacao cli on cli.final = meses.final
      group by meses.final, cli.qtd_cliente
      order by meses.final
    ),
    qtdClientePrimeiraInstalacao as (
      select distinct final, clifor_id
      from sqlInstalacaoPrimeira
    ),
    qtdTotalClientePrimeiraInstalacao as (
       select 	sql.final,
             count(clifor_id) as qtd_cliente
      from qtdClientePrimeiraInstalacao sql
      group by sql.final
    ),
    sqlInstalacaoPrimeiraMeses as (

      select 	sql.final,
        sum(valortipo) as total,
        count(id) as qtd,
        cli.qtd_cliente
      from sqlInstalacaoPrimeira sql
      left join qtdTotalClientePrimeiraInstalacao cli on cli.final = sql.final
      group by sql.final, cli.qtd_cliente
      order by sql.final
    )

    select meses.final,
           TO_CHAR(meses.final, 'MM/YYYY') as data,
           coalesce(primeira.qtd,0) as primeiraQtd,
           coalesce(primeira.total,0) as primeiraTotal,
           coalesce(insta.qtd,0) as todasQtd,
           coalesce(insta.total,0) as todasTotal,
           coalesce(primeira.qtd_cliente, 0) as qtdClientePrimeira,
           coalesce(insta.qtd_cliente, 0) as qtdClienteTotal

    from meses
    left join sqlInstalacaoPrimeiraMeses primeira on primeira.final = meses.final
    left join sqlInstalacaoMeses insta on insta.final = meses.final
    "
  end

  def self.get_projecao_recebimento(estado, empresa, qtd_mes_analise)
    return "
    with recursive projecao as(
	    with parametros as (
        select #{ estado.present? ? estado : 'null'}::int as estado
      ),
      debitos as (
        SELECT distinct
           debito.empresa_id as idEmpresa,
           debito.id as idDebito,
           debitopago.datapagamento,
          tipo.id as idCobranca,
          tipo.nome as nomecobranca,
          (date_trunc('month', debitopago.datapagamento))::date as mes,
           sum(coalesce(debito_debitopago.valor,0)) as valorpagodebito,
           sum(coalesce(debito_debitopago.valordesconto,0)) as valordescontodebito,
           sum(coalesce(debito_debitopago.valorjuros,0)) as valorjurosdebito,
           sum(coalesce(debito_debitopago.valorjuros,0) + coalesce(debito_debitopago.valor,0)) as valortotalpagodebito
        FROM debitospagos debitopago
        join parametros on true
        inner JOIN debito_debitospagos debito_debitopago ON debito_debitopago.debitopago_id = debitopago.id
        inner join debitos debito on debito.id = debito_debitopago.debito_id
        inner join tipocobrancavalor tipo_valor on tipo_valor.debito_id = debito.id
        inner join financeiro.clientefornecedorfinanceiro cliente ON cliente.id = debito.clifor_id
        LEFT JOIN tipocobranca tipo ON tipo.id = tipo_valor.tipocobranca_id
        left join municipio cidade on cidade.id = cliente.municipio_id
        left join estado estado on estado.id = cidade.estado_id
        where (parametros.estado is null or parametros.estado = estado.id)
          and debitopago.empresa_id in (#{empresa})
          and (debitopago.datapagamento::date <= (date_trunc('month', current_date) - INTERVAL'1 day')::date )
          and (debitopago.datapagamento::date >= (date_trunc('month', current_date - INTERVAL'12 month'))::date )
        group by idEmpresa, debito.id, debito.status, debitopago.datapagamento,
                    tipo.id, tipo.nome, tipo_valor.valor, debito.parcela, cidade.nome, estado.sigla, estado.nome
        ),
        valorMes as (
          select sum(valortotalpagodebito) as valor,
                 mes,
                 TO_CHAR(mes, 'MM/YYYY') as data
          from debitos
          group by mes
          order by mes desc
        ),
        valorAtual as (
		      select *
		       from valorMes limit 1
        ),
        valorCalculo as (
          select *
          from valorMes limit 1 offset #{qtd_mes_analise - 1}
        )
        select ROUND((((valorAtual.valor/valorCalculo.valor)^(1/#{qtd_mes_analise - 1}.00))-1)*100,2) as percentual, valorAtual.valor, valorAtual.mes, TO_CHAR((valorAtual.mes)::date, 'MM/YYYY') as data,1 as qtd_mes
        from valorAtual
        left join valorCalculo on true

      union all

      select 	projecao.percentual,
        ROUND((projecao.valor + (projecao.valor/100) * projecao.percentual), 2),
        (projecao.mes + interval '1 month')::date,
        TO_CHAR((projecao.mes + interval '1 month')::date, 'MM/YYYY') as data,
        projecao.qtd_mes + 1
        from projecao
        where projecao.qtd_mes < 6
      )
        select *
        from projecao

    "
  end

  def self.get_projecao_faturamento(estado, empresa, qtd_mes_analise)
    return "
        with recursive projecao as(
          with parametros as (
                select #{ estado.present? ? estado : 'null'}::int as estado
              ),
              debitos as (
                SELECT distinct
                   debito.empresa_id as idEmpresa,
                   debito.id as idDebito,
                   coalesce(boleto.datavencimento, debito.datavencimento) as datavencimento,

                  (date_trunc('month', coalesce(boleto.datavencimento, debito.datavencimento)))::date as mes,
                   debito.valor
                FROM debitos debito
                join parametros on true
                inner join financeiro.clientefornecedorfinanceiro cliente ON cliente.id = debito.clifor_id
                left join municipio cidade on cidade.id = cliente.municipio_id
                left join estado estado on estado.id = cidade.estado_id
                left join boletogerado boleto on boleto.id = debito.boletogerado_id
                where (parametros.estado is null or parametros.estado = estado.id)
                  and debito.empresa_id in (#{empresa})
                  and debito.status in ('PAGO', 'PENDENTE', 'PARCIALMENTE_PAGO')
                  and (coalesce(boleto.datavencimento, debito.datavencimento) <= (date_trunc('month', current_date) - INTERVAL'1 day')::date )
                  and (coalesce(boleto.datavencimento, debito.datavencimento) >= (date_trunc('month', current_date - INTERVAL'12 month'))::date )
                ),
                valorMes as (
                  select sum(valor) as valor,
                         mes,
                         TO_CHAR(mes, 'MM/YYYY') as data
                  from debitos
                  group by mes
                  order by mes desc
                ),
                valorAtual as (
            select *
            from valorMes limit 1
                ),
                valorCalculo as (
            select *
            from valorMes limit 1 offset #{qtd_mes_analise-1}
                )
                select ROUND((((valorAtual.valor/valorCalculo.valor)^(1/#{qtd_mes_analise-1}.00))-1)*100,2) as percentual, valorAtual.valor, valorAtual.mes, TO_CHAR((valorAtual.mes)::date, 'MM/YYYY') as data,1 as qtd_mes
                from valorAtual
                left join valorCalculo on true

              union all

              select 	projecao.percentual,
                ROUND((projecao.valor + (projecao.valor/100) * projecao.percentual), 2),
                (projecao.mes + interval '1 month')::date,
                TO_CHAR((projecao.mes + interval '1 month')::date, 'MM/YYYY') as data,
                projecao.qtd_mes + 1
              from projecao
              where projecao.qtd_mes < 6
              )
                select *
                from projecao
    "
  end

  def self.get_projecao_clientes(estado, empresa, qtd_mes_analise, tipo)
    return "
            with recursive projecao as(
              with meses as (
                      select (a + INTERVAL'1 month' - INTERVAL'1 day')::date as final,
                                #{ estado.present? ? estado : 'null'}::int as estado
                      from generate_series((date_trunc('month', current_date - interval '14 month') + interval '1 month')::date, (date_trunc('month', current_date) - interval '1 day')::date,INTERVAL'1 month') a
                    ),
                    totalHonorarios as (
                      select count(honorario.id) as qtd,
                 sum(honorario.valor) as valor,
                 ROUND(sum(honorario.valor)/count(honorario.id),2) as media,
                 meses.final as mes,
                             TO_CHAR(meses.final, 'MM/YYYY') as data
                      from honorariomensal honorario
                      inner join meses on honorario.datavencimento::date <= meses.final
                            and (honorario.datainativacao is null or (honorario.datainativacao > meses.final and honorario.ativo is false))
                      inner join financeiro.clientefornecedorfinanceiro cliente on cliente.id = honorario.clifor_id
                      inner join municipio on municipio.id = cliente.municipio_id
                      where honorario.empresa_id in (#{empresa})
                        and honorario.tipo_id = #{tipo.to_i}
                        and (meses.estado is null or municipio.estado_id = meses.estado)
                      group by meses.final
                      order by meses.final desc
                    ),
                    valorAtual as (
                select *
                from totalHonorarios limit 1
                    ),
                    valorCalculo as (
                select *
                from totalHonorarios limit 1 offset #{qtd_mes_analise-1}
                    )
                    select ROUND((((valorAtual.qtd/valorCalculo.qtd::numeric)^(1/#{qtd_mes_analise-1}.00))-1)*100,2) as percentual, valorAtual.qtd::numeric, valorAtual.mes, TO_CHAR((valorAtual.mes)::date, 'MM/YYYY') as data,1 as qtd_mes
                    from valorAtual
                    left join valorCalculo on true

                  union all

                  select 	projecao.percentual,
                    ROUND((projecao.qtd + (projecao.qtd/100) * projecao.percentual)),
                    (projecao.mes + interval '1 month')::date,
                    TO_CHAR((projecao.mes + interval '1 month')::date, 'MM/YYYY') as data,
                    projecao.qtd_mes + 1
                  from projecao
                  where projecao.qtd_mes < 6
                  )
                    select *
                    from projecao

    "
  end

  def self.get_projecao_faturamento_honorario(estado, empresa, qtd_mes_analise)
    return "
        with recursive projecao as(
          with meses as (
            select (a + INTERVAL'1 month' - INTERVAL'1 day')::date as final,
                    #{ estado.present? ? estado : 'null'}::int as estado
                    from generate_series(date_trunc('month', current_date - interval '12 month')::date, (date_trunc('month', current_date) - interval '1 day')::date,INTERVAL'1 month') a
          ),
          sql as (
            select count(honorario.id) as qtd, coalesce(sum(honorario.valor),0) as valor,
                  meses.final
            from meses
            left join financeiro.controle_bloqueio_business controle on controle.data_controle = meses.final
            left join financeiro.controle_bloqueio_business_clientes cliente on controle.id = cliente.controle_bloqueio_business_id
            left join honorariomensal honorario on honorario.id = cliente.honorario_id
            left join financeiro.clientefornecedorfinanceiro clifor on clifor.id = honorario.clifor_id
            left join municipio on municipio.id = clifor.municipio_id
            left join estado on municipio.estado_id = estado.id
            where controle.empresa_id in (#{empresa})
              and (meses.estado is null or estado.id = meses.estado)
              and controle.tipo in ('EM_MANUTENCAO', 'NORMAL')
              group by meses.final
              order by meses.final desc
          ),
          valorAtual as (
            select *
            from sql limit 1
          ),
          valorCalculo as (
            select *
            from sql limit 1 offset #{qtd_mes_analise-1}
          )
            select ROUND((((valorAtual.valor/valorCalculo.valor)^(1/#{qtd_mes_analise-1}.00))-1)*100,2) as percentual, valorAtual.valor, valorAtual.final, 
                    TO_CHAR((valorAtual.final)::date, 'MM/YYYY') as data,1 as qtd_mes
            from valorAtual
            left join valorCalculo on true

            union all

            select 	projecao.percentual,
              ROUND((projecao.valor + (projecao.valor/100) * projecao.percentual), 2),
              (projecao.final + interval '1 month')::date,
              TO_CHAR((projecao.final + interval '1 month')::date, 'MM/YYYY') as data,
              projecao.qtd_mes + 1
            from projecao
            where projecao.qtd_mes < 6
        )
      select *
      from projecao
    "
  end

  def self.get_contatos_12_meses(estado, user)
    return "
        with parametros as (
          select #{ user.present? ? user : 'null'}::int as user_id,
          #{ estado.present? ? estado : 'null'}::int as estado
        ),
        meses as (
          select a::date as inicial, (a + INTERVAL'1 month' - INTERVAL'1 day')::date as final
          from generate_series((date_trunc('month', current_date - interval '14 month') + interval '1 month')::date, (date_trunc('month', current_date + interval '1 month') - interval '1 day')::date,INTERVAL'1 month') a
        ),
        primeira_ligacao AS (
            SELECT lig.cliente_id, lig.user_id, min(data_inicio) AS DATA
            FROM ligacoes lig
            INNER JOIN clientes cliente ON cliente.id = lig.cliente_id
            LEFT JOIN cidades cidade ON cidade.id = cliente.cidade_id
            --where lig.empresa_id in (1,2,3,4,7,8,9,13,14,15,16,17,18,19)
            GROUP BY lig.cliente_id, lig.user_id
        ),
        contatos AS (
            SELECT meses.final as data, count(pri.cliente_id) as qtd_total
            FROM MESES
            LEFT JOIN primeira_ligacao pri ON pri.data::date BETWEEN meses.inicial and meses.final
            INNER JOIN parametros on true
            LEFT JOIN ligacoes ligacao ON ligacao.data_inicio = pri.data
                                      AND pri.cliente_id = ligacao.cliente_id
                                      AND pri.user_id = ligacao.user_id
            LEFT JOIN clientes cliente ON cliente.id = ligacao.cliente_id
            LEFT JOIN cidades cidade ON cidade.id = cliente.cidade_id
            LEFT JOIN estados estado ON estado.id = cidade.estado_id
            where (parametros.estado is null or estado.id = parametros.estado)
                  and (parametros.user_id is null or parametros.user_id = ligacao.user_id)
            GROUP BY meses.final
            order by data desc
        ),
        empresas_boas AS (
          SELECT meses.final as data, count(cliente.id) as qtd_boas
          FROM MESES
          INNER JOIN parametros on true
          LEFT JOIN clientes cliente ON cliente.data_importacao::date BETWEEN meses.inicial and meses.final and cliente.status_empresa is not null and cliente.status_empresa <> 0
          LEFT JOIN cidades cidade ON cidade.id = cliente.cidade_id
          LEFT JOIN estados estado ON estado.id = cidade.estado_id
          where (parametros.estado is null or estado.id = parametros.estado)
          GROUP BY meses.final
                order by data desc
        )
        select TO_CHAR(final, 'MM/YYYY') as mes, coalesce(qtd_total,0) as qtd_contatos, coalesce(qtd_boas,0) as qtd_boas, coalesce(qtd_boas - qtd_total, 0) as resultado
        from meses
        left join contatos on contatos.data = meses.final
        left join empresas_boas boas on boas.data = meses.final 
        order by final desc
    "
  end

  def self.get_contatos_mes_anterior(estado, user, dt_inicio, dt_fim)
    return "
        with parametros as (
          select #{ user.present? ? user : 'null'}::int as user_id,
          #{ estado.present? ? estado : 'null'}::int as estado
        ),
        primeira_ligacao AS (
            SELECT lig.cliente_id, lig.user_id, min(data_inicio) AS DATA
            FROM ligacoes lig
            INNER JOIN clientes cliente ON cliente.id = lig.cliente_id
            LEFT JOIN cidades cidade ON cidade.id = cliente.cidade_id
            GROUP BY lig.cliente_id, lig.user_id
        ),
        contatos AS (
            SELECT '#{dt_inicio}'::date as data, count(pri.cliente_id) as qtd_total
            FROM primeira_ligacao pri
            INNER JOIN parametros on true
            LEFT JOIN ligacoes ligacao ON ligacao.data_inicio = pri.data
                                      AND pri.cliente_id = ligacao.cliente_id
                                      AND pri.user_id = ligacao.user_id
            LEFT JOIN clientes cliente ON cliente.id = ligacao.cliente_id
            LEFT JOIN cidades cidade ON cidade.id = cliente.cidade_id
            LEFT JOIN estados estado ON estado.id = cidade.estado_id
            where pri.data::date BETWEEN '#{dt_inicio}' and '#{dt_fim}'
                  and (parametros.estado is null or estado.id = parametros.estado)
                  and (parametros.user_id is null or parametros.user_id = ligacao.user_id)
        ),
        empresas_boas AS (
          SELECT '#{dt_inicio}'::date as data, count(cliente.id) as qtd_boas
          FROM clientes cliente
          INNER JOIN parametros on true
          LEFT JOIN cidades cidade ON cidade.id = cliente.cidade_id
          LEFT JOIN estados estado ON estado.id = cidade.estado_id
          where cliente.data_importacao::date BETWEEN '#{dt_inicio}' and '#{dt_fim}' 
                and cliente.status_empresa is not null and cliente.status_empresa <> 0
                and (parametros.estado is null or estado.id = parametros.estado)
        )
        select coalesce(qtd_boas,0) as qtd_boas, coalesce(qtd_total,0) as qtd_contatos, coalesce(qtd_boas - qtd_total, 0) as resultado
        from contatos con
		    inner join empresas_boas boas on con.data = boas.data
    "
  end

  def self.get_contatos_mes(inicio, fim)
    return "
        with primeira_ligacao AS (
          SELECT lig.cliente_id,
              lig.user_id,
              min(data_inicio) AS DATA
          FROM ligacoes lig
          INNER JOIN clientes cliente ON cliente.id = lig.cliente_id
          LEFT JOIN cidades cidade ON cidade.id = cliente.cidade_id
          GROUP BY lig.cliente_id,
              lig.user_id
        ),
        contatos AS (
          SELECT users.name, count(pri.cliente_id) as qtd_contatos
          FROM primeira_ligacao pri          
          inner join users on users.id = pri.user_id
          WHERE pri.data::date BETWEEN '#{inicio}' and '#{fim}'
          GROUP BY pri.user_id, users.name
        ),
        dias_com_ligacao AS (
          SELECT users.name, count(distinct pri.data::date) as qtd_dias
          FROM primeira_ligacao pri          
          inner join users on users.id = pri.user_id
          WHERE pri.data::date BETWEEN '#{inicio}' and '#{fim}'
          GROUP BY pri.user_id, users.name
        )
        select contatos.name, contatos.qtd_contatos, dias.qtd_dias, contatos.qtd_contatos / dias.qtd_dias as media
        from contatos 
        left join dias_com_ligacao dias on dias.name = contatos.name
        order by qtd_contatos desc
    "
  end

  def self.get_despesas_com_pessoal(empresa)
    return "  with parametros as (
                 select  null::int as estado_id
       ), meses as (
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
                case when debito.valor = tipo_valor.valor then sum(coalesce(debito_debitopago.valorjuros,0))
                        else round((sum(coalesce(debito_debitopago.valorjuros,0))/100) * (case when tipo_valor.valor <> debito.valor then round(((tipo_valor.valor * 100)/(case when debito.valor = 0 then 1 else debito.valor end)),2) else 100 end),2)
                        end as valorJurosTipo,
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
                 tipo_valor.valor as valorTipo,
                 meses.final
        FROM meses
        inner join parametros on true
        inner JOIN debitospagos debitopago ON debitopago.datapagamento::date between meses.inicial and meses.final and debitopago.empresa_id in (#{empresa})
        inner JOIN debito_debitospagos debito_debitopago ON debito_debitopago.debitopago_id = debitopago.id
        inner join debitos debito on debito.id = debito_debitopago.debito_id
        inner join tipocobrancavalor tipo_valor on tipo_valor.debito_id = debito.id
        inner join financeiro.clientefornecedorfinanceiro cliente ON cliente.id = debito.clifor_id
        LEFT JOIN tipocobranca tipo ON tipo.id = tipo_valor.tipocobranca_id
        left join municipio cidade on cidade.id = cliente.municipio_id
        left join estado estado on estado.id = cidade.estado_id
        where (parametros.estado_id is null or parametros.estado_id = estado.id)
        group by idEmpresa, debito.id, idCobranca, nomecobranca, idCliente, razaosocialcliente, debito.status, debitopago.datapagamento, valorDebito,
		            tipo_valor.valor, debito.parcela, cidade.nome, estado.sigla, estado.nome, meses.final, debito_debitopago.valor, debito_debitopago.valordesconto, debito_debitopago.valorjuros, debito_debitopago.valormulta
        ),
        totalFaturado as (
          select sum(sql.valorpago) as totalGeral, sql.final
          from sql
          group by sql.final
          order by sql.final
        ),
		totalDespesas as(
         select sum(despesa.valor) as valor,
         meses.final as final
         from despesa
         inner join meses on despesa.datapagamento::date between meses.inicial and meses.final
         where despesa.empresa_id in (#{empresa})
         and despesa.tipodespesa_id in (15, 22)
         group by meses.final
         order by meses.final
    )
        select TO_CHAR(meses.final, 'MM/YYYY') as data, tipodes.valor,
              coalesce(totalFaturado.totalGeral,0) as totalGeral
        from meses
        left join totalFaturado on totalFaturado.final = meses.final
		    left join totalDespesas tipodes on tipodes.final = meses.final
"
  end

  def self.get_clientes_bloqueados(datainicio, datafinal, empresa)
    "
      WITH parametros AS (
        SELECT '#{datainicio}'::DATE AS datainicio,
        '#{datafinal}'::DATE AS datafinal
      ),
      emp_bloqueada_atualmente AS (
          SELECT
              COUNT(hon.id) AS qtd,
              COALESCE(SUM(hon.valor), 0) AS valor,
              ROUND(SUM(hon.valor)/COALESCE(COUNT(hon.id), 2), 2) AS media,
              'BLOQUEADOS_ATUALMENTE'::text AS tipo,
              ARRAY_AGG(hon.id) AS ids
          FROM honorariomensal hon
          INNER JOIN financeiro.empresabloqueada emp ON emp.contrato_id = hon.contrato_id
          WHERE hon.ativo IS true
          AND emp.databloqueio::DATE BETWEEN (CURRENT_DATE - INTERVAL '7 day') AND CURRENT_DATE
          AND hon.empresa_id IN (#{empresa})
      ),
      sql AS (
          SELECT
              COUNT(honorario.id) AS qtd,
              COALESCE(SUM(honorario.valor), 0) AS valor,
              ROUND(SUM(honorario.valor)/COALESCE(COUNT(honorario.id), 2), 2) AS media,
              'BLOQUEADOS'::text AS tipo
          FROM parametros
          LEFT JOIN financeiro.controle_bloqueio_business controle ON controle.data_controle BETWEEN parametros.datainicio AND parametros.datafinal
          LEFT JOIN financeiro.controle_bloqueio_business_clientes cliente ON controle.id = cliente.controle_bloqueio_business_id
          LEFT JOIN honorariomensal honorario ON honorario.id = cliente.honorario_id
          LEFT JOIN financeiro.clientefornecedorfinanceiro clifor ON clifor.id = honorario.clifor_id
          LEFT JOIN municipio ON municipio.id = clifor.municipio_id
          LEFT JOIN estado ON municipio.estado_id = estado.id
          WHERE controle.empresa_id IN (#{empresa})
          AND controle.data_controle BETWEEN parametros.datainicio AND parametros.datafinal
          AND CASE
            WHEN to_char(parametros.datafinal, 'YYYY-MM') = to_char(current_date, 'YYYY-MM')
            THEN honorario.id NOT IN (
              SELECT UNNEST(ids) FROM emp_bloqueada_atualmente
            )
            ELSE true
          END
          AND controle.tipo = 'BLOQUEADO'
      ),
      sqlCompleta AS (
        SELECT *
        FROM sql
        UNION ALL
        SELECT qtd, valor, media, tipo FROM emp_bloqueada_atualmente
      )
      SELECT * FROM sqlCompleta
    "
  end

  def self.get_infos_por_tag_desistencia(datainicio, datafinal, tags)
    "
      WITH parametros AS (
        SELECT '#{datainicio}'::DATE AS datainicio,
        '#{datafinal}'::DATE AS datafinal,
        '#{tags ? "{#{tags}}" : 'NULL'}'::INT[] AS tags_id
      ),
      desistencias_agrupadas AS (
        SELECT tags.descricao,
          COUNT(desistencia.id) AS qtd,
          sistema.nome,
          SUM(valor_mensalidade) AS valor
        FROM solicitacao_desistencias desistencia
        INNER JOIN parametros ON true
        INNER JOIN clientes cliente ON cliente.id = desistencia.cliente_id
        INNER JOIN tags_solicitacao_desistencias tags ON tags.id::text = ANY(
          SELECT jsonb_array_elements_text(desistencia.tags::jsonb)
        )
        LEFT JOIN propostas proposta ON proposta.id = (
          SELECT id 
          FROM propostas 
          WHERE propostas.cliente_id = cliente.id 
            AND propostas.ativa IS true 
          ORDER BY id DESC 
          LIMIT 1
        )
        LEFT JOIN pacotes pacote ON pacote.id = proposta.pacote_id
        LEFT JOIN sistemas sistema ON sistema.id = pacote.sistema_id  
        WHERE desistencia.status = 'DESISTENTE'
          AND desistencia.data_desistencia BETWEEN parametros.datainicio AND parametros.datafinal
          AND desistencia.user_id IS NULL
          AND CASE
              WHEN tags.id IS NOT NULL
              THEN tags.id = ANY(parametros.tags_id)
              ELSE true
          END
        GROUP BY 
          tags.descricao, sistema.nome
      )
      SELECT 
        descricao AS tag,
        qtd,
        COALESCE(valor, 0) AS valor,
        COALESCE(nome, 'NÃO INFORMADO') AS sistema,
        ROUND(100.0 * qtd / SUM(qtd) OVER (), 2) AS porcentagem
      FROM desistencias_agrupadas
      ORDER BY
        SUM(qtd) OVER (PARTITION BY descricao) DESC,
        descricao,
        qtd DESC;
    "
  end

  def self.get_comparacao_tags_mensal(primeiro_mes, segundo_mes, tags)
    "
      WITH parametros AS (
          SELECT 
              string_to_array('#{tags}', ',') AS tags_id,
              '#{primeiro_mes}' AS primeiro_mes,
              '#{segundo_mes}' AS segundo_mes
      ),
      desistentes_por_tag AS (
          SELECT 
              tag.descricao,
              SUM(proposta.valor_mensalidade) AS valor,
              COUNT(DISTINCT desistencia.id) AS qtd,
              CASE 
                  WHEN TO_CHAR(desistencia.data_desistencia::DATE, 'MM/YYYY') = params.primeiro_mes THEN 'primeiro_mes'
                  WHEN TO_CHAR(desistencia.data_desistencia::DATE, 'MM/YYYY') = params.segundo_mes THEN 'segundo_mes'
              END AS meses
          FROM solicitacao_desistencias desistencia
          INNER JOIN tags_solicitacao_desistencias tag ON tag.id::text = ANY(
              SELECT jsonb_array_elements_text(desistencia.tags::jsonb)
          )
          LEFT JOIN propostas proposta ON proposta.cliente_id = desistencia.cliente_id
          INNER JOIN parametros params ON true
          WHERE ((desistencia.tags::jsonb ?| params.tags_id) OR (params.tags_id IS NULL))
            AND TO_CHAR(desistencia.data_desistencia::DATE, 'MM/YYYY') IN (params.primeiro_mes, params.segundo_mes)
          GROUP BY tag.descricao, meses
      )
      SELECT
        descricao AS tag,
        COALESCE(SUM(qtd) FILTER (WHERE meses = 'primeiro_mes'), 0) AS qtd_primeiro_mes,
        COALESCE(SUM(qtd) FILTER (WHERE meses = 'segundo_mes'), 0) AS qtd_segundo_mes,
        COALESCE(SUM(valor) FILTER (WHERE meses = 'primeiro_mes'), 0) AS valor_primeiro_mes,
        COALESCE(SUM(valor) FILTER (WHERE meses = 'segundo_mes'), 0) AS valor_segundo_mes,
        COALESCE(SUM(qtd) FILTER (WHERE meses = 'primeiro_mes'), 0) - COALESCE(SUM(qtd) FILTER (WHERE meses = 'segundo_mes'), 0) AS diferenca_qtd,
        COALESCE(SUM(valor) FILTER (WHERE meses = 'primeiro_mes'), 0) - COALESCE(SUM(valor) FILTER (WHERE meses = 'segundo_mes'), 0) AS diferenca_valor
      FROM desistentes_por_tag
      GROUP BY descricao
      ORDER BY descricao DESC;
    "
  end
end
