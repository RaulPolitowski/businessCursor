module DashboardsFunilHelper

  def self.funil(data_inicio, data_fim, estado, empresa)
    return "
      with primeira_ligacao as (
        select lig.cliente_id, min(data_inicio) as data
        from ligacoes lig
        inner join clientes cliente on cliente.id = lig.cliente_id
        left join cidades cidade on cidade.id = cliente.cidade_id
        where lig.empresa_id in (#{ApplicationHelper.get_empresas_by_codigo(empresa)})
        group by lig.cliente_id
      ),
      contatos as (
        select pri.cliente_id
        from primeira_ligacao pri
        inner join ligacoes ligacao on ligacao.data_inicio = pri.data and pri.cliente_id = ligacao.cliente_id
        inner join clientes cliente on cliente.id = ligacao.cliente_id
        left join cidades cidade on cidade.id = cliente.cidade_id
        where data::date between '#{data_inicio}' and '#{data_fim}'
          and (#{ estado.present? ? (ApplicationHelper.get_estado_by_codigo(estado)) : 'null'} is null or #{ estado.present? ? (ApplicationHelper.get_estado_by_codigo(estado)) : 'null'}::int = cidade.estado_id)
      )
      select  'CONTATOS' as tipo,
        count(cliente_id) as qtd,
        40 as perc
      from contatos
	      UNION ALL
      select  'FECHAMENTO' as tipo,
        count(id) as qtd,
        20 as perc
      from contatos contato
      inner join fechamentos on contato.cliente_id = fechamentos.cliente_id
            UNION ALL
      select 'IMPLANTAÇÃO' as tipo,
        count(implantacao.id) as qtd,
         15 as perc
      from contatos contato
      inner join implantacoes implantacao on contato.cliente_id = implantacao.cliente_id
      where implantacao.status = 9
      UNION ALL
      select 'ACOMPANHAMENTO' as tipo,
        count(acompanhamento.id) as qtd,
          15 as perc
      from contatos contato
      inner join acompanhamentos acompanhamento on contato.cliente_id = acompanhamento.cliente_id
      where acompanhamento.status = 5
    "
  end

  def self.funil_usuario(data_inicio, data_fim, estado, empresa, usuario, captacao)
    return "
      with primeira_ligacao as (
        select lig.cliente_id, lig.user_id, min(data_inicio) as data
        from ligacoes lig
        inner join clientes cliente on cliente.id = lig.cliente_id
        left join cidades cidade on cidade.id = cliente.cidade_id
        where lig.empresa_id in (#{ApplicationHelper.get_empresas_by_codigo(empresa)})
        group by lig.cliente_id, lig.user_id
      ),
      contatos as (
        with captacao as (
            select pri.cliente_id, pri.user_id, case when lig_cliente.id is null then true  when lig_cliente.id >= ligacao.id then true else false end as captacao
            from primeira_ligacao pri
            inner join ligacoes ligacao on ligacao.data_inicio = pri.data and pri.cliente_id = ligacao.cliente_id and pri.user_id = ligacao.user_id
            inner join clientes cliente on cliente.id = ligacao.cliente_id
            left join cidades cidade on cidade.id = cliente.cidade_id
            left join ligacoes lig_cliente on lig_cliente.id = (select min(ligacoes.id) from ligacoes inner join users u on u.id = ligacoes.user_id where u.permissao_id = 7 and ligacoes.cliente_id = pri.cliente_id )
            where data::date between '#{data_inicio}' and '#{data_fim}'
              and (#{ estado.present? ? (ApplicationHelper.get_estado_by_codigo(estado)) : 'null'} is null or #{ estado.present? ? (ApplicationHelper.get_estado_by_codigo(estado)) : 'null'}::int = cidade.estado_id)
              and (#{ usuario.present? ? usuario : 'null'} is null or #{ usuario.present? ? usuario : 'null'}::int = ligacao.user_id)
          )

          select *
          from captacao
          where ((#{captacao.to_i} = 0) or (#{captacao.to_i} = 1 and captacao.captacao is true) or (#{captacao.to_i} = 2 and captacao.captacao is false))
      )
      select  'CONTATOS' as tipo,
        count(cliente_id) as qtd,
        40 as perc
      from contatos
	      UNION ALL
      select  'FECHAMENTO' as tipo,
        count(id) as qtd,
        20 as perc
      from contatos contato
      inner join fechamentos on contato.cliente_id = fechamentos.cliente_id and fechamentos.user_id = contato.user_id
            UNION ALL
      select 'IMPLANTAÇÃO' as tipo,
        count(implantacao.id) as qtd,
         15 as perc
      from contatos contato
      inner join fechamentos on contato.cliente_id = fechamentos.cliente_id and fechamentos.user_id = contato.user_id
      inner join implantacoes implantacao on contato.cliente_id = implantacao.cliente_id
      where implantacao.status = 9
      UNION ALL
      select 'ACOMPANHAMENTO' as tipo,
        count(acompanhamento.id) as qtd,
          15 as perc
      from contatos contato
      inner join fechamentos on contato.cliente_id = fechamentos.cliente_id and fechamentos.user_id = contato.user_id
      inner join acompanhamentos acompanhamento on contato.cliente_id = acompanhamento.cliente_id
      where acompanhamento.status = 5
    "
  end

  def self.funil_captacao(data_inicio, data_fim, estado, empresa, usuario)
    return "
      with primeira_ligacao as (
        select lig.cliente_id, lig.user_id, min(data_inicio) as data
        from ligacoes lig
        inner join clientes cliente on cliente.id = lig.cliente_id
        left join cidades cidade on cidade.id = cliente.cidade_id
        where lig.empresa_id in (#{ApplicationHelper.get_empresas_by_codigo(empresa)})
        group by lig.cliente_id, lig.user_id
      ),
      contatos as (
            select pri.cliente_id, pri.user_id
            from primeira_ligacao pri
            inner join ligacoes ligacao on ligacao.data_inicio = pri.data and pri.cliente_id = ligacao.cliente_id and pri.user_id = ligacao.user_id
            inner join clientes cliente on cliente.id = ligacao.cliente_id
            left join cidades cidade on cidade.id = cliente.cidade_id
            where data::date between '#{data_inicio}' and '#{data_fim}'
              and (#{ estado.present? ? (ApplicationHelper.get_estado_by_codigo(estado)) : 'null'} is null or #{ estado.present? ? (ApplicationHelper.get_estado_by_codigo(estado)) : 'null'}::int = cidade.estado_id)
              and (#{ usuario.present? ? usuario : 'null'} is null or #{ usuario.present? ? usuario : 'null'}::int = ligacao.user_id)
      )
      select  'CONTATOS' as tipo,
        count(cliente_id) as qtd,
        40 as perc
      from contatos
	      UNION ALL
      select  'NEGOCIACOES' as tipo,
        count(negociacoes.id) as qtd,
        15 as perc
      from contatos contato
      inner join negociacoes on negociacoes.cliente_id = contato.cliente_id and negociacoes.prospectador_id = contato.user_id
	      UNION ALL
      select  'FECHAMENTO' as tipo,
        count(fechamentos.id) as qtd,
        20 as perc
      from contatos contato
      inner join negociacoes on negociacoes.cliente_id = contato.cliente_id and negociacoes.prospectador_id = contato.user_id
      inner join fechamentos on contato.cliente_id = fechamentos.cliente_id
            UNION ALL
      select 'IMPLANTAÇÃO' as tipo,
        count(implantacao.id) as qtd,
         15 as perc
      from contatos contato
      inner join negociacoes on negociacoes.cliente_id = contato.cliente_id and negociacoes.prospectador_id = contato.user_id
      inner join fechamentos on contato.cliente_id = fechamentos.cliente_id
      inner join implantacoes implantacao on contato.cliente_id = implantacao.cliente_id
      where implantacao.status = 9
      UNION ALL
      select 'ACOMPANHAMENTO' as tipo,
        count(acompanhamento.id) as qtd,
          15 as perc
      from contatos contato
      inner join negociacoes on negociacoes.cliente_id = contato.cliente_id and negociacoes.prospectador_id = contato.user_id
      inner join fechamentos on contato.cliente_id = fechamentos.cliente_id
      inner join acompanhamentos acompanhamento on contato.cliente_id = acompanhamento.cliente_id
      where acompanhamento.status = 5
    "
  end

  def self.get_acompanhamentos_concluidos_funil(data_inicio, data_fim, estado, empresa)
    return "
          with primeira_ligacao as (
        select lig.cliente_id, min(data_inicio) as data
        from ligacoes lig
        inner join clientes cliente on cliente.id = lig.cliente_id
        left join cidades cidade on cidade.id = cliente.cidade_id
        where lig.empresa_id in (#{ApplicationHelper.get_empresas_by_codigo(empresa)})
        group by lig.cliente_id
      ),
      contatos as (
        select pri.cliente_id, cliente.cnpj
        from primeira_ligacao pri
        inner join ligacoes ligacao on ligacao.data_inicio = pri.data and pri.cliente_id = ligacao.cliente_id
        inner join clientes cliente on cliente.id = ligacao.cliente_id
        left join cidades cidade on cidade.id = cliente.cidade_id
        where data::date between '#{data_inicio}' and '#{data_fim}'
          and (#{ estado.present? ? (ApplicationHelper.get_estado_by_codigo(estado)) : 'null'} is null or #{ estado.present? ? (ApplicationHelper.get_estado_by_codigo(estado)) : 'null'}::int = cidade.estado_id)
      )
        select contato.*
        from contatos contato
        inner join acompanhamentos acomp on contato.cliente_id = acomp.cliente_id and acomp.status = 5
    "
  end

  def self.get_acompanhamentos_concluidos_funil_usuario(data_inicio, data_fim, estado, empresa, usuario, captacao)
    return "
          with primeira_ligacao as (
        select lig.cliente_id, lig.user_id, min(data_inicio) as data
        from ligacoes lig
        inner join clientes cliente on cliente.id = lig.cliente_id
        left join cidades cidade on cidade.id = cliente.cidade_id
        where lig.empresa_id in (#{ApplicationHelper.get_empresas_by_codigo(empresa)})
        group by lig.cliente_id, lig.user_id
      ),
      contatos as (
        with captacao as (
            select pri.cliente_id, cliente.cnpj, pri.user_id, case when lig_cliente.id is null then true  when lig_cliente.id >= ligacao.id then true else false end as captacao
            from primeira_ligacao pri
            inner join ligacoes ligacao on ligacao.data_inicio = pri.data and pri.cliente_id = ligacao.cliente_id and pri.user_id = ligacao.user_id
            inner join clientes cliente on cliente.id = ligacao.cliente_id
            left join cidades cidade on cidade.id = cliente.cidade_id
            left join ligacoes lig_cliente on lig_cliente.id = (select min(ligacoes.id) from ligacoes inner join users u on u.id = ligacoes.user_id where u.permissao_id = 7 and ligacoes.cliente_id = pri.cliente_id )
            where data::date between '#{data_inicio}' and '#{data_fim}'
              and (#{ estado.present? ? (ApplicationHelper.get_estado_by_codigo(estado)) : 'null'} is null or #{ estado.present? ? (ApplicationHelper.get_estado_by_codigo(estado)) : 'null'}::int = cidade.estado_id)
              and (#{ usuario.present? ? usuario : 'null'} is null or #{ usuario.present? ? usuario : 'null'}::int = ligacao.user_id)
          )

          select *
          from captacao
          where ((#{captacao.to_i} = 0) or (#{captacao.to_i} = 1 and captacao.captacao is true) or (#{captacao.to_i} = 2 and captacao.captacao is false))
      )
        select contato.*
        from contatos contato
        inner join fechamentos on contato.cliente_id = fechamentos.cliente_id and fechamentos.user_id = contato.user_id
        inner join acompanhamentos acomp on contato.cliente_id = acomp.cliente_id and acomp.status = 5
    "
  end

  def self.get_acompanhamentos_concluidos_funil_captacao(data_inicio, data_fim, estado, empresa, usuario)
    return "
          with primeira_ligacao as (
        select lig.cliente_id, lig.user_id, min(data_inicio) as data
        from ligacoes lig
        inner join clientes cliente on cliente.id = lig.cliente_id
        left join cidades cidade on cidade.id = cliente.cidade_id
        where lig.empresa_id in (#{ApplicationHelper.get_empresas_by_codigo(empresa)})
        group by lig.cliente_id, lig.user_id
      ),
      contatos as (
        select pri.cliente_id, cliente.cnpj, pri.user_id
        from primeira_ligacao pri
        inner join ligacoes ligacao on ligacao.data_inicio = pri.data and pri.cliente_id = ligacao.cliente_id
        inner join clientes cliente on cliente.id = ligacao.cliente_id
        left join cidades cidade on cidade.id = cliente.cidade_id
        where data::date between '#{data_inicio}' and '#{data_fim}'
          and (#{ estado.present? ? (ApplicationHelper.get_estado_by_codigo(estado)) : 'null'} is null or #{ estado.present? ? (ApplicationHelper.get_estado_by_codigo(estado)) : 'null'}::int = cidade.estado_id)
          and (#{ usuario.present? ? usuario : 'null'} is null or #{ usuario.present? ? usuario : 'null'}::int = ligacao.user_id)
      )
        select contato.*
        from contatos contato
        inner join negociacoes on negociacoes.cliente_id = contato.cliente_id and negociacoes.prospectador_id = contato.user_id
        inner join fechamentos on contato.cliente_id = fechamentos.cliente_id
        inner join acompanhamentos acomp on contato.cliente_id = acomp.cliente_id and acomp.status = 5
    "
  end

  def self.get_primeira_parcela_paga(cliente_id, empresa)
    return "
    with id_debito as (
      select distinct c.clifor_id, min(c.datacompetencia) as datacompetencia, min(c.id) as id
      from debitos c
      inner join tipocobrancavalor tc on tc.debito_id = c.id and tc.tipocobranca_id = 16

      where c.status in ('PENDENTE', 'PAGO', 'PARCIALMENTE_PAGO')
      and c.empresa_id in (#{empresa})
      group by c.clifor_id
      order by c.clifor_id
    )
    select debito.id, debito.datacompetencia, debito.clifor_id, coalesce(boleto.datavencimento, debito.datavencimento) as datavencimento,
	   debitopago.datapagamento, debito.status, honorariomensal.ativo honorario_ativo
    from honorariomensal
    inner join financeiro.clientefornecedorfinanceiro cliente on cliente.id = honorariomensal.clifor_id
    left join id_debito on id_debito.clifor_id = cliente.id
    left join debitos debito on debito.id = id_debito.id and debito.clifor_id = id_debito.clifor_id
    left join boletogerado boleto on boleto.id = debito.boletogerado_id
    left join debito_debitospagos debito_debitopago on debito_debitopago.debito_id = debito.id
    left join debitospagos debitopago on debitopago.id = debito_debitopago.debitopago_id
    where cliente.cpfcnpj = '#{cliente_id}'
    group by debito.id, debito.clifor_id, coalesce(boleto.datavencimento, debito.datavencimento), debitopago.datapagamento, honorariomensal.ativo
    limit 1
    "
  end

  def self.get_honorario_cliente(cliente_id)
    return "
    select honorario.*
    from honorariomensal honorario
    left join financeiro.clientefornecedorfinanceiro cliente on cliente.id = honorario.clifor_id
    where cliente.cpfcnpj = '#{cliente_id}'
    order by honorario.id desc limit 1"
  end

  def self.get_totais_etapas(data_inicio, data_fim, estado, empresa)
    return "
      with primeira_ligacao as (
        select lig.cliente_id, min(data_inicio) as data
        from ligacoes lig
        inner join clientes cliente on cliente.id = lig.cliente_id
        left join cidades cidade on cidade.id = cliente.cidade_id
        where lig.empresa_id in (#{ApplicationHelper.get_empresas_by_codigo(empresa)})
        group by lig.cliente_id
      ),
      contatos as (
        select pri.cliente_id
        from primeira_ligacao pri
        inner join ligacoes ligacao on ligacao.data_inicio = pri.data and pri.cliente_id = ligacao.cliente_id
        inner join clientes cliente on cliente.id = ligacao.cliente_id
        left join cidades cidade on cidade.id = cliente.cidade_id
        where data::date between '#{data_inicio}' and '#{data_fim}'
          and (#{ estado.present? ? (ApplicationHelper.get_estado_by_codigo(estado)) : 'null'} is null or #{ estado.present? ? (ApplicationHelper.get_estado_by_codigo(estado)) : 'null'}::int = cidade.estado_id)
      ),
      status as (
	select 1
      ),
      fechamentos as (
		with fech_status as (
			select count(contato.cliente_id),
			coalesce(neg.status,2) as status,
			case coalesce(neg.status,2) when 0 then 'Em negociação' when 1 then 'Fechado' else 'Descartado' end as status_desc
			from contatos contato
			left join negociacoes neg on neg.cliente_id = contato.cliente_id
			left join fechamentos fec on fec.cliente_id = contato.cliente_id
			group by coalesce(neg.status,2)
		)
		select 'CONTATOS'::text as tipo,
			coalesce(fs.count,0) as em_andamento,
			coalesce(fs1.count,0) as finalizado,
			coalesce(fs2.count,0) as descartado,
			(coalesce(fs.count,0) + coalesce(fs1.count,0) + coalesce(fs2.count,0)) as total
		from status
		left join fech_status fs  on fs.status = 0
		left join fech_status fs1 on fs1.status = 1
		left join fech_status fs2 on fs2.status = 2
	),
	implantacoes as (
		with impl_status as (
			select sum(count) as count,
				status,
				status_desc
			from (
			select count(impl.id),
				case when coalesce(impl.status,10) in (0, 1, 2, 3, 4, 5, 6, 10) then 0 when coalesce(impl.status,10) in (7,8) then 2 else 1 end as status,
				case when coalesce(impl.status,10) in (0, 1, 2, 3, 4, 5, 6, 10) then 'Em Implantação' when coalesce(impl.status,10) in (7,8) then 'Descartado' else 'Finalizado' end as status_desc
			from contatos contato
			inner join implantacoes impl on impl.cliente_id = contato.cliente_id
			group by impl.status ) x
			group by x.status, x.status_desc
		)
		select 'IMPLANTAÇÕES'::text as tipo,
			coalesce(fs.count,0) as em_andamento,
			coalesce(fs1.count,0) as finalizado,
			coalesce(fs2.count,0) as descartado,
			(coalesce(fs.count,0) + coalesce(fs1.count,0) + coalesce(fs2.count,0)) as total
		from status
		left join impl_status fs on fs.status = 0
		left join impl_status fs1 on fs1.status = 1
		left join impl_status fs2 on fs2.status = 2
	),
	acompanhamentos as (
		with acomp_status as (
			select sum(count) as count,
					status,
					status_desc
				from (
					select 	count(acomp.id),
						case when coalesce(acomp.status,0) in (0,1,2) then 0 when coalesce(acomp.status,0) in (3,4) then 2 else 1 end as status,
						case when coalesce(acomp.status,0) in (0,1,2) then 'Em Acompanhamento' when coalesce(acomp.status,0) in (3,4) then 'Descartado' else 'Finalizado' end as status_desc
					from contatos contato
					inner join acompanhamentos acomp on acomp.cliente_id = contato.cliente_id
					group by acomp.status
				) x
				group by x.status, x.status_desc
		)
		select 'ACOMPANHAMENTOS'::text as tipo,
			coalesce(fs.count,0) as em_andamento,
			coalesce(fs1.count,0) as finalizado,
			coalesce(fs2.count,0) as descartado,
			(coalesce(fs.count,0) + coalesce(fs1.count,0) + coalesce(fs2.count,0)) as total
		from status
		left join acomp_status fs on fs.status = 0
		left join acomp_status fs1 on fs1.status = 1
		left join acomp_status fs2 on fs2.status = 2
	)
	select *
	from fechamentos
		union all
	select *
	from implantacoes
	union all
	select *
	from acompanhamentos

"
  end


  def self.get_totais_etapas_usuario(data_inicio, data_fim, estado, empresa, usuario, captacao)
    return "
      with primeira_ligacao as (
        select lig.cliente_id, lig.user_id, min(data_inicio) as data
        from ligacoes lig
        inner join clientes cliente on cliente.id = lig.cliente_id
        left join cidades cidade on cidade.id = cliente.cidade_id
        where lig.empresa_id in (#{ApplicationHelper.get_empresas_by_codigo(empresa)})
        group by lig.cliente_id, lig.user_id
      ),
      contatos as (
        with captacao as (
            select pri.cliente_id, pri.user_id, case when lig_cliente.id is null then true  when lig_cliente.id >= ligacao.id then true else false end as captacao
            from primeira_ligacao pri
            inner join ligacoes ligacao on ligacao.data_inicio = pri.data and pri.cliente_id = ligacao.cliente_id and pri.user_id = ligacao.user_id
            inner join clientes cliente on cliente.id = ligacao.cliente_id
            left join cidades cidade on cidade.id = cliente.cidade_id
            left join ligacoes lig_cliente on lig_cliente.id = (select min(ligacoes.id) from ligacoes inner join users u on u.id = ligacoes.user_id where u.permissao_id = 7 and ligacoes.cliente_id = pri.cliente_id )
            where data::date between '#{data_inicio}' and '#{data_fim}'
              and (#{ estado.present? ? (ApplicationHelper.get_estado_by_codigo(estado)) : 'null'} is null or #{ estado.present? ? (ApplicationHelper.get_estado_by_codigo(estado)) : 'null'}::int = cidade.estado_id)
              and (#{ usuario.present? ? usuario : 'null'} is null or #{ usuario.present? ? usuario : 'null'}::int = ligacao.user_id)
          )

          select *
          from captacao
          where ((#{captacao.to_i} = 0) or (#{captacao.to_i} = 1 and captacao.captacao is true) or (#{captacao.to_i} = 2 and captacao.captacao is false))
      ),
      status as (
	select 1
      ),
      sql_fechamentos as (
		with fech_status as (
			select count(contato.cliente_id),
			coalesce(neg.status,2) as status,
			case coalesce(neg.status,2) when 0 then 'Em negociação' when 1 then 'Fechado' else 'Descartado' end as status_desc
			from contatos contato
			left join negociacoes neg on neg.cliente_id = contato.cliente_id and contato.user_id = neg.user_id
			group by coalesce(neg.status,2)
		)
		select 'CONTATOS'::text as tipo,
			coalesce(fs.count,0) as em_andamento,
			coalesce(fs1.count,0) as finalizado,
			coalesce(fs2.count,0) as descartado,
			(coalesce(fs.count,0) + coalesce(fs1.count,0) + coalesce(fs2.count,0)) as total
		from status
		left join fech_status fs  on fs.status = 0
		left join fech_status fs1 on fs1.status = 1
		left join fech_status fs2 on fs2.status = 2
	),
	sql_implantacoes as (
		with impl_status as (
			select sum(count) as count,
				status,
				status_desc
			from (
			select count(impl.id),
				case when coalesce(impl.status,10) in (0, 1, 2, 3, 4, 5, 6, 10) then 0 when coalesce(impl.status,10) in (7,8) then 2 else 1 end as status,
				case when coalesce(impl.status,10) in (0, 1, 2, 3, 4, 5, 6, 10) then 'Em Implantação' when coalesce(impl.status,10) in (7,8) then 'Descartado' else 'Finalizado' end as status_desc
			from contatos contato
			inner join fechamentos fec on fec.cliente_id = contato.cliente_id and contato.user_id = fec.user_id
			inner join implantacoes impl on impl.cliente_id = contato.cliente_id
			group by impl.status ) x
			group by x.status, x.status_desc
		)
		select 'IMPLANTAÇÕES'::text as tipo,
			coalesce(fs.count,0) as em_andamento,
			coalesce(fs1.count,0) as finalizado,
			coalesce(fs2.count,0) as descartado,
			(coalesce(fs.count,0) + coalesce(fs1.count,0) + coalesce(fs2.count,0)) as total
		from status
		left join impl_status fs on fs.status = 0
		left join impl_status fs1 on fs1.status = 1
		left join impl_status fs2 on fs2.status = 2
	),
	sql_acompanhamentos as (
		with acomp_status as (
			select sum(count) as count,
					status,
					status_desc
				from (
					select 	count(acomp.id),
						case when coalesce(acomp.status,0) in (0,1,2) then 0 when coalesce(acomp.status,0) in (3,4) then 2 else 1 end as status,
						case when coalesce(acomp.status,0) in (0,1,2) then 'Em Acompanhamento' when coalesce(acomp.status,0) in (3,4) then 'Descartado' else 'Finalizado' end as status_desc
					from contatos contato
          inner join fechamentos fec on fec.cliente_id = contato.cliente_id and contato.user_id = fec.user_id
					inner join acompanhamentos acomp on acomp.cliente_id = contato.cliente_id
					group by acomp.status
				) x
				group by x.status, x.status_desc
		)
		select 'ACOMPANHAMENTOS'::text as tipo,
			coalesce(fs.count,0) as em_andamento,
			coalesce(fs1.count,0) as finalizado,
			coalesce(fs2.count,0) as descartado,
			(coalesce(fs.count,0) + coalesce(fs1.count,0) + coalesce(fs2.count,0)) as total
		from status
		left join acomp_status fs on fs.status = 0
		left join acomp_status fs1 on fs1.status = 1
		left join acomp_status fs2 on fs2.status = 2
	)
	select *
	from sql_fechamentos
		union all
	select *
	from sql_implantacoes
	union all
	select *
	from sql_acompanhamentos
"
  end

  def self.get_totais_etapas_captacao(data_inicio, data_fim, estado, empresa, usuario)
    return "
      WITH primeira_ligacao AS
  (SELECT lig.cliente_id,
          lig.user_id,
          min(data_inicio) AS DATA
   FROM ligacoes lig
   INNER JOIN clientes cliente ON cliente.id = lig.cliente_id
   LEFT JOIN cidades cidade ON cidade.id = cliente.cidade_id
   where lig.empresa_id in (#{ApplicationHelper.get_empresas_by_codigo(empresa)})
   GROUP BY lig.cliente_id,
            lig.user_id),
     contatos AS
  (SELECT pri.cliente_id,
          pri.user_id
   FROM primeira_ligacao pri
   INNER JOIN ligacoes ligacao ON ligacao.data_inicio = pri.data
   AND pri.cliente_id = ligacao.cliente_id
   AND pri.user_id = ligacao.user_id
   INNER JOIN clientes cliente ON cliente.id = ligacao.cliente_id
   LEFT JOIN cidades cidade ON cidade.id = cliente.cidade_id
  where data::date between '#{data_inicio}' and '#{data_fim}'
    and (#{ estado.present? ? (ApplicationHelper.get_estado_by_codigo(estado)) : 'null'} is null or #{ estado.present? ? (ApplicationHelper.get_estado_by_codigo(estado)) : 'null'}::int = cidade.estado_id)
    and (#{ usuario.present? ? usuario : 'null'} is null or #{ usuario.present? ? usuario : 'null'}::int = ligacao.user_id)
  ),
     status AS
  (SELECT 1),
     sql_negociacoes AS
  (WITH neg_status AS
     (SELECT contato.cliente_id,
             CASE
                 WHEN neg.id IS NOT NULL THEN 1
                 ELSE 2
             END AS status,
             CASE
                 WHEN neg.id IS NOT NULL THEN 'Negociação'
                 ELSE 'Sem Negociaçao'
             END AS status_desc
      FROM contatos contato
      LEFT JOIN negociacoes neg ON neg.cliente_id = contato.cliente_id
      AND contato.user_id = neg.prospectador_id),
        agrupar_neg AS
     (SELECT count(status.cliente_id),
             status.status AS status,
             status.status_desc
      FROM neg_status status
      GROUP BY status.status,
               status.status_desc) SELECT 'CONTATOS'::text AS tipo,
                                          0 AS em_andamento,
                                          coalesce(fs1.count, 0) AS finalizado,
                                          coalesce(fs2.count, 0) AS descartado,
                                          (coalesce(fs1.count, 0) + coalesce(fs2.count, 0)) AS total
   FROM status
   LEFT JOIN agrupar_neg fs1 ON fs1.status = 1
   LEFT JOIN agrupar_neg fs2 ON fs2.status = 2),
     sql_fechamentos AS
  (WITH fech_status AS
     (SELECT count(contato.cliente_id),
             coalesce(neg.status, 2) AS status,
             CASE coalesce(neg.status, 2)
                 WHEN 0 THEN 'Em negociação'
                 WHEN 1 THEN 'Fechado'
                 ELSE 'Descartado'
             END AS status_desc
      FROM contatos contato
      INNER JOIN negociacoes neg ON neg.cliente_id = contato.cliente_id
      AND contato.user_id = neg.prospectador_id
      GROUP BY coalesce(neg.status, 2)) SELECT 'NEGOCIAÇÕES'::text AS tipo,
                                               coalesce(fs.count, 0) AS em_andamento,
                                               coalesce(fs1.count, 0) AS finalizado,
                                               coalesce(fs2.count, 0) AS descartado,
                                               (coalesce(fs.count, 0) + coalesce(fs1.count, 0) + coalesce(fs2.count, 0)) AS total
   FROM status
   LEFT JOIN fech_status fs ON fs.status = 0
   LEFT JOIN fech_status fs1 ON fs1.status = 1
   LEFT JOIN fech_status fs2 ON fs2.status = 2),
     sql_implantacoes AS
  (WITH impl_status AS
     (SELECT sum(COUNT) AS COUNT,
             status,
             status_desc
      FROM
        (SELECT count(impl.id),
                CASE
                    WHEN coalesce(impl.status, 10) IN (0,
                                                       1,
                                                       2,
                                                       3,
                                                       4,
                                                       5,
                                                       6,
                                                       10) THEN 0
                    WHEN coalesce(impl.status, 10) IN (7,
                                                       8) THEN 2
                    ELSE 1
                END AS status,
                CASE
                    WHEN coalesce(impl.status, 10) IN (0,
                                                       1,
                                                       2,
                                                       3,
                                                       4,
                                                       5,
                                                       6,
                                                       10) THEN 'Em Implantação'
                    WHEN coalesce(impl.status, 10) IN (7,
                                                       8) THEN 'Descartado'
                    ELSE 'Finalizado'
                END AS status_desc
         FROM contatos contato
         INNER JOIN negociacoes neg ON neg.cliente_id = contato.cliente_id
         AND contato.user_id = neg.prospectador_id
         INNER JOIN fechamentos fec ON fec.cliente_id = contato.cliente_id
         INNER JOIN implantacoes impl ON impl.cliente_id = contato.cliente_id
         GROUP BY impl.status) x
      GROUP BY x.status,
               x.status_desc) SELECT 'IMPLANTAÇÕES'::text AS tipo,
                                     coalesce(fs.count, 0) AS em_andamento,
                                     coalesce(fs1.count, 0) AS finalizado,
                                     coalesce(fs2.count, 0) AS descartado,
                                     (coalesce(fs.count, 0) + coalesce(fs1.count, 0) + coalesce(fs2.count, 0)) AS total
   FROM status
   LEFT JOIN impl_status fs ON fs.status = 0
   LEFT JOIN impl_status fs1 ON fs1.status = 1
   LEFT JOIN impl_status fs2 ON fs2.status = 2),
     sql_acompanhamentos AS
  (WITH acomp_status AS
     (SELECT sum(COUNT) AS COUNT,
             status,
             status_desc
      FROM
        (SELECT count(acomp.id),
                CASE
                    WHEN coalesce(acomp.status, 0) IN (0,
                                                       1,
                                                       2) THEN 0
                    WHEN coalesce(acomp.status, 0) IN (3,
                                                       4) THEN 2
                    ELSE 1
                END AS status,
                CASE
                    WHEN coalesce(acomp.status, 0) IN (0,
                                                       1,
                                                       2) THEN 'Em Acompanhamento'
                    WHEN coalesce(acomp.status, 0) IN (3,
                                                       4) THEN 'Descartado'
                    ELSE 'Finalizado'
                END AS status_desc
         FROM contatos contato
         INNER JOIN negociacoes neg ON neg.cliente_id = contato.cliente_id
         AND contato.user_id = neg.prospectador_id
         INNER JOIN fechamentos fec ON fec.cliente_id = contato.cliente_id
         INNER JOIN acompanhamentos acomp ON acomp.cliente_id = contato.cliente_id
         GROUP BY acomp.status) x
      GROUP BY x.status,
               x.status_desc) SELECT 'ACOMPANHAMENTOS'::text AS tipo,
                                     coalesce(fs.count, 0) AS em_andamento,
                                     coalesce(fs1.count, 0) AS finalizado,
                                     coalesce(fs2.count, 0) AS descartado,
                                     (coalesce(fs.count, 0) + coalesce(fs1.count, 0) + coalesce(fs2.count, 0)) AS total
   FROM status
   LEFT JOIN acomp_status fs ON fs.status = 0
   LEFT JOIN acomp_status fs1 ON fs1.status = 1
   LEFT JOIN acomp_status fs2 ON fs2.status = 2)
  SELECT *
  FROM sql_negociacoes
  UNION ALL
  SELECT *
  FROM sql_fechamentos
  UNION ALL
  SELECT *
  FROM sql_implantacoes
  UNION ALL
  SELECT *
  FROM sql_acompanhamentos
"
  end
end
