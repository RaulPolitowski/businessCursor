module DashboardsResultadosTabelasHelper

  def self.table_efetivacoes(empresa, estado_id, data_inicio, data_fim, tipo, id, efetivacao, vendedor_id, implantador_id)
    return "with sql as (
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
          implantador.name as implantador,
          vendedor.name as vendedor,
          cidade.nome || '-' || estado.sigla as cidade,
          'ACOMPANHAMENTO' as tipo
        from acompanhamentos acompanhamento
        left join clientes cliente on cliente.id = acompanhamento.cliente_id
        left join cidades cidade on cidade.id = cliente.cidade_id
        left join estados estado on estado.id = cidade.estado_id
        left join fechamentos f on f.id =  (select max(id) from fechamentos where cliente_id = cliente.id)
        left join propostas proposta on proposta.id = (select id from propostas where propostas.cliente_id = cliente.id and propostas.ativa is true order by id desc limit 1)
        left join pacotes pacote on pacote.id = proposta.pacote_id
        left join sistemas sistema on sistema.id = pacote.sistema_id
        left join implantacoes implantacao on implantacao.id = (select max(id) from implantacoes where cliente_id = cliente.id)
        left join users implantador on implantador.id = implantacao.user_id
        left join users vendedor on vendedor.id = f.user_id
        where (#{ApplicationHelper.get_estado_by_codigo(estado_id)} is null or #{ApplicationHelper.get_estado_by_codigo(estado_id)} = cidade.estado_id)
          and acompanhamento.data_fim::date between '#{data_inicio}'::date and '#{data_fim}'::date
          and acompanhamento.status = 5
          and acompanhamento.empresa_id in (#{ApplicationHelper.get_empresas_by_codigo(empresa)})
          and (#{vendedor_id.blank? ? 'null' : vendedor_id} is null or #{vendedor_id.blank? ? 'null' : vendedor_id} = f.user_id)
          and (#{implantador_id.blank? ? 'null' : implantador_id} is null or #{implantador_id.blank? ? 'null' : implantador_id} = implantacao.user_id)
          #{ id.present? && tipo == '1' ? "and vendedor.id = #{id}" : ""}
          #{ id.present? && tipo == '2' ? "and implantador.id = #{id}" : ""}

        UNION ALL

        select
            implantacao.id,
            implantacao.data_inicio,
            implantacao.data_fim,
            implantacao.status,
            implantacao.empresa_id,
            cliente.razao_social,
            cliente.cnpj,
            proposta.valor_mensalidade as mensalidade,
            proposta.valor_implantacao as implantacao,
            sistema.nome as sistema,
            implantador.name as implantador,
            vendedor.name as vendedor,
            cidade.nome || '-' || estado.sigla as cidade,
             true as efetivo,
             'IMPLANTACAO' as tipo
        from implantacoes implantacao
        left join clientes cliente on cliente.id = implantacao.cliente_id
        left join cidades cidade on cidade.id = cliente.cidade_id
        left join estados estado on estado.id = cidade.estado_id
        left join fechamentos f on f.id =  (select max(id) from fechamentos where cliente_id = cliente.id)
        left join propostas proposta on proposta.id = (select id from propostas where propostas.cliente_id = cliente.id and propostas.ativa is true order by id desc limit 1)
        left join pacotes pacote on pacote.id = proposta.pacote_id
        left join sistemas sistema on sistema.id = pacote.sistema_id
        left join users implantador on implantador.id = implantacao.user_id
	      left join users vendedor on vendedor.id = f.user_id
        left join acompanhamentos acompanhamento on acompanhamento.cliente_id = implantacao.cliente_id
        where (#{ApplicationHelper.get_estado_by_codigo(estado_id)} is null or #{ApplicationHelper.get_estado_by_codigo(estado_id)} = cidade.estado_id)
          and implantacao.data_fim::date between '#{data_inicio}'::date and '#{data_fim}'::date
          and implantacao.status = 9
          and implantacao.empresa_id in (#{ApplicationHelper.get_empresas_by_codigo(empresa)})
          and acompanhamento.status not in (3,4)
          and (#{vendedor_id.blank? ? 'null' : vendedor_id} is null or #{vendedor_id.blank? ? 'null' : vendedor_id} = f.user_id)
          and (#{implantador_id.blank? ? 'null' : implantador_id} is null or #{implantador_id.blank? ? 'null' : implantador_id} = implantacao.user_id)
        )
        select *
        from sql
        #{ (efetivacao.eql? "true") ? " where sql.efetivo is true " : " where tipo = 'ACOMPANHAMENTO' " }
        order by sql.data_fim desc"
  end

  def self.table_implantacoes(empresa, estado_id, data_inicio, data_fim, tipo, id, vendedor_id, implantador_id)
    return "select 	implantacao.id,
          implantacao.data_inicio,
          implantacao.data_fim,
          implantacao.status,
          implantacao.empresa_id,
          cliente.razao_social,
          cliente.cnpj,
          proposta.valor_mensalidade as mensalidade,
          proposta.valor_implantacao as implantacao,
          sistema.nome as sistema,
          implantador.name as implantador,
          vendedor.name as vendedor,
          cidade.nome || '-' || estado.sigla as cidade
        from implantacoes implantacao
        left join clientes cliente on cliente.id = implantacao.cliente_id
        left join cidades cidade on cidade.id = cliente.cidade_id
        left join estados estado on estado.id = cidade.estado_id
        left join fechamentos f on f.id =  (select max(id) from fechamentos where cliente_id = cliente.id)
        left join propostas proposta on proposta.id = (select id from propostas where propostas.cliente_id = cliente.id and propostas.ativa is true order by id desc limit 1)
        left join pacotes pacote on pacote.id = proposta.pacote_id
        left join sistemas sistema on sistema.id = pacote.sistema_id
        left join users implantador on implantador.id = implantacao.user_id
        left join users vendedor on vendedor.id = f.user_id
        where (#{ApplicationHelper.get_estado_by_codigo(estado_id)} is null or #{ApplicationHelper.get_estado_by_codigo(estado_id)} = cidade.estado_id)
          and implantacao.data_fim::date between '#{data_inicio}'::date and '#{data_fim}'::date
          and implantacao.status = 9
          and implantacao.empresa_id in (#{ApplicationHelper.get_empresas_by_codigo(empresa)})
          and (#{vendedor_id.blank? ? 'null' : vendedor_id} is null or #{vendedor_id.blank? ? 'null' : vendedor_id} = f.user_id)
          and (#{implantador_id.blank? ? 'null' : implantador_id} is null or #{implantador_id.blank? ? 'null' : implantador_id} = implantacao.user_id)
        #{ id.present? && tipo == '1' ? "and vendedor.id = #{id}" : ""}
        #{ id.present? && tipo == '2' ? "and implantador.id = #{id}" : ""}
          order by implantacao.data_fim desc"
  end

  def self.table_desistencia_acompanhamento(empresa, estado_id, data_inicio, data_fim, vendedor_id, implantador_id)
    return "select 	acompanhamento.id,
                    acompanhamento.data_inicio,
                    acompanhamento.data_fim,
                    (acompanhamento.data_fim::date - acompanhamento.data_inicio::date) dias_acompanhamento,
                    acompanhamento.status,
                    acompanhamento.empresa_id,
                    cliente.razao_social,
                    cliente.cnpj,
                    proposta.valor_mensalidade as mensalidade,
                    proposta.valor_implantacao as implantacao,
                    sistema.nome as sistema,
                    implantador.name as implantador,
                    vendedor.name as vendedor,
                    cidade.nome || '-' || estado.sigla as cidade,
                    acompanhamento.motivo
          from acompanhamentos acompanhamento
          left join clientes cliente on cliente.id = acompanhamento.cliente_id
          left join cidades cidade on cidade.id = cliente.cidade_id
          left join estados estado on estado.id = cidade.estado_id
          left join fechamentos f on f.id =  (select max(id) from fechamentos where cliente_id = cliente.id)
          left join propostas proposta on proposta.id = (select id from propostas where propostas.cliente_id = cliente.id and propostas.ativa is true order by id desc limit 1)
          left join pacotes pacote on pacote.id = proposta.pacote_id
          left join sistemas sistema on sistema.id = pacote.sistema_id
          left join implantacoes implantacao on implantacao.id = (select max(id) from implantacoes where cliente_id = cliente.id)
          left join users implantador on implantador.id = implantacao.user_id
          left join users vendedor on vendedor.id = f.user_id
          where (#{ApplicationHelper.get_estado_by_codigo(estado_id)} is null or #{ApplicationHelper.get_estado_by_codigo(estado_id)} = cidade.estado_id)
            and acompanhamento.data_fim::date between '#{data_inicio}'::date and '#{data_fim}'::date
            and acompanhamento.status in (3,4)
            and acompanhamento.empresa_id in (#{ApplicationHelper.get_empresas_by_codigo(empresa)})
            and (#{vendedor_id.blank? ? 'null' : vendedor_id} is null or #{vendedor_id.blank? ? 'null' : vendedor_id} = f.user_id)
            and (#{implantador_id.blank? ? 'null' : implantador_id} is null or #{implantador_id.blank? ? 'null' : implantador_id} = implantacao.user_id)
          order by acompanhamento.data_fim desc"
  end

  def self.table_desistencia_implantacao(empresa, estado_id, data_inicio, data_fim, status, vendedor_id, implantador_id)
    return "select 	implantacao.id,
                    implantacao.data_inicio,
                    implantacao.data_fim,
                    implantacao.status,
                    implantacao.empresa_id,
                    (implantacao.data_fim::date - implantacao.data_inicio::date) as dias_implantacao,
                    (implantacao.data_inicio::date - f.data_fechamento::date) as dias_aguardando,
                    f.data_fechamento as data_fechamento,
                    cliente.razao_social,
                    cliente.cnpj,
                    proposta.valor_mensalidade as mensalidade,
                    proposta.valor_implantacao as implantacao,
                    sistema.nome as sistema,
                    implantador.name as implantador,
                    vendedor.name as vendedor,
                    cidade.nome || '-' || estado.sigla as cidade,
                    implantacao.motivo
          from implantacoes implantacao
          left join clientes cliente on cliente.id = implantacao.cliente_id
          left join cidades cidade on cidade.id = cliente.cidade_id
          left join estados estado on estado.id = cidade.estado_id
          left join fechamentos f on f.id =  (select max(id) from fechamentos where cliente_id = cliente.id)
          left join propostas proposta on proposta.id = (select id from propostas where propostas.cliente_id = cliente.id and propostas.ativa is true order by id desc limit 1)
          left join pacotes pacote on pacote.id = proposta.pacote_id
          left join sistemas sistema on sistema.id = pacote.sistema_id
          left join users implantador on implantador.id = implantacao.user_id
          left join users vendedor on vendedor.id = f.user_id
          where (#{ApplicationHelper.get_estado_by_codigo(estado_id)} is null or #{ApplicationHelper.get_estado_by_codigo(estado_id)} = cidade.estado_id)
            and implantacao.data_fim::date between '#{data_inicio}'::date and '#{data_fim}'::date
            and implantacao.status in  (#{status})
            and implantacao.empresa_id in (#{ApplicationHelper.get_empresas_by_codigo(empresa)})
            and (#{vendedor_id.blank? ? 'null' : vendedor_id} is null or #{vendedor_id.blank? ? 'null' : vendedor_id} = f.user_id)
            and (#{implantador_id.blank? ? 'null' : implantador_id} is null or #{implantador_id.blank? ? 'null' : implantador_id} = implantacao.user_id)
          order by implantacao.data_fim desc"
  end

  def self.table_efetivacoes_financeiro(estado, empresa, data_inicio, data_fim)
    return "
          with parametros as (
            select 	16::int as tipo_id,
                    #{ estado.present? ? estado : 'null'}::int as estado
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
            emp.razaosocial as empresaRazaoSocial,
            sistema.nome as sistema
    from honorariomensal honorario
    inner join parametros on true
    inner join financeiro.clientefornecedorfinanceiro cliente on cliente.id = honorario.clifor_id
    inner join municipio on municipio.id = cliente.municipio_id
    inner join estado on municipio.estado_id = estado.id
    inner join tipocobranca tipo on tipo.id = honorario.tipo_id
    inner join empresa emp on emp.id = honorario.empresa_id
    left join honorariomensal hono on hono.clifor_id = honorario.clifor_id and hono.empresa_id = honorario.empresa_id and hono.tipo_id = honorario.tipo_id and hono.id <> honorario.id and hono.ativo is false
    left join contrato on contrato.id = (select max(id) from contrato where contrato.cliente_id = honorario.clifor_id and contrato.ativo = honorario.ativo and contrato.empresa_id = honorario.empresa_id and contrato.tipocobrancahonorario_id = honorario.tipo_id)
    left join sistema on sistema.id = contrato.sistema_id
    where honorario.empresa_id in (#{empresa})
      and (parametros.estado is null or estado.id = parametros.estado)
      and (parametros.tipo_id is null or honorario.tipo_id = parametros.tipo_id)
      and hono.id is not null
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
            emp.razaosocial as empresaRazaoSocial,
            sistema.nome as sistema
    from honorariomensal honorario
    inner join parametros on true
    inner join financeiro.clientefornecedorfinanceiro cliente on cliente.id = honorario.clifor_id
    inner join municipio on municipio.id = cliente.municipio_id
    inner join estado on municipio.estado_id = estado.id
    inner join tipocobranca tipo on tipo.id = honorario.tipo_id
    inner join empresa emp on emp.id = honorario.empresa_id
    left join honorariomensal hono on hono.clifor_id = honorario.clifor_id and hono.empresa_id = honorario.empresa_id and hono.tipo_id = honorario.tipo_id and hono.id <> honorario.id
    left join contrato on contrato.id = (select max(id) from contrato where contrato.cliente_id = honorario.clifor_id and contrato.ativo = honorario.ativo and contrato.empresa_id = honorario.empresa_id and contrato.tipocobrancahonorario_id = honorario.tipo_id)
    left join sistema on sistema.id = contrato.sistema_id
    where honorario.empresa_id in (#{empresa})
      and (parametros.tipo_id is null or honorario.tipo_id = parametros.tipo_id)
      and (parametros.estado is null or estado.id = parametros.estado)
      and hono.id is null
      and honorario.datavencimento between '#{data_inicio}'::date and '#{data_fim}'::date
      and (honorario.datainativacao is null or honorario.datainativacao > honorario.datavencimento)
  )
  select *
  from sql
  order by sql.datainicial desc
  "
  end

  def self.table_efetivacoes_financeiroReal(estado, empresa, data_inicio, data_fim)
    return "
    with parametros as (
      select #{ estado.present? ? estado : 'null'}::int as estado_id,
             1::integer as tipo
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
         bloqueado.databloqueio,
         (bloqueado.databloqueio < current_date) as bloqueado,
         TO_CHAR(ligacao.data, 'DD/MM/YYYY HH24:MI') as ultima_ligacao,
         ligacao.historico,
         usuario_ligacao.nome as usuario_ligacao,
         retorno.dataretorno
       from primeira_parcela_mensalidade pri
       inner join debitos debito on debito.id = pri.id
       inner join parametros on true
       inner join financeiro.clientefornecedorfinanceiro cliente on cliente.id = debito.clifor_id
       left join municipio cidade on cidade.id = cliente.municipio_id
       left join estado on estado.id = cidade.estado_id
       left join debito_debitospagos debito_debitopago on debito_debitopago.debito_id = debito.id
       left join debitospagos debitopago on debitopago.id = debito_debitopago.debitopago_id
       left join boletogerado boleto on boleto.id = debito.boletogerado_id
       left join contrato on contrato.cliente_id = cliente.id and contrato.ativo is true
       left join financeiro.empresabloqueada bloqueado on bloqueado.contrato_id = contrato.id
       left join financeiro.cobranca cobranca on cobranca.id = (select max(c.id) from financeiro.cobranca c where  c.cliente_id = cliente.id and c.empresa_id = debito.empresa_id and c.finalizada is false)
       left join financeiro.ligacao ligacao on ligacao.id = (select l.id from financeiro.ligacao l where  l.cobranca_id = cobranca.id order by data desc limit 1)
       left join financeiro.retornocobranca retorno on retorno.id = ligacao.retornocobranca_id
       left join usuario usuario_ligacao on usuario_ligacao.id = ligacao.usuario_id
       where debito.status in ('PAGO')
       and debito.empresa_id in  (#{empresa})
       and (parametros.estado_id is null or parametros.estado_id = estado.id)
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
          bloqueado.databloqueio,
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
         bloqueado.databloqueio,
         (bloqueado.databloqueio < current_date) as bloqueado,
         TO_CHAR(ligacao.data, 'DD/MM/YYYY HH24:MI') as ultima_ligacao,
         ligacao.historico,
         usuario_ligacao.nome as usuario_ligacao,
         retorno.dataretorno
     from primeira_parcela_mensalidade pri
     inner join debitos debito on debito.id = pri.id
     inner join parametros on true
     inner join financeiro.clientefornecedorfinanceiro cliente on cliente.id = debito.clifor_id
     left join municipio cidade on cidade.id = cliente.municipio_id
     left join estado on estado.id = cidade.estado_id
     left join boletogerado boleto on boleto.id = debito.boletogerado_id
     left join contrato on contrato.cliente_id = cliente.id and contrato.ativo is true
     left join financeiro.empresabloqueada bloqueado on bloqueado.contrato_id = contrato.id
     left join financeiro.cobranca cobranca on cobranca.id = (select max(c.id) from financeiro.cobranca c where  c.cliente_id = cliente.id and c.empresa_id = debito.empresa_id and c.finalizada is false)
     left join financeiro.ligacao ligacao on ligacao.id = (select l.id from financeiro.ligacao l where  l.cobranca_id = cobranca.id order by data desc limit 1)
     left join financeiro.retornocobranca retorno on retorno.id = ligacao.retornocobranca_id
     left join usuario usuario_ligacao on usuario_ligacao.id = ligacao.usuario_id
     where debito.status in ('PENDENTE', 'PARCIALMENTE_PAGO')
     and debito.empresa_id in (#{empresa})
     and (parametros.estado_id is null or parametros.estado_id = estado.id)
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
        bloqueado.databloqueio,
        ligacao.data,
        ligacao.historico,
        usuario_ligacao.nome,
        retorno.dataretorno
     )
     select sql.empresa_id,
            sql.clifor_id,
            sql.razaosocial,
            sql.cpfcnpj,
            cidade,
            estado,
            sigla,
            sql.datavencimento,
            sql.datapagamento,
            sql.valor,
            sql.status,
            sql.jurosPago,
            sql.valorPago,
            sql.qtd_dias,
            sql.databloqueio,
            sql.bloqueado,
            sql.ultima_ligacao,
            sql.historico,
            sql.usuario_ligacao,
            sql.dataretorno,
            nome as sistema,
            valormensalidade
     from sql
   left join contrato on contrato.id = (select max(id) from contrato where contrato.cliente_id = sql.clifor_id and contrato.empresa_id = sql.empresa_id and contrato.tipocobrancahonorario_id = 16)
     left join sistema on sistema.id = contrato.sistema_id
     where sql.id <> 499521
     order by sql.datapagamento desc
  "
  end

  def self.table_desistencia_financeiro(estado, empresa, data_inicio, data_fim)
    return "
      with parametros as (
            select 	16::int as tipo_id,
                    #{ estado.present? ? estado : 'null'}::int as estado
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
            sistema.nome as sistema,
            coalesce(coalesce(honorario.motivoinativacao, contrato.motivoinativacao), '') as motivo
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
      and honorario.datainativacao between '#{data_inicio}'::date and '#{data_fim}'::date
      and (parametros.tipo_id is null or honorario.tipo_id = parametros.tipo_id)
      and (parametros.estado is null or estado.id = parametros.estado)
      --and hono.id is null
      and honorario.ativo is false
      and (honorario.datainativacao > honorario.datavencimento)
      order by honorario.datainativacao desc"
  end

  def self.table_desistencia_financeiroReal(estado, empresa, data_inicio, data_fim, cnpjs)
    return "
      with parametros as (
            select 	16::int as tipo_id,
            #{ estado.present? ? estado : 'null'}::int as estado
      ),
      sqlInativos as (select  cliente.id as cliente_id,
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
            emp.id as empresa_id,
            emp.razaosocial as empresaRazaoSocial,
            sistema.nome as sistema,
            coalesce(coalesce(honorario.motivoinativacao, contrato.motivoinativacao), '') as motivo
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
      and honorario.datainativacao between '#{data_inicio}'::date and '#{data_fim}'::date
      and (parametros.tipo_id is null or honorario.tipo_id = parametros.tipo_id)
      and (parametros.estado is null or estado.id = parametros.estado)
      --and hono.id is null
      and honorario.ativo is false
      and cpfcnpj::bigint NOT IN (#{cnpjs})
      and (honorario.datainativacao > honorario.datavencimento)
    )
    select cliente_id,
          razaosocial,
          sql.cpfcnpj,
          municipio_id,
          municipio,
          estado,
          sigla,
          honorario_id,
          datainicial,
          datainativacao,
          sql.valor,
          tipo_id,
          ativo,
          nome,
          dias,
          dias_cliente,
          sql.empresa_id,
          sql.empresaRazaoSocial,
          sistema,
          sql.motivo
          from sqlInativos sql
          inner join debitos d on d.id = (select min(debitos.id) from debitos 
                                        inner join tipocobrancavalor tc on tc.debito_id = debitos.id and tc.tipocobranca_id = 16
                                      where debitos.clifor_id = sql.cliente_id and debitos.empresa_id = sql.empresa_id
                                        and debitos.status in ('PENDENTE', 'PAGO', 'PARCIALMENTE_PAGO'))
          
          where d.status = 'PAGO'
          order by datainativacao desc "
  end

  def self.table_efetivacoes_financeiro_2meses(estado, empresa, data_inicio, data_fim, qtd_mes, cnpjs)
    return "
    with parametros as (
      select #{ estado.present? ? estado : 'null'}::int as estado_id,
             1::integer as tipo
     ),
     MENSALIDADES AS (
      with todos_debitos as (
        select distinct c.clifor_id, c.datacompetencia as datacompetencia, c.id as id,
          row_number() over (partition by c.clifor_id order by c.datacompetencia) as rownum
          from debitos c
          inner join tipocobrancavalor tc on tc.debito_id = c.id and tc.tipocobranca_id = 16
          where c.status in ('PENDENTE', 'PAGO', 'PARCIALMENTE_PAGO')
          and c.empresa_id in (#{empresa})
          order by c.clifor_id, c.datacompetencia
      )
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
         bloqueado.databloqueio,
         (bloqueado.databloqueio < current_date) as bloqueado,
         TO_CHAR(ligacao.data, 'DD/MM/YYYY HH24:MI') as ultima_ligacao,
         ligacao.historico,
         usuario_ligacao.nome as usuario_ligacao,
         retorno.dataretorno
       from MENSALIDADES pri
       inner join debitos debito on debito.id = pri.id
       inner join parametros on true
       inner join financeiro.clientefornecedorfinanceiro cliente on cliente.id = debito.clifor_id
       left join municipio cidade on cidade.id = cliente.municipio_id
       left join estado on estado.id = cidade.estado_id
       left join debito_debitospagos debito_debitopago on debito_debitopago.debito_id = debito.id
       left join debitospagos debitopago on debitopago.id = debito_debitopago.debitopago_id
       left join boletogerado boleto on boleto.id = debito.boletogerado_id
       left join contrato on contrato.cliente_id = cliente.id and contrato.ativo is true
       left join financeiro.empresabloqueada bloqueado on bloqueado.contrato_id = contrato.id
       left join financeiro.cobranca cobranca on cobranca.id = (select max(c.id) from financeiro.cobranca c where  c.cliente_id = cliente.id and c.empresa_id = debito.empresa_id and c.finalizada is false)
       left join financeiro.ligacao ligacao on ligacao.id = (select l.id from financeiro.ligacao l where  l.cobranca_id = cobranca.id order by data desc limit 1)
       left join financeiro.retornocobranca retorno on retorno.id = ligacao.retornocobranca_id
       left join usuario usuario_ligacao on usuario_ligacao.id = ligacao.usuario_id
       where debito.status in ('PAGO')
       and debito.empresa_id in  (#{empresa})
       and (parametros.estado_id is null or parametros.estado_id = estado.id)
       and pri.datapagamento between '#{data_inicio}'::date and '#{data_fim}'::date
       and cpfcnpj::bigint NOT IN (#{cnpjs})
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
          bloqueado.databloqueio,
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
         bloqueado.databloqueio,
         (bloqueado.databloqueio < current_date) as bloqueado,
         TO_CHAR(ligacao.data, 'DD/MM/YYYY HH24:MI') as ultima_ligacao,
         ligacao.historico,
         usuario_ligacao.nome as usuario_ligacao,
         retorno.dataretorno
     from MENSALIDADES pri
     inner join debitos debito on debito.id = pri.id
     inner join parametros on true
     inner join financeiro.clientefornecedorfinanceiro cliente on cliente.id = debito.clifor_id
     left join municipio cidade on cidade.id = cliente.municipio_id
     left join estado on estado.id = cidade.estado_id
     left join boletogerado boleto on boleto.id = debito.boletogerado_id
     left join contrato on contrato.cliente_id = cliente.id and contrato.ativo is true
     left join financeiro.empresabloqueada bloqueado on bloqueado.contrato_id = contrato.id
     left join financeiro.cobranca cobranca on cobranca.id = (select max(c.id) from financeiro.cobranca c where  c.cliente_id = cliente.id and c.empresa_id = debito.empresa_id and c.finalizada is false)
     left join financeiro.ligacao ligacao on ligacao.id = (select l.id from financeiro.ligacao l where  l.cobranca_id = cobranca.id order by data desc limit 1)
     left join financeiro.retornocobranca retorno on retorno.id = ligacao.retornocobranca_id
     left join usuario usuario_ligacao on usuario_ligacao.id = ligacao.usuario_id
     where debito.status in ('PENDENTE', 'PARCIALMENTE_PAGO')
     and debito.empresa_id in (#{empresa})
     and (parametros.estado_id is null or parametros.estado_id = estado.id)
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
        bloqueado.databloqueio,
        ligacao.data,
        ligacao.historico,
        usuario_ligacao.nome,
        retorno.dataretorno
     )
     select sql.empresa_id,
            sql.clifor_id,
            sql.razaosocial,
            sql.cpfcnpj,
            cidade,
            estado,
            sigla,
            sql.datavencimento,
            sql.datapagamento,
            sql.valor,
            sql.status,
            sql.jurosPago,
            sql.valorPago,
            sql.qtd_dias,
            sql.databloqueio,
            sql.bloqueado,
            sql.ultima_ligacao,
            sql.historico,
            sql.usuario_ligacao,
            sql.dataretorno,
            nome as sistema,
            valormensalidade
     from sql
   left join contrato on contrato.id = (select max(id) from contrato where contrato.cliente_id = sql.clifor_id and contrato.empresa_id = sql.empresa_id and contrato.tipocobrancahonorario_id = 16)
     left join sistema on sistema.id = contrato.sistema_id
     where sql.id <> 499521
     order by sql.datapagamento desc
  "
  end

  def self.table_desistencia_financeiro_2meses(estado, empresa, data_inicio, data_fim, qtd_mes, cnpjs)
    return "
      with parametros as (
            select 	16::int as tipo_id,
                    #{ estado.present? ? estado : 'null'}::int as estado
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
                  from qtd_debitos
                  inner join debitos debito on debito.id = qtd_debitos.id_debito and debito.clifor_id = qtd_debitos.clifor_id
                  left join boletogerado boleto on boleto.id = debito.boletogerado_id
                  left join debito_debitospagos debito_debitopago on debito_debitopago.debito_id = debito.id
                  left join debitospagos debitopago on debitopago.id = debito_debitopago.debitopago_id
                  where debito.id <> 499521
                  group by debito.id, debito.clifor_id, coalesce(boleto.datavencimento, debito.datavencimento), debitopago.datapagamento
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
            sistema.nome as sistema,
            coalesce(coalesce(honorario.motivoinativacao, contrato.motivoinativacao), '') as motivo
    from honorariomensal honorario
    inner join parametros on true
    inner join financeiro.clientefornecedorfinanceiro cliente on cliente.id = honorario.clifor_id
    inner join municipio on municipio.id = cliente.municipio_id
    inner join estado on municipio.estado_id = estado.id
    inner join tipocobranca tipo on tipo.id = honorario.tipo_id
    inner join empresa emp on emp.id = honorario.empresa_id
    left join MENSALIDADES pri on pri.clifor_id = cliente.id
    left join contrato on contrato.id = (select max(id) from contrato where contrato.cliente_id = honorario.clifor_id and contrato.ativo = honorario.ativo and contrato.empresa_id = honorario.empresa_id and contrato.tipocobrancahonorario_id = honorario.tipo_id)
    left join sistema on sistema.id = contrato.sistema_id
    where honorario.empresa_id in (#{empresa})
      and pri.status = 'PAGO'
      and honorario.datainativacao between '#{data_inicio}'::date and '#{data_fim}'::date
      and (parametros.tipo_id is null or honorario.tipo_id = parametros.tipo_id)
      and (parametros.estado is null or estado.id = parametros.estado)
      and honorario.ativo is false
      and cpfcnpj::bigint NOT IN (#{cnpjs})
      and (honorario.datainativacao > honorario.datavencimento)
      order by honorario.datainativacao desc"
  end

  def self.table_primeira_parcela(estado, empresa, data_inicio, data_fim, tipo)
    return "with parametros as (
       select #{ estado.present? ? estado : 'null'}::int as estado_id,
              #{tipo}::integer as tipo,
              #{data_inicio.present? ? "'#{data_inicio}'" : 'null'}::date as data_inicio,
              #{data_fim.present? ? "'#{data_fim}'" : 'null'}::date as data_fim
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
      sql as (
        select debito.id,
          debito.empresa_id as empresa_id,
          cliente.id as clifor_id,
          cliente.razaosocial,
          cliente.cpfcnpj,
          cliente.nomecontato,
          cliente.telefone,
          cliente.celular,
          (cidade.nome || '-' || estado.sigla) as cidade,
          (estado.nome || '-' || estado.sigla) as estado,
          estado.sigla,
          coalesce(boleto.datavencimento, debito.datavencimento) as datavencimento,
          to_char(coalesce(boleto.datavencimento, debito.datavencimento), 'DD/MM/YYYY') as datavencimento_desc,
          debitopago.datapagamento::date,
          debito.valor,
          debito.status as status,
          debito_debitopago.valorjuros as jurosPago,
          debito_debitopago.valor as valorPago,
          null::integer as qtd_dias,
          bloqueado.databloqueio,
          (bloqueado.databloqueio < current_date) as bloqueado,
          TO_CHAR(ligacao.data, 'DD/MM/YYYY HH24:MI') as ultima_ligacao,
          ligacao.historico,
          usuario_ligacao.nome as usuario_ligacao,
          retorno.dataretorno,
		      sistema.nome as sistema
        from primeira_parcela_mensalidade pri
        inner join debitos debito on debito.id = pri.id
        inner join parametros on true
        inner join financeiro.clientefornecedorfinanceiro cliente on cliente.id = debito.clifor_id
        left join municipio cidade on cidade.id = cliente.municipio_id
        left join estado on estado.id = cidade.estado_id
        left join debito_debitospagos debito_debitopago on debito_debitopago.debito_id = debito.id
        left join debitospagos debitopago on debitopago.id = debito_debitopago.debitopago_id
        left join boletogerado boleto on boleto.id = debito.boletogerado_id
        left join contrato on contrato.cliente_id = cliente.id and contrato.ativo is true and contrato.gerado is true
		    left join sistema on sistema.id = contrato.sistema_id
        left join financeiro.empresabloqueada bloqueado on bloqueado.contrato_id = contrato.id
        left join financeiro.cobranca cobranca on cobranca.id = (select max(c.id) from financeiro.cobranca c where  c.cliente_id = cliente.id and c.empresa_id = debito.empresa_id and c.finalizada is false)
        left join financeiro.ligacao ligacao on ligacao.id = (select l.id from financeiro.ligacao l where  l.cobranca_id = cobranca.id order by data desc limit 1)
        left join financeiro.retornocobranca retorno on retorno.id = ligacao.retornocobranca_id
        left join usuario usuario_ligacao on usuario_ligacao.id = ligacao.usuario_id
        where debito.status in ('PAGO')
        and debito.empresa_id in (#{empresa})
        and (parametros.estado_id is null or parametros.estado_id = estado.id)
        and (parametros.data_inicio is null or pri.datapagamento >= parametros.data_inicio)
        and (parametros.data_fim is null or pri.datapagamento <= parametros.data_fim)
        and parametros.tipo = 1
        group by debito.id,
           debito.empresa_id,
           cliente.id,
           cliente.razaosocial,
           cliente.nomecontato,
           cliente.telefone,
           cliente.celular,
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
           bloqueado.databloqueio,
           ligacao.data,
           ligacao.historico,
           usuario_ligacao.nome,
           retorno.dataretorno,
		       sistema

      union all

        select debito.id,
          debito.empresa_id as empresa_id,
          cliente.id as clifor_id,
          cliente.razaosocial,
          cliente.cpfcnpj,
          cliente.nomecontato,
		      cliente.telefone,
		      cliente.celular,
          (cidade.nome || '-' || estado.sigla) as cidade,
          (estado.nome || '-' || estado.sigla) as estado,
          estado.sigla,
	        coalesce(boleto.datavencimento, debito.datavencimento) as datavencimento,
          to_char(coalesce(boleto.datavencimento, debito.datavencimento), 'DD/MM/YYYY') as datavencimento_desc,
	        null::date as datapagamento,
          debito.valor,
          debito.status as status,
          null::numeric as jurosPago,
          null::numeric as valorPago,
          current_date - coalesce(boleto.datavencimento, debito.datavencimento) as qtd_dias,
          bloqueado.databloqueio,
          (bloqueado.databloqueio < current_date) as bloqueado,
          TO_CHAR(ligacao.data, 'DD/MM/YYYY HH24:MI') as ultima_ligacao,
          ligacao.historico,
          usuario_ligacao.nome as usuario_ligacao,
          retorno.dataretorno,
		      sistema.nome as sistema
      from primeira_parcela_mensalidade pri
      inner join debitos debito on debito.id = pri.id
      inner join parametros on true
      inner join financeiro.clientefornecedorfinanceiro cliente on cliente.id = debito.clifor_id
      left join municipio cidade on cidade.id = cliente.municipio_id
      left join estado on estado.id = cidade.estado_id
      left join boletogerado boleto on boleto.id = debito.boletogerado_id
      left join contrato on contrato.cliente_id = cliente.id and contrato.ativo is true and contrato.gerado is true
	    left join sistema on sistema.id = contrato.sistema_id
      left join financeiro.empresabloqueada bloqueado on bloqueado.contrato_id = contrato.id
      left join financeiro.cobranca cobranca on cobranca.id = (select max(c.id) from financeiro.cobranca c where  c.cliente_id = cliente.id and c.empresa_id = debito.empresa_id and c.finalizada is false)
      left join financeiro.ligacao ligacao on ligacao.id = (select l.id from financeiro.ligacao l where  l.cobranca_id = cobranca.id order by data desc limit 1)
      left join financeiro.retornocobranca retorno on retorno.id = ligacao.retornocobranca_id
      left join usuario usuario_ligacao on usuario_ligacao.id = ligacao.usuario_id
      where debito.status in ('PENDENTE', 'PARCIALMENTE_PAGO')
      and debito.empresa_id in (#{empresa})
      and (parametros.estado_id is null or parametros.estado_id = estado.id)
      and pri.datavencimento < current_date
      and parametros.tipo = 2
      group by debito.id,
         debito.empresa_id,
         cliente.id,
         cliente.razaosocial,
         cliente.nomecontato,
         cliente.telefone,
         cliente.celular,
         cidade.nome,
         (estado.nome || '-' || estado.sigla),
         estado.sigla,
         debito.datavencimento,
         debito.valor,
         debito.status,
         boleto.datavencimento,
         bloqueado.databloqueio,
         ligacao.data,
         ligacao.historico,
         usuario_ligacao.nome,
         retorno.dataretorno,
		      sistema
      )
      select *
      from sql
      where id <> 499521
      order by #{tipo == '1' ? 'sql.datapagamento desc' : 'sql.datavencimento desc'}"
  end

  def self.table_primeira_parcela_instalacao(estado, empresa, data_inicio, data_fim, tipo)
    return "
    WITH parametros AS
    ( SELECT #{ estado.present? ? estado : 'null'}::int as estado_id,
              #{tipo}::integer as tipo ),
     primeira_parcela_instalacao AS
    ( SELECT d.id AS idDebito,
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
              debitopago.datapagamento),
     SQL AS
    ( SELECT debito.id,
             debito.empresa_id AS empresa_id,
             cliente.id AS clifor_id,
             cliente.razaosocial,
             cliente.cpfcnpj,
             (cidade.nome || '-' || estado.sigla) AS cidade,
             (estado.nome || '-' || estado.sigla) AS estado,
             estado.sigla,
             coalesce(boleto.datavencimento, debito.datavencimento) AS datavencimento,
             debito.valor,
             debito.status AS status,
             debitopago.datapagamento::date datapagamento,
             tcv.valor AS valorTipo,
             sum(debito_debitopago.valorjuros) AS jurosPago,
             CASE
                 WHEN debito.valor = tcv.valor THEN (CASE
                                                         WHEN debito.status = 'PARCIALMENTE_PAGO' THEN (debito.valor - debito.saldo)
                                                         ELSE tcv.valor
                                                     END)
                 ELSE (CASE
                           WHEN debito.status = 'PARCIALMENTE_PAGO' THEN round((((debito.valor - debito.saldo)/100)*trunc(((tcv.valor * 100)/(case when debito.valor = 0 then 1 else debito.valor end)),2)),2)
                           ELSE tcv.valor
                       END)
             END AS valorPagoTipo,
             sum(debito_debitopago.valor) AS valorPagoTotal,
             NULL::integer AS qtd_dias,
            bloqueado.databloqueio,
            (bloqueado.databloqueio < current_date) as bloqueado,
            TO_CHAR(ligacao.data, 'DD/MM/YYYY HH24:MI') as ultima_ligacao,
            ligacao.historico,
            usuario_ligacao.nome as usuario_ligacao
     FROM primeira_parcela_instalacao pri_parcela
     INNER JOIN parametros ON TRUE
     INNER JOIN debitos debito ON debito.id = pri_parcela.idDebito
     INNER JOIN tipocobrancavalor tcv ON tcv.debito_id = debito.id
     AND tcv.tipocobranca_id = 66
     INNER JOIN financeiro.clientefornecedorfinanceiro cliente ON cliente.id = debito.clifor_id
     LEFT JOIN debito_debitospagos debito_debitopago ON debito_debitopago.debito_id = pri_parcela.idDebito
     LEFT JOIN debitospagos debitopago ON debitopago.id = debito_debitopago.debitopago_id
     LEFT JOIN municipio cidade ON cidade.id = cliente.municipio_id
     LEFT JOIN estado ON estado.id = cidade.estado_id
     LEFT JOIN boletogerado boleto ON boleto.id = debito.boletogerado_id
     left join contrato on contrato.cliente_id = cliente.id and contrato.ativo is true
     left join financeiro.empresabloqueada bloqueado on bloqueado.contrato_id = contrato.id
     left join financeiro.cobranca cobranca on cobranca.id = (select max(c.id) from financeiro.cobranca c where  c.cliente_id = cliente.id and c.empresa_id = debito.empresa_id and c.finalizada is false)
     left join financeiro.ligacao ligacao on ligacao.id = (select l.id from financeiro.ligacao l where  l.cobranca_id = cobranca.id order by data desc limit 1)
     left join usuario usuario_ligacao on usuario_ligacao.id = ligacao.usuario_id
     WHERE debito.status IN ('PAGO')
       AND debito.empresa_id in (#{empresa})
       AND coalesce(debito.parcela, 1) = 1
       AND (parametros.estado_id IS NULL OR parametros.estado_id = estado.id)
       AND pri_parcela.datapagamento between '#{data_inicio}'::date and '#{data_fim}'::date
       AND parametros.tipo = 1
     GROUP BY debito.id,
              debito.empresa_id,
              cliente.id,
              cliente.razaosocial,
              cidade.nome, (estado.nome || '-' || estado.sigla), estado.sigla,
                                                                 coalesce(boleto.datavencimento, debito.datavencimento),
                                                                 debito.valor,
                                                                 debito.status,
                                                                 debitopago.datapagamento::date,
                                                                 tcv.valor,
                                                                 bloqueado.databloqueio,
                                                                 ligacao.data,
                                                                 ligacao.historico,
                                                                 usuario_ligacao.nome
     UNION ALL SELECT debito.id,
                      debito.empresa_id AS empresa_id,
                      cliente.id AS clifor_id,
                      cliente.razaosocial,
                      cliente.cpfcnpj,
                      (cidade.nome || '-' || estado.sigla) AS cidade,
                      (estado.nome || '-' || estado.sigla) AS estado,
                      estado.sigla,
                      coalesce(boleto.datavencimento, debito.datavencimento) AS datavencimento,
                      debito.valor,
                      debito.status AS status,
                      debitopago.datapagamento::date,
                      tcv.valor AS valorTipo,
                      sum(debito_debitopago.valorjuros) AS jurosPago,
                      CASE
                          WHEN debito.valor = tcv.valor THEN (CASE
                                                                  WHEN debito.status = 'PARCIALMENTE_PAGO' THEN (debito.valor - debito.saldo)
                                                                  ELSE tcv.valor
                                                              END)
                          ELSE (CASE
                                    WHEN debito.status = 'PARCIALMENTE_PAGO' THEN round((((debito.valor - debito.saldo)/100)*trunc(((tcv.valor * 100)/(case when debito.valor = 0 then 1 else debito.valor end)),2)),2)
                                    ELSE tcv.valor
                                END)
                      END AS valorPagoTipo,
                      sum(debito_debitopago.valor) AS valorPagoTotal,
                      (CURRENT_DATE - pri_parcela.datavencimento) AS qtd_dias,
                      bloqueado.databloqueio,
                      (bloqueado.databloqueio < current_date) as bloqueado,
                      TO_CHAR(ligacao.data, 'DD/MM/YYYY HH24:MI') as ultima_ligacao,
                      ligacao.historico,
                      usuario_ligacao.nome as usuario_ligacao
     FROM primeira_parcela_instalacao pri_parcela
     INNER JOIN parametros ON TRUE
     INNER JOIN debitos debito ON debito.id = pri_parcela.idDebito
     INNER JOIN tipocobrancavalor tcv ON tcv.debito_id = debito.id
     AND tcv.tipocobranca_id = 66
     INNER JOIN financeiro.clientefornecedorfinanceiro cliente ON cliente.id = debito.clifor_id
     LEFT JOIN debito_debitospagos debito_debitopago ON debito_debitopago.debito_id = pri_parcela.idDebito
     LEFT JOIN debitospagos debitopago ON debitopago.id = debito_debitopago.debitopago_id
     LEFT JOIN municipio cidade ON cidade.id = cliente.municipio_id
     LEFT JOIN estado ON estado.id = cidade.estado_id
     LEFT JOIN boletogerado boleto ON boleto.id = debito.boletogerado_id
     left join contrato on contrato.cliente_id = cliente.id and contrato.ativo is true
     left join financeiro.empresabloqueada bloqueado on bloqueado.contrato_id = contrato.id
      left join financeiro.cobranca cobranca on cobranca.id = (select max(c.id) from financeiro.cobranca c where  c.cliente_id = cliente.id and c.empresa_id = debito.empresa_id and c.finalizada is false)
      left join financeiro.ligacao ligacao on ligacao.id = (select l.id from financeiro.ligacao l where  l.cobranca_id = cobranca.id order by data desc limit 1)
      left join usuario usuario_ligacao on usuario_ligacao.id = ligacao.usuario_id
     WHERE debito.status IN ('PENDENTE', 'PARCIALMENTE_PAGO')
       AND debito.empresa_id in (#{empresa})
       AND coalesce(debito.parcela, 1) = 1
       AND (parametros.estado_id IS NULL OR parametros.estado_id = estado.id)
       AND pri_parcela.datavencimento < CURRENT_DATE
       AND parametros.tipo = 2
     GROUP BY debito.id,
              debito.empresa_id,
              cliente.id,
              cliente.razaosocial,
              cidade.nome, (estado.nome || '-' || estado.sigla), estado.sigla,
                                                                 coalesce(boleto.datavencimento, debito.datavencimento),
                                                                 debito.valor,
                                                                 debito.status,
                                                                 debitopago.datapagamento::date,
                                                                 tcv.valor,
                                                                 pri_parcela.datavencimento,
                                                                 bloqueado.databloqueio,
                                                                  ligacao.data,
                                                                  ligacao.historico,
                                                                  usuario_ligacao.nome )
    SELECT *
    FROM SQL
    order by #{tipo == '1' ? 'sql.datapagamento desc' : 'sql.datavencimento desc'}"
  end

  def self.table_historico_cobranca_cliente(cliente_id, empresa)
    return "select  ligacao.data as dt_ligacao,
                    TO_CHAR(ligacao.data, 'DD/MM/YYYY HH12:MI') as data,
                    usuario.nome,
                    ligacao.conseguiucontato,
                    ligacao.contato,
                    ligacao.historico,
                    coalesce(TO_CHAR(retorno.dataretorno, 'DD/MM/YYYY HH24:MI'), '') as dataretorno,
                    cliente.razaosocial
            from financeiro.cobranca
            inner join financeiro.ligacao on ligacao.cobranca_id = cobranca.id
            left join financeiro.retornocobranca retorno on retorno.id = ligacao.retornocobranca_id
            left join financeiro.clientefornecedorfinanceiro cliente on cliente.id = financeiro.cobranca.cliente_id
            inner join usuario on usuario.id = ligacao.usuario_id
            where cobranca.cliente_id = #{cliente_id}
              and cobranca.empresa_id in (#{empresa})
              and cobranca.finalizada is false
            order by ligacao.data desc
  "
  end

  def self.table_clientes_ativos_bloqueados(estado, empresa, tipo, competencia)
    return "
      WITH parametros AS
      ( 
        SELECT '#{competencia}'::date AS competencia,
                #{ estado.present? ? estado : 'null'}::int as estado
      ),
      sql as 
      (
        SELECT honorario.id AS honorarioid,
               honorario.datavencimento,
               honorario.descricao,
               honorario.valor,
               honorario.cliforparceiro_id,
               cliente.id AS clienteid,
               cliente.razaosocial,
               cliente.cpfcnpj,
               CURRENT_DATE - honorario.datavencimento::date AS dias_cliente,
               honorario.empresa_id,
               municipio.nome || '-' || estado.sigla AS cidade,
               coalesce(sistema.nome, '') AS sistema,
               CASE
                  WHEN controle.tipo = 'BLOQUEADO' THEN true
                  ELSE false
               END AS bloqueado,
               bloq.databloqueio,
               CURRENT_DATE - bloq.databloqueio::date AS dias_bloq,
               case when bloq.motivo is null or trim(bloq.motivo) = '' then 'Sem motivo informado.' else bloq.motivo end as motivo
        from financeiro.controle_bloqueio_business controle
        inner join parametros on true
        left join financeiro.controle_bloqueio_business_clientes controle_cliente on controle.id = controle_cliente.controle_bloqueio_business_id
        inner join honorariomensal honorario on honorario.id = controle_cliente.honorario_id
        left JOIN financeiro.clientefornecedorfinanceiro cliente ON cliente.id = honorario.clifor_id
        LEFT JOIN municipio ON municipio.id = cliente.municipio_id
        LEFT JOIN estado ON estado.id = municipio.estado_id
	      LEFT JOIN contrato ON contrato.id = (SELECT max(id)
                                             FROM contrato
                                             WHERE contrato.cliente_id = honorario.clifor_id
                                              AND contrato.ativo = honorario.ativo
                                              AND contrato.empresa_id = honorario.empresa_id
                                              AND contrato.tipocobrancahonorario_id = honorario.tipo_id
                                            )
        LEFT JOIN sistema ON sistema.id = contrato.sistema_id
        left join financeiro.empresabloqueada bloq on bloq.contrato_id = contrato.id
        WHERE honorario.empresa_id  in (#{empresa})
	            and controle.data_controle = parametros.competencia
              AND honorario.tipo_id = 16
              AND (parametros.estado IS NULL OR municipio.estado_id = parametros.estado)
              AND controle.tipo in (#{tipo})
              AND CASE WHEN to_char(competencia, 'MM') = to_char(CURRENT_DATE, 'MM')
                THEN (bloq.databloqueio::DATE <= (CURRENT_DATE - INTERVAL '7 day'))
                ELSE true
              END
      ),
      count_contatos as (
        select sql.clienteid, sql.empresa_id, cob.id, count(lig.id) as qtd
        from sql
        inner join financeiro.cobranca cob on cob.empresa_id = sql.empresa_id and sql.clienteid = cob.cliente_id and cob.finalizada is false
        left join financeiro.ligacao lig on lig.cobranca_id = cob.id
        group by sql.clienteid, sql.empresa_id, cob.id
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
        select sql.clienteid, rownum, ligacoes.data, to_char(ligacoes.data, 'DD/MM/YYYY HH24:MI') as data_desc, ligacoes.historico, ligacoes.nome as usuario
        from sql
        inner join count_contatos cont on cont.empresa_id = sql.empresa_id and cont.clienteid = sql.clienteid
        left join ligacoes on ligacoes.cobranca_id = cont.id
        order by cobranca_id, rownum
      )
      select distinct ON (sql.clienteid) sql.*, cont1.data::date , cont1.data_desc || ' - ' || current_Date - cont1.data::date || ' dias atás - <b>' || cont1.usuario || '</b> - ' || cont1.historico || '<br><br>' ||
				cont2.data_desc || ' - ' || current_Date - cont2.data::Date || ' dias atás - <b>' || cont2.usuario || '</b> - ' || cont2.historico as hist_ligacoes
      from sql
      left join contatos cont1 on cont1.clienteid = sql.clienteid and cont1.rownum = 1
      left join contatos cont2 on cont2.clienteid = sql.clienteid and cont2.rownum = 2
            "
  end

  def self.table_clientes_bloqueados_atualmente(estado, empresa, competencia)
    return "
      WITH parametros AS
      ( 
        SELECT '#{competencia}'::date AS competencia,
                #{ estado.present? ? estado : 'null'}::int as estado
      ),
      sql as
      (
        SELECT honorario.id AS honorarioid,
               honorario.datavencimento,
               honorario.descricao,
               honorario.valor,
               honorario.cliforparceiro_id,
               cliente.id AS clienteid,
               cliente.razaosocial,
               cliente.cpfcnpj,
               CURRENT_DATE - honorario.datavencimento::date AS dias_cliente,
               honorario.empresa_id,
               municipio.nome || '-' || estado.sigla AS cidade,
               coalesce(sistema.nome, '') AS sistema,
               CASE
                  WHEN controle.tipo = 'BLOQUEADO' THEN true
                  ELSE false
               END AS bloqueado,
               bloq.databloqueio,
               CURRENT_DATE - bloq.databloqueio::date AS dias_bloq,
               case when bloq.motivo is null or trim(bloq.motivo) = '' then 'Sem motivo informado.' else bloq.motivo end as motivo
        from financeiro.controle_bloqueio_business controle
        inner join parametros on true
        left join financeiro.controle_bloqueio_business_clientes controle_cliente on controle.id = controle_cliente.controle_bloqueio_business_id
        inner join honorariomensal honorario on honorario.id = controle_cliente.honorario_id
        left JOIN financeiro.clientefornecedorfinanceiro cliente ON cliente.id = honorario.clifor_id
        LEFT JOIN municipio ON municipio.id = cliente.municipio_id
        LEFT JOIN estado ON estado.id = municipio.estado_id
	      LEFT JOIN contrato ON contrato.id = (SELECT max(id)
                                             FROM contrato
                                             WHERE contrato.cliente_id = honorario.clifor_id
                                              AND contrato.ativo = honorario.ativo
                                              AND contrato.empresa_id = honorario.empresa_id
                                              AND contrato.tipocobrancahonorario_id = honorario.tipo_id
                                            )
        LEFT JOIN sistema ON sistema.id = contrato.sistema_id
        left join financeiro.empresabloqueada bloq on bloq.contrato_id = contrato.id
        WHERE honorario.empresa_id  in (#{empresa})
	            and controle.data_controle = parametros.competencia
              AND honorario.tipo_id = 16
              AND (parametros.estado IS NULL OR municipio.estado_id = parametros.estado)
              AND (honorario.datainativacao IS NULL
                  OR (honorario.datainativacao > parametros.competencia
                      AND honorario.ativo IS FALSE))
              AND bloq.databloqueio::DATE BETWEEN (CURRENT_DATE - INTERVAL '7 day') AND CURRENT_DATE
              ORDER BY honorario.datavencimento desc
      ),
      count_contatos as (
        select sql.clienteid, sql.empresa_id, cob.id, count(lig.id) as qtd
        from sql
        inner join financeiro.cobranca cob on cob.empresa_id = sql.empresa_id and sql.clienteid = cob.cliente_id and cob.finalizada is false
        left join financeiro.ligacao lig on lig.cobranca_id = cob.id
        group by sql.clienteid, sql.empresa_id, cob.id
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
        select sql.clienteid, rownum, ligacoes.data, to_char(ligacoes.data, 'DD/MM/YYYY HH24:MI') as data_desc, ligacoes.historico, ligacoes.nome as usuario
        from sql
        inner join count_contatos cont on cont.empresa_id = sql.empresa_id and cont.clienteid = sql.clienteid
        left join ligacoes on ligacoes.cobranca_id = cont.id
        where ligacoes.rownum <= 2
        order by cobranca_id, rownum
      )	
      select distinct on (cont1.clienteid) sql.*, cont1.data::date , cont1.data_desc || ' - ' || current_Date - cont1.data::date || ' dias atás - <b>' || cont1.usuario || '</b> - ' || cont1.historico || '<br><br>' ||
				cont2.data_desc || ' - ' || current_Date - cont2.data::Date || ' dias atás - <b>' || cont2.usuario || '</b> - ' || cont2.historico as hist_ligacoes
      from sql
      left join contatos cont1 on cont1.clienteid = sql.clienteid and cont1.rownum = 1
      left join contatos cont2 on cont2.clienteid = sql.clienteid and cont2.rownum = 2
            "
  end

  def self.get_cliente_UF(empresa, tipo, competencia)
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
               municipio.nome || '-' || estado.sigla AS cidade,
               estado.sigla,
               coalesce(sistema.nome, '') AS sistema,
               CASE
                  WHEN controle.tipo = 'BLOQUEADO' THEN true
                  ELSE false
               END AS bloqueado,
               bloq.databloqueio,
               case when bloq.motivo is null or trim(bloq.motivo) = '' then 'Sem motivo informado.' else bloq.motivo end as motivo
          from financeiro.controle_bloqueio_business controle
          inner join parametros on true
          left join financeiro.controle_bloqueio_business_clientes controle_cliente on controle.id = controle_cliente.controle_bloqueio_business_id
          inner join honorariomensal honorario on honorario.id = controle_cliente.honorario_id
          left JOIN financeiro.clientefornecedorfinanceiro cliente ON cliente.id = honorario.clifor_id
          LEFT JOIN municipio ON municipio.id = cliente.municipio_id
          LEFT JOIN estado ON estado.id = municipio.estado_id
	  LEFT JOIN contrato ON contrato.id =
		  (SELECT max(id)
		   FROM contrato
		   WHERE contrato.cliente_id = honorario.clifor_id
		     AND contrato.ativo = honorario.ativo
		     AND contrato.empresa_id = honorario.empresa_id
		     AND contrato.tipocobrancahonorario_id = honorario.tipo_id)
          LEFT JOIN sistema ON sistema.id = contrato.sistema_id
          left join financeiro.empresabloqueada bloq on bloq.contrato_id = contrato.id
        WHERE honorario.empresa_id  in (#{empresa})
	  and controle.data_controle = parametros.competencia
          AND honorario.tipo_id = 16
          AND (honorario.datainativacao IS NULL
               OR (honorario.datainativacao > parametros.competencia
                   AND honorario.ativo IS FALSE))
          AND controle.tipo in (#{tipo})
          ORDER BY honorario.datavencimento desc
            "
  end

  def self.cliente_UF_ativo_Real(empresa, data_inicio, data_fim)
    return "
    with parametros as (
      select 1::integer as tipo
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
         bloqueado.databloqueio,
         (bloqueado.databloqueio < current_date) as bloqueado,
         TO_CHAR(ligacao.data, 'DD/MM/YYYY HH24:MI') as ultima_ligacao,
         ligacao.historico,
         usuario_ligacao.nome as usuario_ligacao,
         retorno.dataretorno
       from primeira_parcela_mensalidade pri
       inner join debitos debito on debito.id = pri.id
       inner join parametros on true
       inner join financeiro.clientefornecedorfinanceiro cliente on cliente.id = debito.clifor_id
       left join municipio cidade on cidade.id = cliente.municipio_id
       left join estado on estado.id = cidade.estado_id
       left join debito_debitospagos debito_debitopago on debito_debitopago.debito_id = debito.id
       left join debitospagos debitopago on debitopago.id = debito_debitopago.debitopago_id
       left join boletogerado boleto on boleto.id = debito.boletogerado_id
       left join contrato on contrato.cliente_id = cliente.id and contrato.ativo is true
       left join financeiro.empresabloqueada bloqueado on bloqueado.contrato_id = contrato.id
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
          bloqueado.databloqueio,
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
         bloqueado.databloqueio,
         (bloqueado.databloqueio < current_date) as bloqueado,
         TO_CHAR(ligacao.data, 'DD/MM/YYYY HH24:MI') as ultima_ligacao,
         ligacao.historico,
         usuario_ligacao.nome as usuario_ligacao,
         retorno.dataretorno
     from primeira_parcela_mensalidade pri
     inner join debitos debito on debito.id = pri.id
     inner join parametros on true
     inner join financeiro.clientefornecedorfinanceiro cliente on cliente.id = debito.clifor_id
     left join municipio cidade on cidade.id = cliente.municipio_id
     left join estado on estado.id = cidade.estado_id
     left join boletogerado boleto on boleto.id = debito.boletogerado_id
     left join contrato on contrato.cliente_id = cliente.id and contrato.ativo is true
     left join financeiro.empresabloqueada bloqueado on bloqueado.contrato_id = contrato.id
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
        bloqueado.databloqueio,
        ligacao.data,
        ligacao.historico,
        usuario_ligacao.nome,
        retorno.dataretorno
     )
     select sql.empresa_id,
            sql.clifor_id,
            sql.razaosocial,
            sql.cpfcnpj,
            cidade,
            estado,
            sigla,
            sql.datavencimento,
            sql.datapagamento,
            sql.valor,
            sql.status,
            sql.jurosPago,
            sql.valorPago,
            sql.qtd_dias,
            sql.databloqueio,
            sql.bloqueado,
            sql.ultima_ligacao,
            sql.historico,
            sql.usuario_ligacao,
            sql.dataretorno,
            nome as sistema,
            valormensalidade
     from sql
   left join contrato on contrato.id = (select max(id) from contrato where contrato.cliente_id = sql.clifor_id and contrato.empresa_id = sql.empresa_id and contrato.tipocobrancahonorario_id = 16)
     left join sistema on sistema.id = contrato.sistema_id
     where sql.id <> 499521
     order by sql.datapagamento desc
    "
  end

  def self.cliente_UF_inativo_Real(empresa, data_inicio, data_fim)
    return "
      with parametros as (
            select 	16::int as tipo_id
      ),
      sqlInativos as (select  cliente.id as cliente_id,
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
            emp.id as empresa_id,
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
    left join honorariomensal hono on hono.clifor_id = honorario.clifor_id and hono.empresa_id = honorario.empresa_id and hono.tipo_id = honorario.tipo_id and hono.id <> honorario.id
    left join contrato on contrato.id = (select max(id) from contrato where contrato.cliente_id = honorario.clifor_id and contrato.ativo = honorario.ativo and contrato.empresa_id = honorario.empresa_id and contrato.tipocobrancahonorario_id = honorario.tipo_id)
    left join sistema on sistema.id = contrato.sistema_id
    where honorario.empresa_id in (#{empresa})
      and honorario.datainativacao between '#{data_inicio}'::date and '#{data_fim}'::date
      and (parametros.tipo_id is null or honorario.tipo_id = parametros.tipo_id)
      and hono.id is null
      and honorario.ativo is false
      and (honorario.datainativacao > honorario.datavencimento)
    )
    select cliente_id,
          razaosocial,
          sql.cpfcnpj,
          municipio_id,
          municipio,
          estado,
          sigla,
          honorario_id,
          datainicial,
          datainativacao,
          sql.valor,
          tipo_id,
          ativo,
          nome,
          dias,
          dias_cliente,
          sql.empresa_id,
          sql.empresaRazaoSocial,
          sistema,
          sql.motivo
          from sqlInativos sql
          inner join debitos d on d.id = (select min(debitos.id) from debitos 
                                        inner join tipocobrancavalor tc on tc.debito_id = debitos.id and tc.tipocobranca_id = 16
                                      where debitos.clifor_id = sql.cliente_id and debitos.empresa_id = sql.empresa_id)
          
          where d.status = 'PAGO'
          order by datainativacao desc "
  end

  def self.cliente_UF_ativo(empresa, data_inicio, data_fim)
    return "
          with parametros as (
            select 	16::int as tipo_id
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
            emp.razaosocial as empresaRazaoSocial,
            sistema.nome as sistema
    from honorariomensal honorario
    inner join parametros on true
    inner join financeiro.clientefornecedorfinanceiro cliente on cliente.id = honorario.clifor_id
    inner join municipio on municipio.id = cliente.municipio_id
    inner join estado on municipio.estado_id = estado.id
    inner join tipocobranca tipo on tipo.id = honorario.tipo_id
    inner join empresa emp on emp.id = honorario.empresa_id
    left join honorariomensal hono on hono.clifor_id = honorario.clifor_id and hono.empresa_id = honorario.empresa_id and hono.tipo_id = honorario.tipo_id and hono.id <> honorario.id and hono.ativo is false
    left join contrato on contrato.id = (select max(id) from contrato where contrato.cliente_id = honorario.clifor_id and contrato.ativo = honorario.ativo and contrato.empresa_id = honorario.empresa_id and contrato.tipocobrancahonorario_id = honorario.tipo_id)
    left join sistema on sistema.id = contrato.sistema_id
    where honorario.empresa_id in (#{empresa})
      and (parametros.tipo_id is null or honorario.tipo_id = parametros.tipo_id)
      and hono.id is not null
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
            emp.razaosocial as empresaRazaoSocial,
            sistema.nome as sistema
    from honorariomensal honorario
    inner join parametros on true
    inner join financeiro.clientefornecedorfinanceiro cliente on cliente.id = honorario.clifor_id
    inner join municipio on municipio.id = cliente.municipio_id
    inner join estado on municipio.estado_id = estado.id
    inner join tipocobranca tipo on tipo.id = honorario.tipo_id
    inner join empresa emp on emp.id = honorario.empresa_id
    left join honorariomensal hono on hono.clifor_id = honorario.clifor_id and hono.empresa_id = honorario.empresa_id and hono.tipo_id = honorario.tipo_id and hono.id <> honorario.id
    left join contrato on contrato.id = (select max(id) from contrato where contrato.cliente_id = honorario.clifor_id and contrato.ativo = honorario.ativo and contrato.empresa_id = honorario.empresa_id and contrato.tipocobrancahonorario_id = honorario.tipo_id)
    left join sistema on sistema.id = contrato.sistema_id
    where honorario.empresa_id in (#{empresa})
      and (parametros.tipo_id is null or honorario.tipo_id = parametros.tipo_id)
      and hono.id is null
      and honorario.datavencimento between '#{data_inicio}'::date and '#{data_fim}'::date
      and (honorario.datainativacao is null or honorario.datainativacao > honorario.datavencimento)
  )
  select *
  from sql
  order by sql.datainicial desc
  "
  end

  def self.cliente_UF_inativo(empresa, data_inicio, data_fim)
    return "
      with parametros as (
            select 	16::int as tipo_id
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
            sistema.nome as sistema,
            coalesce(coalesce(contrato.motivoinativacao, honorario.motivoinativacao), '') as motivo
    from honorariomensal honorario
    inner join parametros on true
    inner join financeiro.clientefornecedorfinanceiro cliente on cliente.id = honorario.clifor_id
    inner join municipio on municipio.id = cliente.municipio_id
    inner join estado on municipio.estado_id = estado.id
    inner join tipocobranca tipo on tipo.id = honorario.tipo_id
    inner join empresa emp on emp.id = honorario.empresa_id
    left join honorariomensal hono on hono.clifor_id = honorario.clifor_id and hono.empresa_id = honorario.empresa_id and hono.tipo_id = honorario.tipo_id and hono.id <> honorario.id
    left join contrato on contrato.id = (select max(id) from contrato where contrato.cliente_id = honorario.clifor_id and contrato.ativo = honorario.ativo and contrato.empresa_id = honorario.empresa_id and contrato.tipocobrancahonorario_id = honorario.tipo_id)
    left join sistema on sistema.id = contrato.sistema_id
    where honorario.empresa_id in (#{empresa})
      and honorario.datainativacao between '#{data_inicio}'::date and '#{data_fim}'::date
      and (parametros.tipo_id is null or honorario.tipo_id = parametros.tipo_id)
      and hono.id is null
      and honorario.ativo is false
      and (honorario.datainativacao > honorario.datavencimento)
      order by honorario.datainativacao desc"
  end

  def self.cliente_tem_honorario(cnpj)
    return "select honorariomensal.id
            from honorariomensal
            left join financeiro.clientefornecedorfinanceiro cliente on cliente.id = honorariomensal.clifor_id
            where cliente.cpfcnpj = '#{cnpj}'
              and honorariomensal.ativo is true
              and tipo_id = 16
            limit 1"
  end

  def self.get_tabela_receitas(empresa, estado, data_inicio, data_fim, categoria)
    return "WITH SQL_RECEITA AS (
      SELECT DISTINCT
          'RECEITA' AS tipo,
          TO_CHAR(debitopago.datapagamento, 'MM/YYYY') AS data,
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
          CASE
              WHEN debito.valor = tipo_valor.valor THEN (CASE
                                                              WHEN debito.status = 'PARCIALMENTE_PAGO' THEN (debito.valor - debito.saldo)
                                                              ELSE tipo_valor.valor
                                                          END)
              ELSE (CASE
                          WHEN debito.status = 'PARCIALMENTE_PAGO' THEN round((((debito.valor - debito.saldo)/100)*trunc(((tipo_valor.valor * 100)/(case when debito.valor = 0 then 1 else debito.valor end)),2)),2)
                          ELSE tipo_valor.valor
                      END)
          END AS valorPago
      FROM
          debitospagos debitopago                
          INNER JOIN debito_debitospagos debito_debitopago ON debito_debitopago.debitopago_id = debitopago.id
          INNER JOIN debitos debito ON debito.id = debito_debitopago.debito_id
          INNER JOIN tipocobrancavalor tipo_valor ON tipo_valor.debito_id = debito.id
          LEFT JOIN tipocobranca tipo ON tipo.id = tipo_valor.tipocobranca_id
          WHERE debitopago.datapagamento::date BETWEEN '#{data_inicio}' AND '#{data_fim}'
                        AND debitopago.empresa_id in (#{empresa})
      GROUP BY
          idEmpresa,
          debito.id,
          idCobranca,
          nomecobranca,
          debito.status,
          debitopago.datapagamento,
          valorDebito,
          tipo_valor.valor,
          debito.parcela
  ),
  SOMAR_RECEITA AS (
      SELECT
          tipo,
          data,
  idCobranca,
      nomecobranca,
          sum(valorPago) AS valorpago
      FROM
          SQL_RECEITA
      GROUP BY
          tipo,
          data,
  idCobranca,
  nomecobranca
      ORDER BY
          data
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
        despesa.valor AS valorPago
    FROM
        despesa despesa        
        INNER JOIN tipodespesa tipodespesa ON tipodespesa.id = despesa.tipodespesa_id
	WHERE despesa.datapagamento BETWEEN '#{data_inicio}' AND '#{data_fim}'
	  		AND despesa.empresa_id IN (#{empresa})
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
        DATA,
        idCobranca,
        nomecobranca,
        sum(valorPago) AS valorpago
    FROM
        SQL_DESPESAS
    GROUP BY
        tipo,
        DATA,
        idCobranca,
        nomecobranca
    ORDER BY
        DATA
)
  select * from SOMAR_#{categoria}"
  end

end
