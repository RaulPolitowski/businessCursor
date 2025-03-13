module RelatoriosHelper

  def self.get_status_implantacao status
    case status
      when '0'
        return 'Agendado'
      when '1'
        return 'Reagendado'
      when '2'
        return 'Aguardando terceiros'
      when '3'
        return 'Em processo de instalação'
      when '4'
        return 'Aguardando treinamento'
      when '5'
        return 'Em processo de treinamento'
      when '6'
        return 'Aguardando terceiros'
      when '7'
        return 'Desistente - Pré instalação'
      when '8'
        return 'Desistente - Durante implantação'
      else
        return 'Implantação concluída'
    end
  end

  def self.resumo_comercial_concluidas_teste(data_inicio, data_fim, empresa, vendedor, implantador, sistema, cidade, estado)
    html = " with parametros as (
            select 	'#{data_inicio}'::date as data_inicial,
              '#{data_fim}'::date as data_fim,
              #{ vendedor.present? ? vendedor : 'null'}::int as vendedor,
              #{ implantador.present? ? implantador : 'null'}::int as implantador,
              #{ cidade.present? ? cidade : 'null'}::int as cidade,
              #{ estado.present? ? ApplicationHelper.get_estado_by_codigo(estado) : 'null'}::int as estado,
              #{ sistema.present? ? sistema : 'null'}::int as sistema
          )
          select 	imp.data_fim, implantador.name as implantador, cliente.razao_social as cliente, cidade.nome || '-' || estado.sigla as cidade, sistema.nome as sistema,
            proposta.valor_mensalidade, vendedor.name as vendedor, fechamento.data_fechamento, imp.data_fim::date - imp.data_inicio::date as dias_implantacao
          from implantacoes imp
          inner join parametros on true
          inner join clientes cliente on cliente.id = imp.cliente_id
          inner join cidades cidade on cidade.id = cliente.cidade_id
          inner join estados estado on estado.id = cidade.estado_id
          left join fechamentos fechamento on fechamento.cliente_id = cliente.id
          left join propostas proposta on proposta.id = (select id from propostas where propostas.cliente_id = imp.cliente_id and propostas.ativa is true order by id desc limit 1)
          left join pacotes pacote on pacote.id = proposta.pacote_id
          left join sistemas sistema on sistema.id = pacote.sistema_id
          left join users vendedor on vendedor.id = fechamento.user_id
          left join users implantador on implantador.id = imp.user_id
          where imp.data_fim::date between parametros.data_inicial and parametros.data_fim
            and imp.status = 9
            #{ empresa.present? ? " and imp.empresa_id in (#{ ApplicationHelper.get_empresas_by_codigo(empresa) }) " : ''}
            and (parametros.vendedor is null or parametros.vendedor = vendedor.id)
            and (parametros.implantador is null or parametros.implantador = implantador.id)
            and (parametros.cidade is null or parametros.cidade = cidade.id)
            and (parametros.estado is null or parametros.estado = estado.id)
            and (parametros.sistema is null or parametros.sistema = sistema.id)
            order by imp.data_fim desc
      "
  end

  def self.resumo_comercial_concluidas_efetivo(data_inicio, data_fim, empresa, vendedor, implantador, sistema, cidade, estado)
    html = " with parametros as (
            select 	'#{data_inicio}'::date as data_inicial,
              '#{data_fim}'::date as data_fim,
              #{ vendedor.present? ? vendedor : 'null'}::int as vendedor,
              #{ implantador.present? ? implantador : 'null'}::int as implantador,
              #{ cidade.present? ? cidade : 'null'}::int as cidade,
              #{ estado.present? ? ApplicationHelper.get_estado_by_codigo(estado) : 'null'}::int as estado,
              #{ sistema.present? ? sistema : 'null'}::int as sistema
          )
          select 	imp.data_fim, implantador.name as implantador, cliente.razao_social as cliente, cidade.nome || '-' || estado.sigla as cidade, sistema.nome as sistema,
            proposta.valor_mensalidade, vendedor.name as vendedor, fechamento.data_fechamento, imp.data_fim::date - imp.data_inicio::date as dias_implantacao
          from implantacoes imp
          inner join parametros on true
          inner join clientes cliente on cliente.id = imp.cliente_id
          inner join cidades cidade on cidade.id = cliente.cidade_id
          inner join estados estado on estado.id = cidade.estado_id
          left join fechamentos fechamento on fechamento.cliente_id = cliente.id
          left join propostas proposta on proposta.id = (select id from propostas where propostas.cliente_id = imp.cliente_id and propostas.ativa is true order by id desc limit 1)
          left join pacotes pacote on pacote.id = proposta.pacote_id
          left join sistemas sistema on sistema.id = pacote.sistema_id
          left join users vendedor on vendedor.id = fechamento.user_id
          left join users implantador on implantador.id = imp.user_id
          where imp.data_fim::date between parametros.data_inicial and parametros.data_fim
            and imp.status = 9
            #{ empresa.present? ? " and imp.empresa_id in (#{ ApplicationHelper.get_empresas_by_codigo(empresa) }) " : ''}
            and (parametros.vendedor is null or parametros.vendedor = vendedor.id)
            and (parametros.implantador is null or parametros.implantador = implantador.id)
            and (parametros.cidade is null or parametros.cidade = cidade.id)
            and (parametros.estado is null or parametros.estado = estado.id)
            and (parametros.sistema is null or parametros.sistema = sistema.id)
            order by imp.data_fim desc
      "
  end

  def self.resumo_comercial_em_andamento(data_inicio, data_fim, empresa, vendedor, implantador, sistema, cidade, estado)
    html = "  with parametros as (
            select 	'#{data_inicio}'::date as data_inicial,
              '#{data_fim}'::date as data_fim,
              #{ vendedor.present? ? vendedor : 'null'}::int as vendedor,
              #{ implantador.present? ? implantador : 'null'}::int as implantador,
              #{ cidade.present? ? cidade : 'null'}::int as cidade,
              #{ estado.present? ? ApplicationHelper.get_estado_by_codigo(estado) : 'null'}::int as estado,
              #{ sistema.present? ? sistema : 'null'}::int as sistema
          ),
          sql as (
          select imp.data_inicio, implantador.name as implantador, cliente.razao_social as cliente, cidade.nome || '-' || estado.sigla as cidade, sistema.nome as sistema,
            proposta.valor_mensalidade, vendedor.name as vendedor, fechamento.data_fechamento, current_date - imp.data_inicio::date as dias_implantacao, imp.status
          from implantacoes imp
          inner join parametros on true
          inner join clientes cliente on cliente.id = imp.cliente_id
          inner join cidades cidade on cidade.id = cliente.cidade_id
          inner join estados estado on estado.id = cidade.estado_id
          left join fechamentos fechamento on fechamento.cliente_id = cliente.id
          left join propostas proposta on proposta.id = (select id from propostas where propostas.cliente_id = imp.cliente_id and propostas.ativa is true order by id desc limit 1)
          left join pacotes pacote on pacote.id = proposta.pacote_id
          left join sistemas sistema on sistema.id = pacote.sistema_id
          left join users vendedor on vendedor.id = fechamento.user_id
          left join users implantador on implantador.id = imp.user_id
          where imp.data_inicio::date between parametros.data_inicial and parametros.data_fim
            and imp.data_fim is null
            and imp.status in (3,4,5,6)
            #{ empresa.present? ? " and imp.empresa_id in (#{ ApplicationHelper.get_empresas_by_codigo(empresa) }) " : ''}
            and (parametros.vendedor is null or parametros.vendedor = vendedor.id)
            and (parametros.implantador is null or parametros.implantador = implantador.id)
            and (parametros.cidade is null or parametros.cidade = cidade.id)
            and (parametros.estado is null or parametros.estado = estado.id)
            and (parametros.sistema is null or parametros.sistema = sistema.id)

            union all

           select act.created_at, implantador.name as implantador, cliente.razao_social as cliente, cidade.nome || '-' || estado.sigla as cidade, sistema.nome as sistema,
            proposta.valor_mensalidade, vendedor.name as vendedor, fechamento.data_fechamento, current_date - imp.data_inicio::date as dias_implantacao, imp.status
          from implantacoes imp
          inner join parametros on true
          inner join clientes cliente on cliente.id = imp.cliente_id
          inner join cidades cidade on cidade.id = cliente.cidade_id
          inner join estados estado on estado.id = cidade.estado_id
          left join fechamentos fechamento on fechamento.cliente_id = cliente.id
          left join propostas proposta on proposta.id = (select id from propostas where propostas.cliente_id = imp.cliente_id and propostas.ativa is true order by id desc limit 1)
          left join pacotes pacote on pacote.id = proposta.pacote_id
          left join sistemas sistema on sistema.id = pacote.sistema_id
          left join users vendedor on vendedor.id = fechamento.user_id
          left join users implantador on implantador.id = imp.user_id
          inner join activities act on act.id = (select max(id) from activities where activities.trackable_type = 'Implantacao' and activities.key = 'implantacao.continuou' and activities.recipient_id = imp.id and activities.created_at between parametros.data_inicial and parametros.data_fim)
          where  imp.data_inicio < parametros.data_inicial
            and imp.data_fim is null
            and imp.status in (3,4,5,6)
            #{ empresa.present? ? " and imp.empresa_id in (#{ ApplicationHelper.get_empresas_by_codigo(empresa) }) " : ''}
            and (parametros.vendedor is null or parametros.vendedor = vendedor.id)
            and (parametros.implantador is null or parametros.implantador = implantador.id)
            and (parametros.cidade is null or parametros.cidade = cidade.id)
            and (parametros.estado is null or parametros.estado = estado.id)
            and (parametros.sistema is null or parametros.sistema = sistema.id)
          )
           select *
           from sql
           order by sql.data_inicio desc
      "
  end

  def self.resumo_comercial_efetivadas(data_inicio, data_fim, empresa, vendedor, implantador, sistema, cidade, estado)
    html = "   with parametros as (
            select 	'#{data_inicio}'::date as data_inicial,
              '#{data_fim}'::date as data_fim,
              #{ vendedor.present? ? vendedor : 'null'}::int as vendedor,
              #{ implantador.present? ? implantador : 'null'}::int as implantador,
              #{ cidade.present? ? cidade : 'null'}::int as cidade,
              #{ estado.present? ? ApplicationHelper.get_estado_by_codigo(estado) : 'null'}::int as estado,
              #{ sistema.present? ? sistema : 'null'}::int as sistema
          )
        select imp.data_fim, implantador.name as implantador, cliente.razao_social as cliente, cidade.nome || '-' || estado.sigla as cidade, sistema.nome as sistema,
          proposta.valor_mensalidade, vendedor.name as vendedor, fechamento.data_fechamento, imp.data_fim::date - imp.data_inicio::date as dias_implantacao, imp.status
        from acompanhamentos acomp
        inner join parametros on true
        inner join clientes cliente on cliente.id = acomp.cliente_id
          inner join cidades cidade on cidade.id = cliente.cidade_id
        inner join estados estado on estado.id = cidade.estado_id
        inner join implantacoes imp on imp.cliente_id = cliente.id
        left join fechamentos fechamento on fechamento.cliente_id = cliente.id
        left join propostas proposta on proposta.id = (select id from propostas where propostas.cliente_id = acomp.cliente_id and propostas.ativa is true order by id desc limit 1)
        left join pacotes pacote on pacote.id = proposta.pacote_id
        left join sistemas sistema on sistema.id = pacote.sistema_id
        left join users vendedor on vendedor.id = fechamento.user_id
        left join users implantador on implantador.id = imp.user_id
        where acomp.data_fim::date between parametros.data_inicial and parametros.data_fim
          and acomp.status in (5)
          #{ empresa.present? ? " and imp.empresa_id in (#{ ApplicationHelper.get_empresas_by_codigo(empresa) }) " : ''}
          and (parametros.vendedor is null or parametros.vendedor = vendedor.id)
          and (parametros.implantador is null or parametros.implantador = implantador.id)
          and (parametros.cidade is null or parametros.cidade = cidade.id)
          and (parametros.estado is null or parametros.estado = estado.id)
          and (parametros.sistema is null or parametros.sistema = sistema.id)
          order by acomp.data_fim desc
      "
  end

  def self.resumo_comercial_desistente_pre(data_inicio, data_fim, empresa, vendedor, implantador, sistema, cidade, estado)
    html = " with parametros as (
            select 	'#{data_inicio}'::date as data_inicial,
              '#{data_fim}'::date as data_fim,
              #{ vendedor.present? ? vendedor : 'null'}::int as vendedor,
              #{ implantador.present? ? implantador : 'null'}::int as implantador,
              #{ cidade.present? ? cidade : 'null'}::int as cidade,
              #{ estado.present? ? ApplicationHelper.get_estado_by_codigo(estado) : 'null'}::int as estado,
              #{ sistema.present? ? sistema : 'null'}::int as sistema
          )
          select imp.data_fim, implantador.name as implantador, cliente.razao_social as cliente, cidade.nome || '-' || estado.sigla as cidade, sistema.nome as sistema,
            proposta.valor_mensalidade, vendedor.name as vendedor, fechamento.data_fechamento, imp.data_fim::date - imp.created_at::date as dias_implantacao,
            imp.motivo as motivo
          from implantacoes imp
          inner join parametros on true
          inner join clientes cliente on cliente.id = imp.cliente_id
          inner join cidades cidade on cidade.id = cliente.cidade_id
          inner join estados estado on estado.id = cidade.estado_id
          left join fechamentos fechamento on fechamento.cliente_id = cliente.id
          left join propostas proposta on proposta.id = (select id from propostas where propostas.cliente_id = imp.cliente_id and propostas.ativa is true order by id desc limit 1)
          left join pacotes pacote on pacote.id = proposta.pacote_id
          left join sistemas sistema on sistema.id = pacote.sistema_id
          left join users vendedor on vendedor.id = fechamento.user_id
          left join users implantador on implantador.id = imp.user_id
          where imp.data_fim::date between parametros.data_inicial and parametros.data_fim
            and imp.status = 7
            #{ empresa.present? ? " and imp.empresa_id in (#{ ApplicationHelper.get_empresas_by_codigo(empresa) }) " : ''}
            and (parametros.vendedor is null or parametros.vendedor = vendedor.id)
            and (parametros.implantador is null or parametros.implantador = implantador.id)
            and (parametros.cidade is null or parametros.cidade = cidade.id)
            and (parametros.estado is null or parametros.estado = estado.id)
            and (parametros.sistema is null or parametros.sistema = sistema.id)
            order by imp.data_fim desc
      "
  end

  def self.resumo_comercial_desistente_durante(data_inicio, data_fim, empresa, vendedor, implantador, sistema, cidade, estado)
    html = " with parametros as (
            select 	'#{data_inicio}'::date as data_inicial,
              '#{data_fim}'::date as data_fim,
              #{ vendedor.present? ? vendedor : 'null'}::int as vendedor,
              #{ implantador.present? ? implantador : 'null'}::int as implantador,
              #{ cidade.present? ? cidade : 'null'}::int as cidade,
              #{ estado.present? ? ApplicationHelper.get_estado_by_codigo(estado) : 'null'}::int as estado,
              #{ sistema.present? ? sistema : 'null'}::int as sistema
          )
          select imp.data_fim, implantador.name as implantador, cliente.razao_social as cliente, cidade.nome || '-' || estado.sigla as cidade, sistema.nome as sistema,
            proposta.valor_mensalidade, vendedor.name as vendedor, fechamento.data_fechamento, imp.data_fim::date - imp.created_at::date as dias_implantacao,
            imp.motivo as motivo
          from implantacoes imp
          inner join parametros on true
          inner join clientes cliente on cliente.id = imp.cliente_id
          inner join cidades cidade on cidade.id = cliente.cidade_id
          inner join estados estado on estado.id = cidade.estado_id
          left join fechamentos fechamento on fechamento.cliente_id = cliente.id
          left join propostas proposta on proposta.id = (select id from propostas where propostas.cliente_id = imp.cliente_id and propostas.ativa is true order by id desc limit 1)
          left join pacotes pacote on pacote.id = proposta.pacote_id
          left join sistemas sistema on sistema.id = pacote.sistema_id
          left join users vendedor on vendedor.id = fechamento.user_id
          left join users implantador on implantador.id = imp.user_id
          where imp.data_fim::date between parametros.data_inicial and parametros.data_fim
            and imp.status = 8
            #{ empresa.present? ? " and imp.empresa_id in (#{ ApplicationHelper.get_empresas_by_codigo(empresa) }) " : ''}
            and (parametros.vendedor is null or parametros.vendedor = vendedor.id)
            and (parametros.implantador is null or parametros.implantador = implantador.id)
            and (parametros.cidade is null or parametros.cidade = cidade.id)
            and (parametros.estado is null or parametros.estado = estado.id)
            and (parametros.sistema is null or parametros.sistema = sistema.id)
            order by imp.data_fim desc
      "
  end

  def self.resumo_comercial_desistente_acompanhamento(data_inicio, data_fim, empresa, vendedor, implantador, sistema, cidade, estado)
    html = " with parametros as (
            select 	'#{data_inicio}'::date as data_inicial,
              '#{data_fim}'::date as data_fim,
              #{ vendedor.present? ? vendedor : 'null'}::int as vendedor,
              #{ implantador.present? ? implantador : 'null'}::int as implantador,
              #{ cidade.present? ? cidade : 'null'}::int as cidade,
              #{ estado.present? ? ApplicationHelper.get_estado_by_codigo(estado) : 'null'}::int as estado,
              #{ sistema.present? ? sistema : 'null'}::int as sistema
          )
        select imp.data_fim, implantador.name as implantador, cliente.razao_social as cliente, cidade.nome || '-' || estado.sigla as cidade, sistema.nome as sistema,
          proposta.valor_mensalidade, vendedor.name as vendedor, fechamento.data_fechamento, imp.data_fim::date - imp.data_inicio::date as dias_implantacao,
          acomp.motivo as motivo
        from acompanhamentos acomp
        inner join parametros on true
        inner join clientes cliente on cliente.id = acomp.cliente_id
        inner join cidades cidade on cidade.id = cliente.cidade_id
        inner join estados estado on estado.id = cidade.estado_id
        inner join implantacoes imp on imp.cliente_id = cliente.id
        left join fechamentos fechamento on fechamento.cliente_id = cliente.id
        left join propostas proposta on proposta.id = (select id from propostas where propostas.cliente_id = acomp.cliente_id and propostas.ativa is true order by id desc limit 1)
        left join pacotes pacote on pacote.id = proposta.pacote_id
        left join sistemas sistema on sistema.id = pacote.sistema_id
        left join users vendedor on vendedor.id = fechamento.user_id
        left join users implantador on implantador.id = imp.user_id
        where acomp.data_fim::date between parametros.data_inicial and parametros.data_fim
          and acomp.status in (3,4)
          #{ empresa.present? ? " and imp.empresa_id in (#{ ApplicationHelper.get_empresas_by_codigo(empresa) }) " : ''}
          and (parametros.vendedor is null or parametros.vendedor = vendedor.id)
          and (parametros.implantador is null or parametros.implantador = implantador.id)
          and (parametros.cidade is null or parametros.cidade = cidade.id)
          and (parametros.estado is null or parametros.estado = estado.id)
          and (parametros.sistema is null or parametros.sistema = sistema.id)
          order by acomp.data_fim desc


      "
  end

  def self.pagamento_primeira_mensalidade_financeiro(data_inicial, data_final, empresa, estado, withDesconto)
    return "
    with parametros as (
      select 	'#{data_inicial}'::date as data_inicial,
              '#{data_final}'::date as data_fim,
              #{ estado.present? ? estado : 'null'}::int as estado
    ),
    primeira_parcela_mensalidade AS
      (WITH id_debito AS
         (SELECT DISTINCT c.clifor_id,
                          min(c.datacompetencia) AS datacompetencia,
                          min(c.id) AS id
          FROM debitos c
          INNER JOIN tipocobrancavalor tc ON tc.debito_id = c.id
          AND tc.tipocobranca_id = 16
          WHERE c.status IN ('PENDENTE',
                             'PAGO',
                             'PARCIALMENTE_PAGO')
            AND c.empresa_id IN  (#{empresa})
          GROUP BY c.clifor_id
          ORDER BY c.clifor_id) SELECT debito.id,
                                       debito.datacompetencia,
                                       debito.clifor_id,
                                       coalesce(boleto.datavencimento, debito.datavencimento) AS datavencimento,
                                       debitopago.datapagamento
       FROM id_debito
       INNER JOIN debitos debito ON debito.id = id_debito.id
       AND debito.clifor_id = id_debito.clifor_id
       LEFT JOIN boletogerado boleto ON boleto.id = debito.boletogerado_id
       LEFT JOIN debito_debitospagos debito_debitopago ON debito_debitopago.debito_id = debito.id
       LEFT JOIN debitospagos debitopago ON debitopago.id = debito_debitopago.debitopago_id
       GROUP BY debito.id,
                debito.clifor_id,
                coalesce(boleto.datavencimento, debito.datavencimento),
                debitopago.datapagamento),
         honorarioDescontos AS
      (WITH honorarios AS
         (SELECT hono.id,
                 hono.clifor_id,
                 count(dbp.id)
          FROM honorariomensal hono
          INNER JOIN parametros ON TRUE
          INNER JOIN debitospagos dbp ON dbp.clifor_id = hono.clifor_id
          INNER JOIN debito_debitospagos ddp ON ddp.debitopago_id = dbp.id
          INNER JOIN debitos ON debitos.id = ddp.debito_id
          INNER JOIN tipocobrancavalor tcv ON tcv.debito_id = debitos.id
          AND tipocobranca_id = 16
          WHERE hono.datainativacao BETWEEN parametros.data_inicial AND parametros.data_fim
            AND hono.ativo IS FALSE
            AND hono.empresa_id IN (#{empresa})
          GROUP BY hono.id,
                   hono.clifor_id
          HAVING count(dbp.id) = 1) SELECT NULL::int AS id,
                                           hono.clifor_id,
                                           cli.razaosocial,
                                           cli.cpfcnpj,
                                           cidade.nome || '-' || estado.sigla AS cidade,
                                           honorario.datainativacao,
                                           NULL::date AS datapagamento,
                                           to_char(honorario.dataparalizacao::date, 'DD/MM/YYYY') AS data_pagamento_desc,
                                           honorario.valor AS mensalidade,
                                           NULL::varchar AS status,
                                           1 AS parcela,
                                           0::numeric AS jurosPago,
                                           honorario.valor AS valorPago,
                                           honorario.valor AS totalPago,
                                           honorario.empresa_id AS empresa_id,
                                           (CASE
                                                WHEN honorario.cliforparceiro_id IS NOT NULL THEN 2
                                                WHEN honorario.empresa_id IN (17, 3422) THEN 1
                                                WHEN honorario.empresa_id = 3253 THEN 2
                                            END) AS regiao,
                                           sistema.nome AS sistema
       FROM honorarios hono
       LEFT JOIN honorariomensal honorario ON honorario.id = hono.id
       LEFT JOIN financeiro.clientefornecedorfinanceiro cli ON cli.id = hono.clifor_id
       LEFT JOIN municipio cidade ON cidade.id = cli.municipio_id
       LEFT JOIN estado ON estado.id = cidade.estado_id
       LEFT JOIN contrato ON contrato.id = honorario.contrato_id
       LEFT JOIN sistema ON sistema.id = contrato.sistema_id)
    SELECT DISTINCT debito.id,
                    cliente.id AS clifor_id,
                    cliente.razaosocial,
                    cliente.cpfcnpj,
                    cidade.nome || '-' || estado.sigla AS cidade,
                    coalesce(boleto.datavencimento, debito.datavencimento) AS datavencimento,
                    debitopago.datapagamento::date,
                    to_char(debitopago.datapagamento::date, 'DD/MM/YYYY') AS data_pagamento_desc,
                    debito.valor AS mensalidade,
                    debito.status AS status,
                    coalesce(debito.parcela, 1) AS parcela,
                    debito_debitopago.valorjuros AS jurosPago,
                    debito_debitopago.valor AS valorPago,
                    debito_debitopago.valorjuros + debito_debitopago.valor AS totalPago,
                    debito.empresa_id AS empresa_id,
                    (CASE
                         WHEN honorario.cliforparceiro_id IS NOT NULL THEN 2
                         WHEN debito.empresa_id IN (17, 3422) THEN 1
                         WHEN debito.empresa_id = 3253 THEN 2
                     END) AS regiao,
                    sistema.nome AS sistema,
                    'COMISSAO' AS tipo_comissao,
                    '' AS tipo_venda
    FROM primeira_parcela_mensalidade pri
    INNER JOIN debitos debito ON debito.id = pri.id
    INNER JOIN parametros ON TRUE
    INNER JOIN financeiro.clientefornecedorfinanceiro cliente ON cliente.id = debito.clifor_id
    LEFT JOIN municipio cidade ON cidade.id = cliente.municipio_id
    LEFT JOIN estado ON estado.id = cidade.estado_id
    LEFT JOIN debito_debitospagos debito_debitopago ON debito_debitopago.debito_id = debito.id
    LEFT JOIN debitospagos debitopago ON debitopago.id = debito_debitopago.debitopago_id
    LEFT JOIN boletogerado boleto ON boleto.id = debito.boletogerado_id
    LEFT JOIN honorariomensal honorario ON honorario.clifor_id = debito.clifor_id
    AND honorario.empresa_id = debito.empresa_id
    AND honorario.ativo IS TRUE
    AND honorario.tipo_id = 16
    LEFT JOIN contrato ON contrato.id = honorario.contrato_id
    LEFT JOIN sistema ON sistema.id = contrato.sistema_id
    WHERE debito.status IN ('PAGO')
      AND debito.empresa_id IN (#{empresa})
      AND pri.datapagamento::date BETWEEN parametros.data_inicial AND parametros.data_fim
      AND (parametros.estado IS NULL
           OR parametros.estado = estado.id)
    GROUP BY debito.id,
             debito.empresa_id,
             cliente.id,
             cliente.razaosocial,
             cidade.nome, (estado.nome || '-' || estado.sigla), estado.sigla,
                                                                coalesce(boleto.datavencimento, debito.datavencimento),
                                                                debito.valor,
                                                                debito.status,
                                                                debito.parcela,
                                                                debitopago.datapagamento::date,
                                                                debito_debitopago.valorjuros,
                                                                debito_debitopago.valor,
                                                                debitopago.datapagamento,
                                                                honorario.cliforparceiro_id,
                                                                sistema.nome
    UNION ALL
    SELECT *,
           'DESCONTO' AS tipo_comissao,
           '' AS tipo_venda
    FROM honorarioDescontos

    WHERE true = #{withDesconto}
    ORDER BY datapagamento ASC, razaosocial ASC"
  end

  def self.pagamento_primeira_mensalidade_empresa(empresa, cliente_id)
    return "
    with primeira_parcela_mensalidade AS
      ( WITH id_debito AS
         (SELECT DISTINCT c.clifor_id,
                          min(c.datacompetencia) AS datacompetencia,
                          min(c.id) AS id
          FROM debitos c
          INNER JOIN tipocobrancavalor tc ON tc.debito_id = c.id
          AND tc.tipocobranca_id = 16
          WHERE c.status IN ('PENDENTE', 'PAGO', 'PARCIALMENTE_PAGO')
            AND c.empresa_id IN  (#{empresa})
            AND c.clifor_id = #{cliente_id}
          GROUP BY c.clifor_id
        )
        SELECT debito.id,
                  debito.datacompetencia,
                  debito.clifor_id,
                  coalesce(boleto.datavencimento, debito.datavencimento) AS datavencimento,
                  debitopago.datapagamento
       FROM id_debito
       INNER JOIN debitos debito ON debito.id = id_debito.id
       AND debito.clifor_id = id_debito.clifor_id
       LEFT JOIN boletogerado boleto ON boleto.id = debito.boletogerado_id
       LEFT JOIN debito_debitospagos debito_debitopago ON debito_debitopago.debito_id = debito.id
       LEFT JOIN debitospagos debitopago ON debitopago.id = debito_debitopago.debitopago_id
       GROUP BY debito.id,
                debito.clifor_id,
                coalesce(boleto.datavencimento, debito.datavencimento),
                debitopago.datapagamento
      )
    SELECT DISTINCT debito.id,
                    cliente.id AS clifor_id,
                    cliente.razaosocial,
                    cliente.cpfcnpj,
                    cidade.nome || '-' || estado.sigla AS cidade,
                    coalesce(boleto.datavencimento, debito.datavencimento) AS datavencimento,
                    debitopago.datapagamento::date,
                    to_char(debitopago.datapagamento::date, 'DD/MM/YYYY') AS data_pagamento_desc,
                    debito.valor AS mensalidade,
                    debito.status AS status,
                    coalesce(debito.parcela, 1) AS parcela,
                    debito_debitopago.valorjuros AS jurosPago,
                    debito_debitopago.valor AS valorPago,
                    debito_debitopago.valorjuros + debito_debitopago.valor AS totalPago,
                    debito.empresa_id AS empresa_id,
                    (CASE
                         WHEN honorario.cliforparceiro_id IS NOT NULL THEN 2
                         WHEN debito.empresa_id IN (17, 3422) THEN 1
                         WHEN debito.empresa_id = 3253 THEN 2
                     END) AS regiao,
                    sistema.nome AS sistema,
                    'COMISSAO' AS tipo_comissao,
                    '' AS tipo_venda
    FROM primeira_parcela_mensalidade pri
    INNER JOIN debitos debito ON debito.id = pri.id
    INNER JOIN financeiro.clientefornecedorfinanceiro cliente ON cliente.id = debito.clifor_id
    LEFT JOIN municipio cidade ON cidade.id = cliente.municipio_id
    LEFT JOIN estado ON estado.id = cidade.estado_id
    LEFT JOIN debito_debitospagos debito_debitopago ON debito_debitopago.debito_id = debito.id
    LEFT JOIN debitospagos debitopago ON debitopago.id = debito_debitopago.debitopago_id
    LEFT JOIN boletogerado boleto ON boleto.id = debito.boletogerado_id
    LEFT JOIN honorariomensal honorario ON honorario.clifor_id = debito.clifor_id
    AND honorario.empresa_id = debito.empresa_id
    AND honorario.ativo IS TRUE
    AND honorario.tipo_id = 16
    LEFT JOIN contrato ON contrato.id = honorario.contrato_id
    LEFT JOIN sistema ON sistema.id = contrato.sistema_id
    WHERE debito.status IN ('PAGO')
      AND debito.empresa_id IN (#{empresa})
    GROUP BY debito.id,
             debito.empresa_id,
             cliente.id,
             cliente.razaosocial,
             cidade.nome, (estado.nome || '-' || estado.sigla), estado.sigla,
                                                                coalesce(boleto.datavencimento, debito.datavencimento),
                                                                debito.valor,
                                                                debito.status,
                                                                debito.parcela,
                                                                debitopago.datapagamento::date,
                                                                debito_debitopago.valorjuros,
                                                                debito_debitopago.valor,
                                                                debitopago.datapagamento,
                                                                honorario.cliforparceiro_id,
                                                                sistema.nome
    "
  end

  def self.projecao_clientes_novos(data_inicial, data_final, empresa, estado, group, ordem)
    sql = "WITH parametros AS
            (SELECT #{ estado.present? ? estado : 'null'}::int AS estado_id,
                    '#{data_inicial}'::date as data_inicial,
                    '#{data_final}'::date as data_final),
        PRIMEIRO_DEBITO AS 
                    (select distinct c.clifor_id, min(c.datacompetencia) as datacompetencia, min(c.id) as id_debito
                            from debitos c
                            inner join tipocobrancavalor tc on tc.debito_id = c.id and tc.tipocobranca_id = 16
                            where c.status in ('PENDENTE', 'PAGO', 'PARCIALMENTE_PAGO')
                            and c.empresa_id in (#{empresa})
                            group by c.clifor_id
                            order by c.clifor_id
                     ),
        DEBITOS_PAGOS AS 
                    (SELECT pd.clifor_id, debito.id as debito_id, debito.datavencimento, debito.valor, debitopago.datapagamento, debitopago.valorrecebido
                     FROM PRIMEIRO_DEBITO pd
                     inner join debitos debito on debito.id = pd.id_debito and debito.clifor_id = pd.clifor_id
                     left join debito_debitospagos on debito_debitospagos.debito_id = debito.id
                           left join debitospagos debitopago on debitopago.id = debito_debitospagos.debitopago_id
                    ),
        NOVOS_CLIENTES AS
                    (SELECT DISTINCT date_trunc('month', honorario.datavencimento)::date AS competencia,
                              to_char( date_trunc('month', honorario.datavencimento)::date, 'MM/YYYY') as competencia_desc,
                              to_char(honorario.datavencimento, 'DD/MM/YYYY') as data_honorario,
                              honorario.datavencimento,
                              honorario.descricao,
                              0 as tipo,
                              CASE WHEN dp.datapagamento IS NULL THEN false ELSE true
					 		                END as pago,
                              CASE WHEN dp.datapagamento IS NULL and coalesce(dp.datavencimento, honorario.datavencimento) < current_date THEN 'vencido' ELSE 'a vencer'
					 		                END as pagamento,
                              honorario.valor,
                              cliente.cpfcnpj,
                              cliente.razaosocial,
                              sistema.nome as sistema,
                              dp.debito_id,
                              dp.datapagamento::date,
                              dp.valorrecebido as valorpago,
                              dp.valor as valordebito,
                              (cidade.nome || '-' || estado.sigla) AS cidade
             FROM honorariomensal honorario
             INNER JOIN parametros ON TRUE
             INNER JOIN financeiro.clientefornecedorfinanceiro cliente ON cliente.id = honorario.clifor_id
             INNER JOIN contrato on contrato.cliente_id = cliente.id and contrato.ativo is true  and honorario.contrato_id = contrato.id
					   LEFT JOIN sistema on sistema.id = contrato.sistema_id
             LEFT JOIN DEBITOS_PAGOS dp on dp.clifor_id = cliente.id
             LEFT JOIN municipio cidade ON cidade.id = cliente.municipio_id
             LEFT JOIN estado ON estado.id = cidade.estado_id
             WHERE honorario.empresa_id in (#{empresa})
               AND honorario.tipo_id = 16
               AND honorario.ativo IS TRUE    
               and ((dp.datapagamento IS NULL AND honorario.datavencimento BETWEEN parametros.data_inicial AND parametros.data_final)
                  or (dp.datapagamento IS NOT NULL AND (dp.datapagamento::date BETWEEN parametros.data_inicial AND parametros.data_final)))         
               AND (parametros.estado_id IS NULL OR parametros.estado_id = estado.id) 
        )
          SELECT *
          FROM NOVOS_CLIENTES
          ORDER BY NOVOS_CLIENTES.tipo,"

          if group.eql? 'PAGAMENTO'
            sql += "
                    NOVOS_CLIENTES.pago desc,
                    NOVOS_CLIENTES.pagamento,
                    NOVOS_CLIENTES.razaosocial"
          elsif ordem.eql? 'debito'
            sql += "NOVOS_CLIENTES.datavencimento,
                    NOVOS_CLIENTES.razaosocial"
          else
            sql += "NOVOS_CLIENTES.razaosocial"
          end
          
          return sql
  end
  def self.get_pesquisas_satisfacao(data_inicial, data_final, empresa_id, tipo_avaliacao, estado, cidade)
    return "
      with parametros as (
        select  '#{data_inicial}'::date as data_inicial,
                '#{data_final}'::date as data_final,
				#{ tipo_avaliacao.present? ? tipo_avaliacao : 'null'}::boolean AS tipo_avaliacao,
				#{ estado.present? ? estado : 'null'}::int AS estado,
				#{ cidade.present? ? cidade : 'null'}::int AS cidade
      )
      select 	pesq.id,
        pesq.data_pesquisa,
        to_char(pesq.data_pesquisa, 'DD/MM/YYYY') as data_pesquisa_desc,
        pesq.avaliacao,
        case when pesq.positivo then 'POSITIVA' else 'NEGATIVA' end as positivo,
        pesq.data_avaliacao,
        to_char(pesq.data_avaliacao, 'DD/MM/YYYY') as data_avaliacao_desc,
        user_avaliacao.name as user_avaliacao,
        user_pesquisa.name as user_pesquisa,
        unaccent(replace(cliente.razao_social, '&', 'E')) as razao_social,
        cliente.cnpj,
        cidade.nome || '-' || estado.sigla as cidade,
        perg1.pergunta as perg1,
        resp1.resposta as resp1,
        perg2.pergunta as perg2,
        resp2.resposta as resp2,
        perg3.pergunta as perg3,
        resp3.resposta as resp3,
        perg4.pergunta as perg4,
        resp4.resposta as resp4,
        perg5.pergunta as perg5,
        resp5.resposta as resp5,
        perg6.pergunta as perg6,
        resp6.resposta as resp6,
        perg7.pergunta as perg7,
        resp7.resposta as resp7,
        perg8.pergunta as perg8,
        resp8.resposta as resp8,
        resp9.resposta as contato

      from pesquisas pesq
      inner join parametros on true
      left join clientes cliente on cliente.id = pesq.cliente_id
	    left join cidades cidade on cidade.id = cliente.cidade_id
      left join estados estado on estado.id = cidade.estado_id
      left join pergunta_pesquisa_respostas resp1 on resp1.pesquisa_id = pesq.id and resp1.pergunta_id = 13
      left join perguntas perg1 on perg1.id = resp1.pergunta_id
      left join pergunta_pesquisa_respostas resp2 on resp2.pesquisa_id = pesq.id and resp2.pergunta_id = 14
      left join perguntas perg2 on perg2.id = resp2.pergunta_id
      left join pergunta_pesquisa_respostas resp3 on resp3.pesquisa_id = pesq.id and resp3.pergunta_id = 15
      left join perguntas perg3 on perg3.id = resp3.pergunta_id
      left join pergunta_pesquisa_respostas resp4 on resp4.pesquisa_id = pesq.id and resp4.pergunta_id = 16
      left join perguntas perg4 on perg4.id = resp4.pergunta_id
      left join pergunta_pesquisa_respostas resp5 on resp5.pesquisa_id = pesq.id and resp5.pergunta_id = 17
      left join perguntas perg5 on perg5.id = resp5.pergunta_id
      left join pergunta_pesquisa_respostas resp6 on resp6.pesquisa_id = pesq.id and resp6.pergunta_id = 18
      left join perguntas perg6 on perg6.id = resp6.pergunta_id
      left join pergunta_pesquisa_respostas resp7 on resp7.pesquisa_id = pesq.id and resp7.pergunta_id = 19
      left join perguntas perg7 on perg7.id = resp7.pergunta_id
      left join pergunta_pesquisa_respostas resp8 on resp8.pesquisa_id = pesq.id and resp8.pergunta_id = 20
      left join perguntas perg8 on perg8.id = resp8.pergunta_id
      left join pergunta_pesquisa_respostas resp9 on resp9.pesquisa_id = pesq.id and resp9.pergunta_id = 21
      left join perguntas perg9 on perg9.id = resp9.pergunta_id
      left join users user_avaliacao on user_avaliacao.id = pesq.user_avaliacao_id
      left join users user_pesquisa on user_pesquisa.id = pesq.user_id
      where data_pesquisa is not null
         and data_pesquisa::date between  parametros.data_inicial and  parametros.data_final
         and (parametros.tipo_avaliacao is null or parametros.tipo_avaliacao = pesq.positivo)
         and pesq.empresa_id in (#{ApplicationHelper.get_empresas_by_codigo(empresa_id)})
		 and (parametros.cidade is null or parametros.cidade = cliente.cidade_id)
		 and (parametros.estado is null or parametros.estado = cidade.estado_id)
      order by data_pesquisa, pesq.id

    "
  end

  def self.pagamento_primeira_parcela_implantacao(data_inicial, data_final, empresa, estado)
    return "
          with parametros as (
              select 	'#{data_inicial}'::date as data_inicial,
                      '#{data_final}'::date as data_fim,
                      #{ estado.present? ? estado : 'null'}::int as estado
          ),
    primeira_parcela_instalacao AS
      ( SELECT d.id AS id,
               coalesce(boleto.datavencimento, d.datavencimento) AS datavencimento,
               coalesce(d.parcela, 1) AS parcela,
               d.clifor_id,
               debitopago.datapagamento
       FROM debitos d
       INNER JOIN financeiro.clientefornecedorfinanceiro c ON c.id = d.clifor_id
       AND c.parceiro IS FALSE
       INNER JOIN tipocobrancavalor tcv ON tcv.debito_id = d.id
       AND tcv.tipocobranca_id = 66
       LEFT JOIN boletogerado boleto ON boleto.id = d.boletogerado_id
       LEFT JOIN debito_debitospagos debito_debitopago ON debito_debitopago.debito_id = d.id
       LEFT JOIN debitospagos debitopago ON debitopago.id = debito_debitopago.debitopago_id
       WHERE d.empresa_id in (#{empresa})
         AND d.status IN ('PENDENTE', 'PAGO', 'PARCIALMENTE_PAGO')
         AND coalesce(d.parcela, 1) = 1
       GROUP BY d.id,
                coalesce(boleto.datavencimento, d.datavencimento),
                parcela,
                d.clifor_id,
                debitopago.datapagamento)
        select distinct	debito.id,
            debito.empresa_id as empresa_id,
            cliente.id as clifor_id,
            cliente.razaosocial,
            cliente.cpfcnpj,
          cidade.nome || '-' || estado.sigla as cidade,
            coalesce(boleto.datavencimento, debito.datavencimento) as datavencimento,
            debitopago.datapagamento::date,
            to_char(debitopago.datapagamento::date, 'DD/MM/YYYY') as data_pagamento_desc,
            debito.valor as mensalidade,
            debito.status as status,
            coalesce(debito.parcela, 1) as parcela,
            debito_debitopago.valorjuros as jurosPago,
            debito_debitopago.valor as valorPago,
            debito_debitopago.valorjuros + debito_debitopago.valor as totalPago
        from primeira_parcela_instalacao pri
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
        and pri.datapagamento between parametros.data_inicial and parametros.data_fim
        and (parametros.estado is null or parametros.estado = estado.id)
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
            debito.parcela,
           debitopago.datapagamento::date,
           debito_debitopago.valorjuros,
           debito_debitopago.valor,
           debitopago.datapagamento
    "
  end

  def self.pagamento_demais_parcelas_implantacao(data_inicial, data_final, empresa, estado)
    return "
          with parametros as (
              select 	'#{data_inicial}'::date as data_inicial,
                      '#{data_final}'::date as data_fim,
                      #{ estado.present? ? estado : 'null'}::int as estado
          ),
    primeira_parcela_instalacao AS
      ( SELECT d.id AS id,
               coalesce(boleto.datavencimento, d.datavencimento) AS datavencimento,
               coalesce(d.parcela, 1) AS parcela,
               d.clifor_id,
               debitopago.datapagamento
       FROM debitos d
       INNER JOIN financeiro.clientefornecedorfinanceiro c ON c.id = d.clifor_id
       AND c.parceiro IS FALSE
       INNER JOIN tipocobrancavalor tcv ON tcv.debito_id = d.id
       AND tcv.tipocobranca_id = 66
       LEFT JOIN boletogerado boleto ON boleto.id = d.boletogerado_id
       LEFT JOIN debito_debitospagos debito_debitopago ON debito_debitopago.debito_id = d.id
       LEFT JOIN debitospagos debitopago ON debitopago.id = debito_debitopago.debitopago_id
       WHERE d.empresa_id in (#{empresa})
         AND d.status IN ('PENDENTE', 'PAGO', 'PARCIALMENTE_PAGO')
         AND coalesce(d.parcela, 1) <> 1
       GROUP BY d.id,
                coalesce(boleto.datavencimento, d.datavencimento),
                parcela,
                d.clifor_id,
                debitopago.datapagamento)
        select distinct	debito.id,
            debito.empresa_id as empresa_id,
            cliente.id as clifor_id,
            cliente.razaosocial,
            cliente.cpfcnpj,
          cidade.nome || '-' || estado.sigla as cidade,
            coalesce(boleto.datavencimento, debito.datavencimento) as datavencimento,
            debitopago.datapagamento::date,
            to_char(debitopago.datapagamento::date, 'DD/MM/YYYY') as data_pagamento_desc,
            debito.valor as mensalidade,
            debito.status as status,
            coalesce(debito.parcela, 1) as parcela,
            debito_debitopago.valorjuros as jurosPago,
            debito_debitopago.valor as valorPago,
            debito_debitopago.valorjuros + debito_debitopago.valor as totalPago
        from primeira_parcela_instalacao pri
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
        and pri.datapagamento between parametros.data_inicial and parametros.data_fim
        and (parametros.estado is null or parametros.estado = estado.id)
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
           debito.parcela,
           debitopago.datapagamento::date,
           debito_debitopago.valorjuros,
           debito_debitopago.valor,
           debitopago.datapagamento
    "
  end


  def self.ranking_cnaes_etapas(data_inicio, data_fim, estado, cidade, empresa, vendedor, implantador, vendas, implantacao, acompanhamento, order, limit)
    return base_sql_ranking_cnaes(data_inicio, data_fim, estado, cidade, empresa, vendedor) +
        "
    ,sql_fechamentos as (
      with fech as (
        select  contato.*
        from contatos contato
        inner join fechamentos on contato.cliente_id = fechamentos.cliente_id #{ vendedor.present? ? ' and contato.user_id = fechamentos.user_id' : ''}
      )
      select 0::int as tipo, fech.id, fech.codigo, fech.descricao, count(cliente_id) as qtd, cnae.total, ROUND(((count(cliente_id)::numeric*100)/cnae.total),2) as indice
      from fech
      left join contatos_cnae cnae on cnae.id = fech.id
      group by fech.id, fech.codigo, fech.descricao, cnae.total
    ),
    sql_implantacoes as (
      with impl as (
        select  contato.*
        from contatos contato
        inner join fechamentos on contato.cliente_id = fechamentos.cliente_id #{ vendedor.present? ? ' and contato.user_id = fechamentos.user_id' : ''}
            inner join implantacoes implantacao on contato.cliente_id = implantacao.cliente_id and implantacao.status = 9 #{ implantador.present? ? " and implantacao.user_id = #{implantador}" : '' }
      )
      select 1::int as tipo, impl.id, impl.codigo, impl.descricao, count(cliente_id) as qtd, cnae.total, ROUND(((count(cliente_id)::numeric*100)/cnae.total),2) as indice
      from impl
      left join contatos_cnae cnae on cnae.id = impl.id
      group by impl.id, impl.codigo, impl.descricao, cnae.total
    ),
    sql_acompanhamentos as (
      with acomp as (
        select  contato.*
        from contatos contato
        inner join fechamentos on contato.cliente_id = fechamentos.cliente_id #{ vendedor.present? ? ' and contato.user_id = fechamentos.user_id' : ''}
            inner join acompanhamentos acompanhamento on contato.cliente_id = acompanhamento.cliente_id and acompanhamento.status = 5 #{ implantador.present? ? " and acompanhamento.user_id = #{implantador}" : '' }
      )
      select 2::int as tipo, acomp.id, acomp.codigo, acomp.descricao, count(cliente_id) as qtd, cnae.total, ROUND(((count(cliente_id)::numeric*100)/cnae.total),2) as indice
      from acomp
      left join contatos_cnae cnae on cnae.id = acomp.id
      group by acomp.id, acomp.codigo, acomp.descricao, cnae.total
    ),
    sql_filter_fech as (
      select *
      from sql_fechamentos
      where #{vendas}
      order by #{ (order == 'QTD') ? 'qtd' : 'indice' } desc limit #{limit}
    ),
    sql_filter_impl as (
      select *
      from sql_implantacoes
      where #{implantacao}
      order by #{ (order == 'QTD') ? 'qtd' : 'indice' } desc limit #{limit}
    ),
    sql_filter_acomp as (
      select *
      from sql_acompanhamentos
      where #{acompanhamento}
      order by #{ (order == 'QTD') ? 'qtd' : 'indice' } desc limit #{limit}
    ),
    sql_total as (
      select *
      from sql_filter_fech
      union all
      select *
      from sql_filter_impl
      union all
      select *
      from sql_filter_acomp
    )
    select *
    from sql_total
    order by tipo
    "
  end

  def self.base_sql_ranking_cnaes(data_inicio, data_fim, estado, cidade, empresa, vendedor)
    return "
        with primeira_ligacao as (
              select lig.cliente_id, min(data_inicio) as data #{ vendedor.present? ? ', lig.user_id' : ''}
              from ligacoes lig
              inner join clientes cliente on cliente.id = lig.cliente_id
              left join cidades cidade on cidade.id = cliente.cidade_id
              where lig.empresa_id in (#{ApplicationHelper.get_empresas_by_codigo(empresa)})
              group by lig.cliente_id #{ vendedor.present? ? ', lig.user_id' : ''}
            ),
          contatos as (
              select pri.cliente_id, cliente.cnpj, cnae.id, cnae.codigo, cnae.descricao #{ vendedor.present? ? ', pri.user_id' : ''}
              from primeira_ligacao pri
              inner join ligacoes ligacao on ligacao.data_inicio = pri.data and pri.cliente_id = ligacao.cliente_id #{ vendedor.present? ? ' and pri.user_id = ligacao.user_id' : ''}
              inner join clientes cliente on cliente.id = ligacao.cliente_id
              left join cidades cidade on cidade.id = cliente.cidade_id
              inner join cnaes cnae on cnae.id = cliente.cnae_id
              where data::date between '#{data_inicio}' and '#{data_fim}'
                and (#{ cidade.present? ? cidade : 'null'} is null or #{ cidade.present? ? cidade : 'null'}::int = cidade.id)
                and (#{ estado.present? ? estado : 'null'} is null or #{ estado.present? ? estado : 'null'}::int = cidade.estado_id)
                and (#{ vendedor.present? ? vendedor : 'null'} is null or #{ vendedor.present? ? vendedor : 'null'}::int = ligacao.user_id)
          ),
          contatos_cnae as(
              select id, codigo, descricao, count(cliente_id) as total
              from contatos
              group by id, codigo, descricao
              order by count(cliente_id) desc
          )

      "
  end

  def self.acompanhamentos_ranking_cnaes(data_inicio, data_fim, estado, cidade, empresa, vendedor, implantador)
    return base_sql_ranking_cnaes(data_inicio, data_fim, estado, cidade, empresa, vendedor) +
        "
        select  contato.*, tot.total
        from contatos contato
        inner join fechamentos on contato.cliente_id = fechamentos.cliente_id #{ vendedor.present? ? ' and contato.user_id = fechamentos.user_id' : ''}
        inner join acompanhamentos acompanhamento on contato.cliente_id = acompanhamento.cliente_id and acompanhamento.status = 5 #{ implantador.present? ? " and acompanhamento.user_id = #{implantador}" : '' }
        left join contatos_cnae tot on tot.id = contato.id
       "
  end

  def self.analise_clientes(empresa, competencia, tipo, cidade, estado, cliente, ainda_cliente, agrupamento)
    return "
    with sql as(
          select distinct
		              controle.empresa_id,
                  clifor.id as cliente_id,
                  clifor.cpfcnpj,
                  clifor.razaosocial,
                  cliente.id,
                  honorario.valor,
                  controle.tipo,
                  case when honorario.cliforparceiro_id is null then false else true end is_parceiro,
                  municipio.nome || '-' || estado.sigla as cidade,
                  estado.nome || '-' || estado.sigla as estado,
                  honorario.ativo as ainda_cliente,
				          date_trunc('month', controle.data_controle)::date data_controle,
                  to_char(date_trunc('month', controle.data_controle), 'MM/YYYY') data_controle_formatada
                from financeiro.controle_bloqueio_business controle
                left join financeiro.controle_bloqueio_business_clientes cliente on controle.id = cliente.controle_bloqueio_business_id
                left join honorariomensal honorario on honorario.id = cliente.honorario_id
                left join financeiro.clientefornecedorfinanceiro clifor on clifor.id = honorario.clifor_id
                left join municipio on municipio.id = clifor.municipio_id
                left join estado on municipio.estado_id = estado.id
                where controle.empresa_id in (#{empresa})
                  #{(agrupamento.eql? 4) ? " and controle.data_controle between '#{(Time.parse(competencia) - 5.month).beginning_of_month.strftime("%Y-%m-%d")}' and '#{competencia}' " : " and controle.data_controle = '#{competencia}' " }
                  and (#{cidade.present? ? cidade : 'null'} is null or #{cidade.present? ? cidade : 'null'} = municipio.id)
                  and (#{estado.present? ? estado : 'null' } is null or #{estado.present? ? estado : 'null'} = estado.id)
                  and (#{cliente.present? ? cliente : 'null' } is null or clifor.id = #{cliente.present? ? cliente : 'null'})
                  #{ (tipo == '1') ? "and (honorario.datavencimento > '#{ (Time.parse(competencia) -3.months).strftime("%Y-%m-%d") }')" : '' }
    #{ (ainda_cliente == '0') ? '' :  ((ainda_cliente == '1') ? ' and honorario.ativo is true ' : ' and honorario.ativo is false ' )}
                  and controle.tipo in ('BLOQUEADO', 'NORMAL')
                  order by cliente.id
),
debitos_vencidos as (
        select 	sql.cliente_id,
		sql.empresa_id,
		count(debito.id)
	from sql
        left join debitos debito on debito.clifor_id = sql.cliente_id and debito.empresa_id = sql.empresa_id and debito.status = 'PENDENTE'
        left join boletogerado boleto on boleto.id = debito.boletogerado_id
        where coalesce(boleto.datavencimento, debito.datavencimento) < current_date
        group by sql.cliente_id, sql.empresa_id
)

select sql.*, case when venc.cliente_id is not null then false else true end as em_dia
from sql
left join debitos_vencidos venc on venc.cliente_id = sql.cliente_id and venc.empresa_id = sql.empresa_id
      "
  end

  def self.buscar_tempo_chamados(competencia, agrupamento)
    begin
      data = {
          datainicio: (agrupamento.eql? 4) ? (Time.parse(competencia) - 5.month).beginning_of_month.strftime("%Y-%m-%d") : Time.parse(competencia).beginning_of_month.strftime("%Y-%m-%d"),
          datafim: Time.parse(competencia).end_of_month.strftime("%Y-%m-%d")
      }
      url = "https://germantech.com.br/chamados/inserts/consulta_tempo_cnpj.php";

      response = RestClient.post url, data.to_json, {content_type: :json, accept: :json}

      resposta = JSON.parse(response)


      if (resposta['message'].eql? "success")
        return resposta['data']
      else
        return nil
      end

    rescue
      return nil
    end
  end

  def self.sql_tempo_chamado(cnpj, datainicio, datafim)
    return "
    select 	cnpj,
		  sum(TIMESTAMPDIFF(SECOND,datainicio,datafinal)) as seconds,
		  'NORMAL' as tipo
    from chamado
    where cast(datafinal as date) BETWEEN '#{datainicio}' and '#{datafim}'
      and cnpj = '#{cnpj}'
    group by cnpj, tipo

    UNION ALL

    select 	cnpj,
        sum(TIMESTAMPDIFF(SECOND, timestamp(CONCAT( data,' ', horainicio )), timestamp(CONCAT( data,' ', horafim )))) as seconds,
        'SABADO' as tipo
    from plantao
    where data BETWEEN '#{datainicio}' and '#{datafim}'
      and DATE_FORMAT(data,'%w') <> 0
      and cnpj = '#{cnpj}'
    group by cnpj, tipo

    UNION ALL

    select 	cnpj,
        sum(TIMESTAMPDIFF(SECOND, timestamp(CONCAT( data,' ', horainicio )), timestamp(CONCAT( data,' ', horafim )))) as seconds,
        'DOMINGO' as tipo
    from plantao
    where data BETWEEN '#{datainicio}' and '#{datafim}'
      and DATE_FORMAT(data,'%w') = 0
      and cnpj = '#{cnpj}'
    group by cnpj, tipo

    "
  end

  def self.periodo_inertes(data_inicial, data_final, empresa_id, tipo_avaliacao, estado, cidade)
    return "
      with parametros as (
          select  '#{data_inicial}'::date as data_inicial,
                '#{data_final}'::date as data_final,
				        #{ tipo_avaliacao.present? ? tipo_avaliacao : 'null'}::boolean AS tipo_avaliacao,
				        #{ estado.present? ? estado : 'null'}::int AS estado,
				        #{ cidade.present? ? cidade : 'null'}::int AS cidade
          )
      select 	periodo.id,
        periodo.data_feedback,
        to_char(periodo.data_feedback, 'DD/MM/YYYY') as data_feedback_desc,
        periodo.avaliacao,
        case when periodo.positivo then 'POSITIVA' else 'NEGATIVA' end as positivo,
        periodo.data_avaliacao,
        to_char(periodo.data_avaliacao, 'DD/MM/YYYY') as data_avaliacao_desc,
        user_avaliacao.name as user_avaliacao,
        user_pesquisa.name as user_feedback,
        unaccent(replace(cliente.razao_social, '&', 'E')) as razao_social,
        cliente.cnpj,
        cidade.nome || '-' || estado.sigla as cidade,
        periodo.feedback,
        periodo.sistema
      from periodo_inertes periodo
      inner join parametros on true
      left join clientes cliente on cliente.id = periodo.cliente_id
	    left join cidades cidade on cidade.id = cliente.cidade_id
      left join estados estado on estado.id = cidade.estado_id
      left join users user_avaliacao on user_avaliacao.id = periodo.user_avaliacao_id
      left join users user_pesquisa on user_pesquisa.id = periodo.user_feedback_id
      where data_feedback is not null
         and data_feedback::date between parametros.data_inicial and  parametros.data_final
         and (parametros.tipo_avaliacao is null or parametros.tipo_avaliacao = periodo.positivo)
         and periodo.empresa_id in (#{ApplicationHelper.get_empresas_by_codigo(empresa_id)})
		 and (parametros.cidade is null or parametros.cidade = cliente.cidade_id)
		 and (parametros.estado is null or parametros.estado = cidade.estado_id)
      order by periodo.data_feedback, periodo.id

    "
  end

  def self.analise_desistencias(data_inicial, data_final, dias_cliente, tipo, empresa)
    return "
        with parametros as (
            select 16::int as tipo_id,
                    null::int as estado,
                    '#{data_inicial}'::date as dataInicial,
                    '#{data_final}'::date as dataFinal
              ),
         desistentes as (
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
                    honorario.empresa_id,
                    tipo.nome,
                    current_date - honorario.datavencimento as dias,
                    honorario.datainativacao::date - honorario.datavencimento::date as dias_cliente,
                    emp.razaosocial as empresaRazaoSocial,
                    sistema.nome as sistema,
                    coalesce(coalesce(contrato.motivoinativacao, honorario.motivoinativacao), '') as motivo
            from honorariomensal honorario
            inner join parametros on true
            inner join financeiro.clientefornecedorfinanceiro cliente on cliente.id = honorario.clifor_id
            inner join municipio on municipio.id = cliente.municipio_id
            inner join estado on municipio.estado_id = estado.id
            inner join tipocobranca tipo on tipo.id = honorario.tipo_id
            inner join empresa emp on emp.id = honorario.empresa_id
            --left join honorariomensal hono on hono.clifor_id = honorario.clifor_id and hono.empresa_id = honorario.empresa_id and hono.tipo_id = honorario.tipo_id and hono.id <> honorario.id
            left join contrato on contrato.id = (select max(id) from contrato where contrato.cliente_id = honorario.clifor_id and contrato.ativo = honorario.ativo and contrato.empresa_id = honorario.empresa_id and contrato.tipocobrancahonorario_id = honorario.tipo_id)
            left join sistema on sistema.id = contrato.sistema_id
            where honorario.empresa_id in (#{empresa})
              and honorario.datainativacao between parametros.dataInicial and parametros.dataFinal
              and (parametros.tipo_id is null or honorario.tipo_id = parametros.tipo_id)
              and (parametros.estado is null or estado.id = parametros.estado)
              --and hono.id is null
              and honorario.ativo is false
              and (honorario.datainativacao > honorario.datavencimento)
              order by honorario.datainativacao desc
        ),
        debitos_pendentes as (
        select cliente_id, honorario_id, count(debitos.id) qtd, sum(debitos.saldo) valor
        from desistentes
        inner join debitos on debitos.empresa_id= desistentes.empresa_id and debitos.clifor_id = desistentes.cliente_id and debitos.status in ('PENDENTE', 'PARCIALMENTE_PAGO')
        group by cliente_id, honorario_id
        ),
        debitos_pagos as (
        with pagamentos as (
        select cliente_id, honorario_id, debitos.id, pgt.valor, pgt.valorjuros
        from desistentes
        inner join debitos on debitos.empresa_id= desistentes.empresa_id and debitos.clifor_id = desistentes.cliente_id and debitos.status in ('PAGO', 'PARCIALMENTE_PAGO')
        inner join debito_debitospagos pgt on pgt.debito_id = debitos.id
        ),
        total_pago as (
        select cliente_id, honorario_id, count(id) as qtd, sum(valor + valorjuros) as valor
        from pagamentos
        group by cliente_id, honorario_id
        ),
        qtd_parcelas as (
        select cliente_id, honorario_id, count(pagamentos.id) as qtd
        from pagamentos
        inner join tipocobrancavalor tcv on tcv.debito_id = pagamentos.id and tcv.tipocobranca_id= 16
        group by cliente_id, honorario_id
        )
        select desistentes.cliente_id, desistentes.honorario_id, qtd_parcelas.qtd, total_pago.valor
        from desistentes
        left join total_pago on total_pago.cliente_id = desistentes.cliente_id and total_pago.honorario_id = desistentes.honorario_id
        left join qtd_parcelas on qtd_parcelas.cliente_id = desistentes.cliente_id and qtd_parcelas.honorario_id = desistentes.honorario_id
        ),
        implantacao as (
        with tem_debito_implantacao as (
        select cliente_id, honorario_id
        from desistentes
        inner join debitos on debitos.empresa_id= desistentes.empresa_id and debitos.clifor_id = desistentes.cliente_id and debitos.status in ('PAGO')
        inner join tipocobrancavalor tcv on tcv.debito_id = debitos.id and tcv.tipocobranca_id= 66
        group by cliente_id, honorario_id
        )
        select desistentes.cliente_id, desistentes.honorario_id, case when impl.cliente_id is null then false else true end pagou_implantacao
        from desistentes
        left join tem_debito_implantacao impl on impl.cliente_id = desistentes.cliente_id and impl.honorario_id = desistentes.honorario_id
        )
        select desistentes.*,
               coalesce(ped.qtd,0) as qtd_pendente,
               coalesce(ped.valor,0) as valor_pendente,
               coalesce(pag.qtd,0) as qtd_pago,
               coalesce(pag.valor,0) as valor_pago,
               impl.pagou_implantacao,
               extract(month from desistentes.datainativacao) mes,
               extract(year from desistentes.datainativacao) as ano,
               to_char(desistentes.datainativacao, 'MM/YYYY') as mesAno
        from desistentes
        left join debitos_pendentes ped on ped.cliente_id = desistentes.cliente_id and ped.honorario_id = desistentes.honorario_id
        left join debitos_pagos pag on pag.cliente_id = desistentes.cliente_id and pag.honorario_id = desistentes.honorario_id
        left join implantacao impl on impl.cliente_id = desistentes.cliente_id and impl.honorario_id = desistentes.honorario_id
        where desistentes.dias_cliente <= #{ dias_cliente }
          and (#{ tipo } in (0,2) or coalesce(pag.qtd,0) > 0)
          and (#{ tipo } in (0,1) or coalesce(pag.qtd,0) = 0)
          order by extract(year from desistentes.datainativacao), extract(month from desistentes.datainativacao), desistentes.dias_cliente
      "
  end

  def self.analise_bloqueados_paralisados(dias_cliente, tipo, empresa, dias_paralizado, detalhado)
    return "
    with parametros as (
      select #{tipo}::int as tipo,
      #{dias_cliente.present? ? dias_cliente : 'null'}::int as dias_cliente,
      #{dias_paralizado.present? ? dias_paralizado : 'null'}::int as dias_paralizado,
      #{detalhado}::boolean as detalhado
    ),
     sql as (
    select honorario.datavencimento,
        to_char(honorario.datavencimento, 'DD/MM/YYYY') as datavencimento_desc,
        (current_date - honorario.datavencimento::date) as dias_cliente, cliente.id as cliente_id,
                        cliente.razaosocial as razaosocial,
                        cliente.cpfcnpj,
              municipio.id as municipio_id,
                        (municipio.nome || '-' || estado.sigla)  as municipio,
              sistema.nome as sistema,
              honorario.valor,
			  controle.empresa_id,
              cliente.telefone,
              cliente.celular,
              controle.tipo,
              null as dataparalizacao,
              null as dataparalizacao_desc,
              null as dias_paralizado
    from financeiro.controle_bloqueio_business controle
    inner join parametros on true
    left join financeiro.controle_bloqueio_business_clientes cli on cli.controle_bloqueio_business_id = controle.id
    left join honorariomensal honorario on honorario.id = cli.honorario_id
    left join contrato on contrato.id = honorario.contrato_id
    left join sistema on sistema.id = contrato.sistema_id
    left join financeiro.clientefornecedorfinanceiro cliente on cliente.id = cli.cliente_id
    left join municipio on municipio.id = cliente.municipio_id
    left join estado on municipio.estado_id = estado.id
    where controle.empresa_id in (#{empresa})
      and controle.tipo = 'BLOQUEADO'
      and controle.data_controle = (date_trunc('month', current_date) + interval '1 month') - interval '1 day'
      and (parametros.tipo in (0,1))

    union all

    select honorario.datavencimento,
        to_char(honorario.datavencimento, 'DD/MM/YYYY') as datavencimento_desc,
        (current_date - honorario.datavencimento::date) as dias_cliente,
        cliente.id as cliente_id,
                        cliente.razaosocial as razaosocial,
                        cliente.cpfcnpj,
              municipio.id as municipio_id,
                        (municipio.nome || '-' || estado.sigla)  as municipio,
              sistema.nome as sistema,
              honorario.valor,
			  controle.empresa_id,
              cliente.telefone,
              cliente.celular,
              controle.tipo,
              honorario.dataparalizacao,
              to_char(honorario.dataparalizacao, 'DD/MM/YYYY') as dataparalizacao_desc,
              (current_date - honorario.dataparalizacao::date) as dias_paralizado
    from financeiro.controle_bloqueio_business controle
    inner join parametros on true
    left join financeiro.controle_bloqueio_business_clientes cli on cli.controle_bloqueio_business_id = controle.id
    left join honorariomensal honorario on honorario.id = cli.honorario_id
    left join contrato on contrato.id = honorario.contrato_id
    left join sistema on sistema.id = contrato.sistema_id
    left join financeiro.clientefornecedorfinanceiro cliente on cliente.id = cli.cliente_id
    left join municipio on municipio.id = cliente.municipio_id
    left join estado on municipio.estado_id = estado.id
    where controle.empresa_id in (#{empresa})
      and controle.tipo = 'PARALISADO'
      and controle.data_controle = (date_trunc('month', current_date) + interval '1 month') - interval '1 day'
      and (parametros.tipo in (0,2))
      and (parametros.dias_paralizado is null or (current_date - honorario.dataparalizacao::date) >= parametros.dias_paralizado)
    ),
	debitos_vencidos as (
        select sql.cliente_id, sql.empresa_id,  count(debitos.id) qtd, sum(debitos.saldo) valor
        from sql
        left join debitos on debitos.empresa_id= sql.empresa_id and debitos.clifor_id = sql.cliente_id and debitos.status in ('PENDENTE', 'PARCIALMENTE_PAGO')
		left join boletogerado boleto on boleto.id = debitos.boletogerado_id
		where coalesce(boleto.datavencimento, debitos.datavencimento) < current_date
        group by sql.cliente_id, sql.empresa_id
    ),
	count_contatos as (
		select sql.cliente_id, sql.empresa_id, cob.id, count(lig.id) as qtd
		from sql
		inner join financeiro.cobranca cob on cob.empresa_id = sql.empresa_id and sql.cliente_id = cob.cliente_id and cob.finalizada is false
		left join financeiro.ligacao lig on lig.cobranca_id = cob.id
		group by sql.cliente_id, sql.empresa_id, cob.id
		having count(lig.id) > 2
	),
	contatos as (
		with ligacoes as (
		  select
			 row_number() over (partition by lig.cobranca_id order by lig.data desc) as rownum
			, lig.data, lig.historico, usuario.nome, lig.cobranca_id
			from financeiro.ligacao lig
			inner join financeiro.cobranca cob on cob.finalizada is false and cob.id = lig.cobranca_id
			left join usuario on usuario.id = lig.usuario_id
			where cob.empresa_id in (#{empresa})
			order by cobranca_id, row_number() over (partition by lig.cobranca_id order by lig.data desc) desc
		)
		select sql.*, to_char(ligacoes.data, 'DD/MM/YYYY HH24:MI') as data_desc, ligacoes.data, ligacoes.historico, ligacoes.nome, true as detalhado
		from sql
		inner join count_contatos cont on cont.empresa_id = sql.empresa_id and cont.cliente_id = sql.cliente_id
		left join ligacoes on ligacoes.cobranca_id = cont.id
		where ligacoes.rownum <= 3
	),
	sql_final as (
     select sql.*,  contatos.data_desc, contatos.data, contatos.historico, contatos.nome, true as detalhado, coalesce(deb.qtd,0) as qtd_vencido, coalesce(deb.valor, 0) as valor_vencido
	  from sql
    left join contatos on contatos.cliente_id = sql.cliente_id and contatos.empresa_id = sql.empresa_id
    inner join parametros on true
 	left join debitos_vencidos deb on deb.cliente_id = sql.cliente_id and deb.empresa_id = sql.empresa_id
    where parametros.detalhado is true

 	UNION ALL
     select sql.*, null as data_desc, null as data, null as historico, null as nome, false as detalhado, coalesce(deb.qtd,0) as qtd_vencido, coalesce(deb.valor, 0) as valor_vencido
     from sql
 	left join debitos_vencidos deb on deb.cliente_id = sql.cliente_id and deb.empresa_id = sql.empresa_id


		)
		select sql_final.*
		from sql_final
		     inner join parametros on true
 		where (parametros.dias_cliente is null or sql_final.dias_cliente <= parametros.dias_cliente)
 		order by sql_final.tipo, sql_final.dias_cliente, sql_final.cliente_id, sql_final.detalhado
    "
  end

  def self.relatorio_contratos_assinados(data_inicio, data_fim, efetivo, status)
    "
      with parametros as (
        select 
                array#{status}::int []  as status
      )
      select cliente.id, razao_social, cnpj, (cidade.nome || '-' || estado.sigla) as cidade, assinou_contrato, impl.status,
        impl.user_id as implantador_id, user_impl.name as implantador, prop.valor_mensalidade as mensalidade, fidelidade, coalesce(meses_fidelidade,-1) as meses_fidelidade,
        fecha.user_id as vendedor_id, user_fecha.name as vendedor, sistema.nome as sistema, TO_CHAR(impl.data_inicio, 'DD/MM/YYYY') as data_impl
      from clientes cliente
      left join parametros on true
      inner join implantacoes impl on impl.cliente_id = cliente.id
      inner join propostas prop on prop.id = impl.proposta_id and prop.ativa
      inner join users user_impl on user_impl.id = impl.user_id
      left join cidades cidade on cidade.id = cliente.cidade_id
      left join estados estado on estado.id = cidade.estado_id
      inner join fechamentos fecha on fecha.cliente_id = cliente.id  
      inner join users user_fecha on user_fecha.id = fecha.user_id
      left join pacotes on pacotes.id = prop.pacote_id
      left join sistemas sistema on sistema.id = pacotes.sistema_id
      where data_inicio::date between '#{data_inicio}' and '#{data_fim}'
        AND (parametros.status = array[]::int[] or impl.status = any(parametros.status))
      order by assinou_contrato desc, razao_social
    
    "
  end
end

