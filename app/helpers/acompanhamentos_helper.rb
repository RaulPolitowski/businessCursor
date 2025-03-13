module AcompanhamentosHelper

  def self.get_sql_acompanhamentos(data_inicio, data_fim, empresa, vendedor, implantador, cliente, status, somenteNovos, responsavel, estado)

    html = " with parametros as (
                      select 	#{ data_inicio.present? ? '\'' + data_inicio + '\'': 'null'}::date as data_inicial,
                              #{ data_fim.present? ? '\'' + data_fim + '\'': 'null'}::date as data_fim,
                              #{ vendedor.present? ? vendedor : 'null'}::int as vendedor,
                              #{ implantador.present? ? implantador : 'null'}::int as implantador,
                              #{ responsavel.present? ? responsavel : 'null'}::int as responsavel,
                              #{ cliente.present? ? cliente : 'null'}::int as cliente,
                              #{ estado.present? ? ApplicationHelper.get_estado_by_codigo(estado) : 'null'}::int as estado,
                              #{ somenteNovos } as somenteNovos

          )
          select  acompanhamento.id,
                  clientes.razao_social,
                  coalesce(sistema.nome, 'Sem Prop.') as sistema,
                  coalesce(coalesce(comentario.comentario, acompanhamento.observacao), '') as observacao,
                  comentario.created_at as ultimo_comentario,
                  implantacao.data_fim as fim_implantacao,
	                retorno.data_agendamento_retorno, acompanhamento.status,
                  case when clientes.telefone_preferencial and clientes.telefone_enviado_whats then clientes.telefone when clientes.telefone2_preferencial and clientes.telefone2_enviado_whats then clientes.telefone2 end as telefone
          from acompanhamentos acompanhamento
          inner join parametros on true
          inner join clientes on clientes.id = acompanhamento.cliente_id
          left join cidades cidade on cidade.id = clientes.cidade_id
          left join estados estado on estado.id = cidade.estado_id
          left join implantacoes implantacao on implantacao.cliente_id = clientes.id
          left join fechamentos fechamento on fechamento.cliente_id = implantacao.cliente_id and fechamento.empresa_id = implantacao.empresa_id
          left join status on status.id = fechamento.status_id
          left join propostas proposta on proposta.id = (select id from propostas where propostas.cliente_id = implantacao.cliente_id and propostas.ativa is true order by id desc limit 1)
          left join pacotes pacote on pacote.id = proposta.pacote_id
          left join sistemas sistema on sistema.id = pacote.sistema_id
          left join agendamento_retornos retorno on retorno.id = (select id from agendamento_retornos where cancelado is false and data_efetuado_retorno is null and acompanhamento_id = acompanhamento.id order by data_agendamento_retorno asc limit 1)
          left join comentarios comentario on comentario.id = (select max(id) from comentarios where acompanhamento_id = acompanhamento.id)
          where acompanhamento.status in #{ status }
          #{ status == '(3,4)' && data_inicio.present? ? ' and acompanhamento.data_fim::date between parametros.data_inicial and parametros.data_fim': ''}
          #{ status == '(0)' && data_inicio.present? ? ' and (parametros.somenteNovos is false or acompanhamento.created_at::date between parametros.data_inicial and parametros.data_fim)': ''}
          #{ status == '(1,2)' && data_inicio.present? ? ' and (parametros.somenteNovos is false or acompanhamento.data_inicio::date between parametros.data_inicial and parametros.data_fim)': ''}
          #{ status == '(5)' && data_inicio.present? ? ' and acompanhamento.data_fim::date between parametros.data_inicial and parametros.data_fim': ''}
            and acompanhamento.empresa_id in (#{ApplicationHelper.get_empresas_by_codigo(empresa)})
            and (parametros.implantador is null or implantacao.user_id = parametros.implantador)
            and (parametros.responsavel is null or acompanhamento.user_id = parametros.responsavel)
            and (parametros.vendedor is null or fechamento.user_id = parametros.vendedor)
            and (parametros.cliente is null or acompanhamento.cliente_id = parametros.cliente)
            and (parametros.estado is null or estado.id = parametros.estado)
            #{ status == '(3,4)' ? ' order by acompanhamento.data_fim desc ': ''}
            #{ status == '(1)' || status == '(2)' || status == '(0)' ? ' order by retorno.data_agendamento_retorno asc': ''}
            #{ status == '(5)' ? ' order by acompanhamento.data_fim desc': ''}
      "
  end

  def self.get_acompanhamentos_retorno(user_id, empresa_id, aviso)
    return "select  acompanhamento.id,
                    clientes.razao_social,
                    retorno.data_agendamento_retorno,
                    (now() - interval '20 minute'),
                    acompanhamento.status,
                    acompanhamento.user_id,
                    retorno.id as retorno_id,
                    #{ aviso ? 'true' : 'false'} as aviso
            from acompanhamentos acompanhamento
            inner join clientes on clientes.id = acompanhamento.cliente_id
            left join agendamento_retornos retorno on retorno.id = (select id from agendamento_retornos where cancelado is false and data_efetuado_retorno is null and acompanhamento_id = acompanhamento.id order by data_agendamento_retorno asc limit 1)
            where acompanhamento.status in (1,2)
              #{ aviso ? "and retorno.data_agendamento_retorno between  (now() - interval '5 minute') and now() " : "and retorno.data_agendamento_retorno < (now() - interval '20 minute')" }
              and acompanhamento.user_id = #{user_id}
              and acompanhamento.empresa_id = #{empresa_id}
              #{ aviso ? " and retorno.avisado is false " : ""}
            order by retorno.data_agendamento_retorno  limit 3"
  end

  def self.acompanhamentos_desistentes(data_inicio, data_fim, empresa, vendedor, cliente, conferido, status)
    return "with parametros as (
                      select 	#{ data_inicio.present? ? '\'' + data_inicio + '\'': 'null'}::date as data_inicial,
                              #{ data_fim.present? ? '\'' + data_fim + '\'': 'null'}::date as data_fim,
                              #{ empresa.present? ? empresa : 'null'}::int as empresa,
                              #{ vendedor.present? ? vendedor : 'null'}::int as vendedor,
                              #{ cliente.present? ? cliente : 'null'}::int as cliente,
                              #{ conferido } as conferido
          )
      select 	cliente.id as cliente_id,
        cliente.razao_social,
        usuario.id as usuario_id,
        usuario.name as responsavel,
        coalesce(SPLIT_PART( contatos.nome, ' ', 1),'') as contato,
        case when cliente.telefone_preferencial then cliente.telefone when cliente.telefone2_preferencial then cliente.telefone2 else cliente.telefone end as telefone,
        acompanhamento.id,
        acompanhamento.data_inicio,
        acompanhamento.data_fim,
        acompanhamento.baixado,
        acompanhamento.conferido,
        acompanhamento.empresa_id,
        acompanhamento.status,
        acompanhamento.data_fim::date - acompanhamento.data_inicio::date as qtd_dias
      from acompanhamentos acompanhamento
      left join parametros on true
      left join clientes cliente on cliente.id = acompanhamento.cliente_id
      left join users usuario on usuario.id = acompanhamento.user_id
      left join contatos on contatos.id = (select min(id) from contatos where cliente_id = cliente.id)
      where acompanhamento.status in #{status}
        and (parametros.data_inicial is null or acompanhamento.data_fim::date >= parametros.data_inicial)
        and (parametros.data_fim is null or acompanhamento.data_fim::date <= parametros.data_fim)
        and (parametros.empresa is null or acompanhamento.empresa_id = parametros.empresa)
        and (parametros.vendedor is null or usuario.id = parametros.vendedor)
        and (parametros.cliente is null or cliente.id = parametros.cliente)
        and acompanhamento.conferido = parametros.conferido
        and acompanhamento.baixado is false
       order by acompanhamento.data_fim desc"
  end

  def self.acompanhamentos_sem_retorno(empresa)
    return "
  select distinct acompanhamento.id,
        clientes.razao_social,
        coalesce(sistema.nome, 'Sem Prop.') as sistema,
        coalesce(vendedor.name, 'Sem Fechamento') as vendedor,
        coalesce(implantador.name,'') as implantador,
        coalesce(coalesce(comentario.comentario, acompanhamento.observacao), '') as observacao,
        acompanhamento.data_fim,
        acompanhamento.data_inicio,
        coalesce(case when clientes.telefone_preferencial and clientes.telefone_enviado_whats then clientes.telefone when clientes.telefone2_preferencial and clientes.telefone2_enviado_whats then clientes.telefone2 end, '') as telefone,
        comentario.created_at as ultimo_comentario,
        retorno.data_agendamento_retorno
    from acompanhamentos acompanhamento
    inner join parametros on true
    inner join clientes on clientes.id = acompanhamento.cliente_id
    left join fechamentos fechamento on fechamento.cliente_id = acompanhamento.cliente_id and fechamento.empresa_id = acompanhamento.empresa_id
    left join status on status.id = fechamento.status_id
    left join propostas proposta on proposta.id = (select id from propostas where propostas.cliente_id = acompanhamento.cliente_id and propostas.ativa is true order by id desc limit 1)
    left join pacotes pacote on pacote.id = proposta.pacote_id
    left join sistemas sistema on sistema.id = pacote.sistema_id
    left join users vendedor on vendedor.id = fechamento.user_id
    left join users implantador on implantador.id = acompanhamento.user_id
    left join agendamento_retornos retorno on retorno.id = (select max(id) from agendamento_retornos where acompanhamento_id = acompanhamento.id and data_efetuado_retorno is null and cancelado is false)
    left join comentarios comentario on comentario.id = (select max(id) from comentarios where implantacao_id = acompanhamento.id)
    where acompanhamento.status in (0,1,2)
      and acompanhamento.empresa_id = #{empresa}
      and retorno.id is null

    "
  end

end
