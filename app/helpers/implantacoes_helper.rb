module ImplantacoesHelper

  def self.get_sql_implantacoes(data_inicio, data_fim, empresa, vendedor, implantador, cliente, status, somenteNovos, filtro, fechamento, estado)

    html = " with parametros as (
                      select 	#{ data_inicio.present? ? '\'' + data_inicio + '\'': 'null'}::date as data_inicial,
                              #{ data_fim.present? ? '\'' + data_fim + '\'': 'null'}::date as data_fim,
                              #{ vendedor.present? ? vendedor : 'null'}::int as vendedor,
                              #{ implantador.present? ? implantador : 'null'}::int as implantador,
                              #{ cliente.present? ? cliente : 'null'}::int as cliente,
                              #{ estado.present? ? ApplicationHelper.get_estado_by_codigo(estado) : 'null'}::int as estado,
                              #{ somenteNovos } as somenteNovos,
                              #{ fechamento } as fechamentos

          )
          select distinct implantacao.id,
                          clientes.razao_social,
                          coalesce(sistema.nome, 'Sem Prop.') as sistema,
                          coalesce(vendedor.name, 'Sem Fechamento') as vendedor,
                          coalesce(implantador.name,'') as implantador,
                          coalesce(coalesce(comentario.comentario, implantacao.observacao), '') as observacao,
                          coalesce(agenda_treinamento.data_inicio, agenda_implantacao.data_inicio) as data_agenda,
                          coalesce(coalesce(agenda_treinamento.data_inicio, agenda_implantacao.data_inicio), implantacao.created_at) as dataOrdenacao,
                          implantacao.data_fim,
                          act.created_at,
                          implantacao.data_inicio,
                          case when clientes.telefone_preferencial and clientes.telefone_enviado_whats then clientes.telefone when clientes.telefone2_preferencial and clientes.telefone2_enviado_whats then clientes.telefone2 end as telefone,
                          comentario.created_at as ultimo_comentario
          from implantacoes implantacao
          inner join parametros on true
          inner join clientes on clientes.id = implantacao.cliente_id
          left join cidades cidade on cidade.id = clientes.cidade_id
          left join estados estado on estado.id = cidade.estado_id
          left join fechamentos fechamento on fechamento.cliente_id = implantacao.cliente_id and fechamento.empresa_id = implantacao.empresa_id
          left join status on status.id = fechamento.status_id
          left join propostas proposta on proposta.id = (select id from propostas where propostas.cliente_id = implantacao.cliente_id and propostas.ativa is true order by id desc limit 1)
          left join pacotes pacote on pacote.id = proposta.pacote_id
          left join sistemas sistema on sistema.id = pacote.sistema_id
          left join users vendedor on vendedor.id = fechamento.user_id
          left join users implantador on implantador.id = implantacao.user_id
          left join agendamentos agenda_treinamento on agenda_treinamento.id = (select id from agendamentos agenda where agenda.implantacao_id = implantacao.id and ativo is true and tipo_agendamento_id IN (5,6) order by data_inicio desc limit 1)
          left join agendamentos agenda_implantacao on agenda_implantacao.id = (select id from agendamentos agenda where agenda.implantacao_id = implantacao.id and ativo is true and tipo_agendamento_id IN (1,2) order by data_inicio desc limit 1)
          left join activities act on act.id = (select max(id) from activities where recipient_id = implantacao.id and trackable_type = 'Implantacao' and key = 'implantacao.limbo')
          left join activities activity on activity.recipient_id = implantacao.id and activity.trackable_type = 'Implantacao'
          left join comentarios comentario on comentario.id = (select max(id) from comentarios where implantacao_id = implantacao.id)
          where implantacao.status in #{ status }
            #{ status == '(7,8)' && data_inicio.present? ? ' and implantacao.data_fim::date between parametros.data_inicial and parametros.data_fim': ''}
            #{ status == '(0,1,2,10)' && data_inicio.present? ? ' and (parametros.somenteNovos is false or (implantacao.created_at::date between parametros.data_inicial and parametros.data_fim or activity.created_at::date between parametros.data_inicial and parametros.data_fim  ))': ''}
            #{ status == '(3,4,5,6)' && data_inicio.present? ? ' and (parametros.somenteNovos is false or (implantacao.data_inicio::date between parametros.data_inicial and parametros.data_fim or activity.created_at::date between parametros.data_inicial and parametros.data_fim  ))': ''}
            #{ status == '(9)' && data_inicio.present? ?  ' and implantacao.data_fim::date between parametros.data_inicial and parametros.data_fim': ''}
            #{ status == '(10)' && data_inicio.present? ?  ' and act.created_at::date between parametros.data_inicial and parametros.data_fim': ''}
            #{ filtro == 'boas' ? " and implantacao.status not in (10,2) and coalesce(agenda_treinamento.data_inicio, agenda_implantacao.data_inicio) >= current_timestamp and coalesce(agenda_treinamento.data_inicio, agenda_implantacao.data_inicio) <= current_timestamp + interval '7 days' ": ''}
            #{ filtro == 'atrasadas' ? " and implantacao.status not in (10,2) and coalesce(agenda_treinamento.data_inicio, agenda_implantacao.data_inicio) < current_timestamp ": ''}
            #{ filtro == 'semagenda' ? " and implantacao.status not in (10,2) and coalesce(agenda_treinamento.data_inicio, agenda_implantacao.data_inicio) is null ": ''}
            #{ filtro == 'comagenda' ? " and implantacao.status not in (10,2) and coalesce(agenda_treinamento.data_inicio, agenda_implantacao.data_inicio) is not null ": ''}
            #{ filtro == 'aguardando' ? " and implantacao.status = 2 ": ''}
            #{ filtro == 'limbo' ? " and implantacao.status = 10 ": ''}
            #{ filtro == 'criar_limbo' ? " and coalesce(agenda_treinamento.data_inicio, agenda_implantacao.data_inicio) < current_timestamp - interval '7 days' ": ''}
            and implantacao.empresa_id in (#{ApplicationHelper.get_empresas_by_codigo(empresa)})
            and (parametros.implantador is null or implantacao.user_id = parametros.implantador)
            and (parametros.vendedor is null or fechamento.user_id = parametros.vendedor)
            and (parametros.cliente is null or implantacao.cliente_id = parametros.cliente)
            and (parametros.estado is null or estado.id = parametros.estado)
            #{ data_inicio.present? ? ' and (parametros.fechamentos is false or (fechamento.data_fechamento between parametros.data_inicial and parametros.data_fim)) ' : '' }
            #{ status == '(7,8)' ? ' order by implantacao.data_fim desc': ''}
            #{ status == '(0,1,2,10)' ? ' order by coalesce(coalesce(agenda_treinamento.data_inicio, agenda_implantacao.data_inicio), implantacao.created_at)': ''}
            #{ status == '(3,4,5,6)' ? ' order by implantacao.data_inicio desc': ''}
            #{ status == '(9)' ?  ' order by implantacao.data_fim desc': ''}
            #{ status == '(10)' ?  ' order by act.created_at desc ': ''}
      "
  end

  def self.sql_notificacao_implantacao
    return "select  implantacao.id as implantacao_id,
                    cliente.id as cliente_id,
                    cliente.razao_social,
                    cliente.cnpj,
                    coalesce(agenda_treinamento.data_inicio, agenda_implantacao.data_inicio) as data_agenda,
                    'IMPLANTACAO' as tipo,
                    implantacao.user_id,
                    implantacao.empresa_id,
                    coalesce(tipo_treinamento.descricao, tipo_implantacao.descricao) as tipo_agenda,
                    coalesce(agenda_treinamento.id, agenda_implantacao.id) as id_agenda
            from implantacoes implantacao
            left join clientes cliente on cliente.id = implantacao.cliente_Id
            left join agendamentos agenda_treinamento on agenda_treinamento.id = (select id from agendamentos agenda where agenda.implantacao_id = implantacao.id and ativo is true and tipo_agendamento_id IN (5,6) order by data_inicio desc limit 1)
            left join tipo_agendamentos tipo_treinamento on tipo_treinamento.id = agenda_treinamento.tipo_agendamento_id
            left join agendamentos agenda_implantacao on agenda_implantacao.id = (select id from agendamentos agenda where agenda.implantacao_id = implantacao.id and ativo is true and tipo_agendamento_id IN (1,2) order by data_inicio desc limit 1)
            left join tipo_agendamentos tipo_implantacao on tipo_implantacao.id = agenda_implantacao.tipo_agendamento_id
            left join notificacoes notificacao on notificacao.id = (select max(id) from  notificacoes where modelo_id = implantacao.id and tipo = 'IMPLANTACAO')
            where implantacao.status not in (7,8,9)
              and (agenda_treinamento.id is not null or agenda_implantacao.id is not null)
              and ((agenda_treinamento.id is not null and current_date between (agenda_treinamento.data_inicio - interval '10 minutes') and agenda_treinamento.data_inicio) or
                   (agenda_implantacao.id is not null and current_date between (agenda_implantacao.data_inicio - interval '10 minutes') and agenda_implantacao.data_inicio))
              and notificacao.id is null
            order by implantacao.id desc
            "
  end

  def self.sql_notificacao_implantacao_atrasado(tempo)
    return "select  implantacao.id as implantacao_id,
              cliente.id as cliente_id,
              cliente.razao_social,
              cliente.cnpj,
              coalesce(agenda_treinamento.data_inicio, agenda_implantacao.data_inicio) as data_agenda,
              #{tempo == 20 ? "'IMPLANTACAO_ATRASADA_20'" : "'IMPLANTACAO_ATRASADA_30'"} as tipo,
              implantacao.user_id,
              implantacao.empresa_id,
              coalesce(tipo_treinamento.descricao, tipo_implantacao.descricao) as tipo_agenda,
              act.*,
              agenda_implantacao.data_inicio,
              agenda_treinamento.data_inicio,
              coalesce(agenda_treinamento.id, agenda_implantacao.id) as id_agenda,
              fechamento.user_id as vendedor_id
            from implantacoes implantacao
            left join clientes cliente on cliente.id = implantacao.cliente_Id
            left join fechamentos fechamento on fechamento.id = (select max(id) from fechamentos where cliente_id = cliente.id)
            left join agendamentos agenda_treinamento on agenda_treinamento.id = (select id from agendamentos agenda where agenda.implantacao_id = implantacao.id and ativo is true and tipo_agendamento_id IN (5,6) order by data_inicio desc limit 1)
            left join tipo_agendamentos tipo_treinamento on tipo_treinamento.id = agenda_treinamento.tipo_agendamento_id
            left join agendamentos agenda_implantacao on agenda_implantacao.id = (select id from agendamentos agenda where agenda.implantacao_id = implantacao.id and ativo is true and tipo_agendamento_id IN (1,2) order by data_inicio desc limit 1)
            left join tipo_agendamentos tipo_implantacao on tipo_implantacao.id = agenda_implantacao.tipo_agendamento_id
            left join activities act on act.id = (select id from activities where recipient_id = implantacao.id and trackable_type like '%Implantacao%' and key in ('implantacao.continuou','implantacao.iniciada','implantacao.iniciado_treinamento','implantacao.instalacao_terminada', 'implantacao.aguardando') and created_at > coalesce(agenda_treinamento.data_inicio, agenda_implantacao.data_inicio) order by created_at desc limit 1)
            left join notificacoes notificacao on notificacao.id = (select max(id) from  notificacoes where modelo_id = implantacao.id and tipo = #{tempo == 20 ? "'IMPLANTACAO_ATRASADA_20'" : "'IMPLANTACAO_ATRASADA_30'"})
            where implantacao.status not in (7,8,9)
              and (agenda_treinamento.id is not null or agenda_implantacao.id is not null)
              and ((agenda_treinamento.id is not null and (agenda_treinamento.data_inicio + interval '#{tempo} minutes') < current_date) or
             (agenda_treinamento.id is null and agenda_implantacao.id is not null and (agenda_implantacao.data_inicio + interval '#{tempo} minutes') < current_date))
              and coalesce(agenda_treinamento.data_inicio, agenda_implantacao.data_inicio) > '2018-11-01'
              and act.id is null
              and notificacao.id is null
            order by coalesce(agenda_treinamento.data_inicio, agenda_implantacao.data_inicio)
            "
  end

  def self.implantacoes_desistentes(data_inicio, data_fim, empresa, vendedor, cliente, conferido, status)
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
        coalesce(usuario.name, 'Sem responsável') as responsavel,
        coalesce(SPLIT_PART( contatos.nome, ' ', 1),'') as contato,
        case when cliente.telefone_preferencial then cliente.telefone when cliente.telefone2_preferencial then cliente.telefone2 else cliente.telefone end as telefone,
        implantacao.id,
        implantacao.data_inicio,
        implantacao.data_fim,
        implantacao.baixado,
        implantacao.conferido,
        implantacao.empresa_id,
        implantacao.data_fim::date - implantacao.data_inicio::date as qtd_dias
      from implantacoes implantacao
      left join parametros on true
      left join clientes cliente on cliente.id = implantacao.cliente_id
      left join users usuario on usuario.id = implantacao.user_id
      left join contatos on contatos.id = (select min(id) from contatos where cliente_id = cliente.id)
      where implantacao.status in (#{ status })
        and (parametros.data_inicial is null or implantacao.data_fim::date >= parametros.data_inicial)
        and (parametros.data_fim is null or implantacao.data_fim::date <= parametros.data_fim)
        and (parametros.empresa is null or implantacao.empresa_id = parametros.empresa)
        and (parametros.vendedor is null or usuario.id = parametros.vendedor)
        and (parametros.cliente is null or cliente.id = parametros.cliente)
        and implantacao.conferido = parametros.conferido
        and implantacao.baixado is false
       order by implantacao.data_fim desc"
  end

  def self.implantacoes_sem_retorno(empresa)
    return "
  select distinct implantacao.id,
		  clientes.razao_social,
		  coalesce(sistema.nome, 'Sem Prop.') as sistema,
		  coalesce(vendedor.name, 'Sem Fechamento') as vendedor,
		  coalesce(implantador.name,'') as implantador,
		  coalesce(coalesce(comentario.comentario, implantacao.observacao), '') as observacao,
		  implantacao.data_fim,
		  implantacao.data_inicio,
		  case when clientes.telefone_preferencial and clientes.telefone_enviado_whats then clientes.telefone when clientes.telefone2_preferencial and clientes.telefone2_enviado_whats then clientes.telefone2 end as telefone,
		  comentario.created_at as ultimo_comentario,
		  retorno.data_agendamento_retorno
  from implantacoes implantacao
  inner join parametros on true
  inner join clientes on clientes.id = implantacao.cliente_id
  left join fechamentos fechamento on fechamento.cliente_id = implantacao.cliente_id and fechamento.empresa_id = implantacao.empresa_id
  left join status on status.id = fechamento.status_id
  left join propostas proposta on proposta.id = (select id from propostas where propostas.cliente_id = implantacao.cliente_id and propostas.ativa is true order by id desc limit 1)
  left join pacotes pacote on pacote.id = proposta.pacote_id
  left join sistemas sistema on sistema.id = pacote.sistema_id
  left join users vendedor on vendedor.id = fechamento.user_id
  left join users implantador on implantador.id = implantacao.user_id
  left join agendamento_retornos retorno on retorno.id = (select max(id) from agendamento_retornos where implantacao_id = implantacao.id)
  left join comentarios comentario on comentario.id = (select max(id) from comentarios where implantacao_id = implantacao.id and data_efetuado_retorno is null and cancelado is false)
  where implantacao.status in (0,1,2,3,4,5,6,10)
    and implantacao.empresa_id = #{empresa}
    and retorno.id is null

    "
  end


end
