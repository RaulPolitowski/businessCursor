module NegociacoesHelper

  def self.get_sql_negociacoes(data_inicio, data_fim, empresa, vendedor, cliente, filtro, tipo)

    html = " with parametros as (
                      select 	#{ data_inicio.present? ? '\'' + data_inicio + '\'': 'null'}::date as data_inicial,
                              #{ data_fim.present? ? '\'' + data_fim + '\'': 'null'}::date as data_fim,
                              #{ empresa.present? ? empresa : 'null'}::int as empresa,
                              #{ vendedor.present? ? vendedor : 'null'}::int as vendedor,
                              #{ cliente.present? ? cliente : 'null'}::int as cliente
          )
          select distinct cliente.id as cliente_id, cliente.razao_social, cliente.cnpj, negociacao.id, negociacao.data_inicio, negociacao.data_fim, negociacao.status,
                  negociacao.empresa_id, current_date - negociacao.data_inicio::date as qtd_dias,
                  case when cliente.telefone_preferencial then cliente.telefone when cliente.telefone2_preferencial then cliente.telefone2 else cliente.telefone end as telefone,
                  negociacao.atendimento_whatsapp,
                  negociacao.atendimento_telefone,
                  vendedor.name as vendedor,
                  coalesce(SPLIT_PART( contatos.nome, ' ', 1),'') as contato,
                  agendamento_retornos.data_agendamento_retorno as retorno, agendamento_retornos.id as retorno_id,
                  l.observacao as observacao,
                  status.descricao, status.id as status_id,
                  empresas.razao_social as empresa
          from negociacoes negociacao
          left join parametros on true
          left join clientes cliente on cliente.id = negociacao.cliente_id
          left join users vendedor on vendedor.id = negociacao.user_id
          left join status on status.id = negociacao.status_id
          left join agendamento_retornos on agendamento_retornos.id = (select max(id) from agendamento_retornos a where a.cliente_id = negociacao.cliente_id and a.data_efetuado_retorno is null and a.cancelado is false)
          left join ligacoes l on l.id = agendamento_retornos.ligacao_id
          left join contatos on contatos.id = (select min(id) from contatos where cliente_id = cliente.id)
          left join empresas on empresas.id = negociacao.empresa_id
          where status = 0
            and (parametros.data_inicial is null or negociacao.data_inicio::date >= parametros.data_inicial)
            and (parametros.data_fim is null or negociacao.data_inicio::date <= parametros.data_fim)
            and (parametros.empresa is null or negociacao.empresa_id = parametros.empresa)
            and (parametros.vendedor is null or vendedor.id = parametros.vendedor)
            and (parametros.cliente is null or cliente.id = parametros.cliente)
            #{ filtro == 'hoje' ? ' and agendamento_retornos.data_agendamento_retorno::date = current_date and agendamento_retornos.data_agendamento_retorno >= current_timestamp ': ''}
            #{ filtro == 'atrasadas' ? ' and (agendamento_retornos.data_agendamento_retorno < current_timestamp or agendamento_retornos.id is null) ': ''}
            #{ filtro == 'prox' ? ' and agendamento_retornos.data_agendamento_retorno::date > current_date and agendamento_retornos.data_agendamento_retorno::date <= current_date+7 ': ''}
            #{ filtro == 'demais' ? ' and agendamento_retornos.data_agendamento_retorno::date > current_date+7 ': ''}
            #{ tipo == '0' ? ' and negociacao.status_id not in (28) ': ''}
            #{ tipo == '1' ? ' and negociacao.status_id  in (28) ': ''}
            order by agendamento_retornos.data_agendamento_retorno
      "
  end

  def self.get_sql_negociacoes_canceladas(data_inicio, data_fim, empresa, vendedor, cliente, tipo, conferido)

    html = " with parametros as (
                      select 	#{ data_inicio.present? ? '\'' + data_inicio + '\'': 'null'}::date as data_inicial,
                              #{ data_fim.present? ? '\'' + data_fim + '\'': 'null'}::date as data_fim,
                              #{ empresa.present? ? empresa : 'null'}::int as empresa,
                              #{ vendedor.present? ? vendedor : 'null'}::int as vendedor,
                              #{ cliente.present? ? cliente : 'null'}::int as cliente,
                              #{ conferido } as conferido
          )
          select distinct cliente.id as cliente_id, cliente.razao_social, cliente.cnpj, negociacao.id, negociacao.data_inicio, negociacao.data_fim, negociacao.status,
                  negociacao.empresa_id, negociacao.data_fim::date - negociacao.data_inicio::date as qtd_dias,
                  case when cliente.telefone_preferencial then cliente.telefone when cliente.telefone2_preferencial then cliente.telefone2 else cliente.telefone end as telefone,
                  negociacao.atendimento_whatsapp,
                  negociacao.atendimento_telefone,
                  vendedor.name as vendedor,
                  coalesce(SPLIT_PART( contatos.nome, ' ', 1),'') as contato,
                  status.descricao, status.id as status_id, negociacao.baixado, negociacao.conferido
          from negociacoes negociacao
          left join parametros on true
          left join clientes cliente on cliente.id = negociacao.cliente_id
          left join users vendedor on vendedor.id = negociacao.user_id
          left join status on status.id = negociacao.status_id
          left join contatos on contatos.id = (select min(id) from contatos where cliente_id = cliente.id)
          where status IN (2,3)
            and (parametros.data_inicial is null or negociacao.data_inicio::date >= parametros.data_inicial)
            and (parametros.data_fim is null or negociacao.data_inicio::date <= parametros.data_fim)
            and (parametros.empresa is null or negociacao.empresa_id = parametros.empresa)
            and (parametros.vendedor is null or vendedor.id = parametros.vendedor)
            and (parametros.cliente is null or cliente.id = parametros.cliente)
            and negociacao.conferido = parametros.conferido
            and negociacao.baixado is false
            #{ tipo == '0' ? ' and negociacao.status_id not in (28) ': ''}
            #{ tipo == '1' ? ' and negociacao.status_id  in (28) ': ''}
            order by negociacao.data_fim desc
      "
  end

  def self.get_informacao_por_consultor(data_inicio, data_fim, empresa)
    return "
 with parametros as (
                      select 	#{ data_inicio.present? ? '\'' + data_inicio + '\'': 'null'}::date as data_inicial,
                              #{ data_fim.present? ? '\'' + data_fim + '\'': 'null'}::date as data_fim,
                              #{ empresa.present? ? empresa : 'null'}::int as empresa
                     ),
		   		 		  sql as (
				select 	negociacao.*,
			  			vendedor.name as nome,
			  			agendamento_retornos.data_agendamento_retorno as retorno,
				  		agendamento_retornos.id as retorno_id,
			  			cliente.status_id as status_cliente
				from negociacoes negociacao
			  	left join clientes cliente on cliente.id = negociacao.cliente_id
				left join users vendedor on vendedor.id = negociacao.user_id
			  	left join agendamento_retornos on agendamento_retornos.id = (select max(id) from agendamento_retornos a where a.cliente_id = negociacao.cliente_id and a.data_efetuado_retorno is null and a.cancelado is false)
			  ),
			  abertas as (
			  	select count(sql.id) as qtd, sql.nome as nome, sql.user_id
				from sql
				left join parametros on true
				 where (parametros.data_inicial is null or sql.data_inicio::date >= parametros.data_inicial)
				  and (parametros.data_fim is null or sql.data_inicio::date <= parametros.data_fim)
				  and (parametros.empresa is null or sql.empresa_id = parametros.empresa)
				  and (sql.status_cliente in (2, 7, 10) or sql.status_cliente > 40)
				  group by sql.nome, sql.user_id
			  ),
			  baixadas as (
			  	select count(sql.id) as qtd, sql.nome as nome, sql.user_id
				from sql
				left join parametros on true
				where sql.status = 2
				  and (parametros.data_inicial is null or sql.data_inicio::date >= parametros.data_inicial)
				  and (parametros.data_fim is null or sql.data_inicio::date <= parametros.data_fim)
				  and (parametros.empresa is null or sql.empresa_id = parametros.empresa)
				  and sql.status_cliente in (10)
			  	group by sql.nome, sql.user_id
			  ),
			  atrasadas as(
			  select count(sql.id) as qtd, sql.nome as nome, sql.user_id
				from sql
				left join parametros on true
				where sql.status = 0
				  and (sql.retorno < current_timestamp or sql.retorno_id is null)
				  and (parametros.empresa is null or sql.empresa_id = parametros.empresa)
			  	group by sql.nome, sql.user_id
			  ),
			  ativas as (
			    select count(sql.id) as qtd, sql.nome as nome, sql.user_id
				from sql
				left join parametros on true
				where sql.status = 0
				  and sql.retorno is not null
				  and sql.status_id not in (28)
				  and (parametros.empresa is null or sql.empresa_id = parametros.empresa)
			  	group by sql.nome, sql.user_id
			  )

select ativas.nome,
	   ativas.user_id,
	   coalesce(ativas.qtd, 0) as qtd_ativas,
	   coalesce(baixadas.qtd, 0) as qtd_baixadas,
	   coalesce(atrasadas.qtd, 0) as qtd_atrasadas,
	   coalesce(abertas.qtd, 0) as qtd_abertas
from ativas
left join baixadas on baixadas.user_id = ativas.user_id
left join atrasadas on atrasadas.user_id = ativas.user_id
left join abertas on abertas.user_id = ativas.user_id
order by ativas.nome
"
  end

end
