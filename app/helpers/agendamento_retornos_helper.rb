module AgendamentoRetornosHelper

  def self.get_sql_retornos(empresa, responsavel, cliente, filtro, cidade, qtd_ligacoes, telefone, telefone_preferencial)
    html = " with parametros as (
                      select 	#{ empresa.present? ? empresa : 'null'}::int as empresa,
                              #{ responsavel.present? ? responsavel : 'null'}::int as responsavel,
                              #{ cliente.present? ? cliente : 'null'}::int as cliente,
                              #{ cidade.present? ? cidade : 'null'}::int as cidade,
                              #{ telefone.present? ? telefone.gsub(/[^0-9]/, '') : 'null'}::character varying as telefone,
                              #{ qtd_ligacoes.present? ? qtd_ligacoes : 'null'}::int as qtd_ligacoes,
                              #{ telefone_preferencial.present? ? telefone_preferencial : 'null'}::boolean as telefone_preferencial
          )
          select  agendamento_retornos.id,
                  agendamento_retornos.data_agendamento_retorno,
                  agendamento_retornos.created_at,
                  coalesce(lig.observacao, '') as observacao,
                  clientes.razao_social,
                  users.name,
                  status.descricao,
                  status.id as status_id,
                  clientes.id  as cliente_id,
                  count(ligacoes.id) as qtd_ligacoes,
                  (clientes.telefone_enviado_whats or clientes.telefone2_enviado_whats) as whatsapp,
                  (clientes.telefone_preferencial or clientes.telefone2_preferencial) as telefone_preferencial
          from agendamento_retornos
          left join parametros on true
          left join clientes on clientes.id = agendamento_retornos.cliente_id
          left join ligacoes on ligacoes.cliente_id = clientes.id
          left join status on status.id = clientes.status_id
          left join ligacoes lig on lig.id = agendamento_retornos.ligacao_id
          left join users on users.id = agendamento_retornos.user_id
          where agendamento_retornos.cancelado is false
            and agendamento_retornos.data_efetuado_retorno is null
            and agendamento_retornos.data_agendamento_retorno is not null
            and (parametros.empresa is null or agendamento_retornos.empresa_id = parametros.empresa)
            and (parametros.responsavel is null or users.id = parametros.responsavel)
            and (parametros.cliente is null or agendamento_retornos.cliente_id = parametros.cliente)
            and (parametros.cidade is null or clientes.cidade_id = parametros.cidade)
            and (parametros.telefone_preferencial is null or (clientes.telefone_preferencial or clientes.telefone2_preferencial) = parametros.telefone_preferencial)
            and clientes.status_id in (1,6)
            and agendamento_retornos.ligacao_id is not null
            and (parametros.telefone is null or (NULLIF(regexp_replace(clientes.telefone, '\\D','','g'), '') = parametros.telefone or NULLIF(regexp_replace(clientes.telefone2, '\\D','','g'), '') = parametros.telefone))
            #{ filtro == 'hoje' ? ' and agendamento_retornos.data_agendamento_retorno::date = current_date and agendamento_retornos.data_agendamento_retorno >= current_timestamp ': ''}
            #{ filtro == 'atrasadas' ? ' and (agendamento_retornos.data_agendamento_retorno < current_timestamp) ': ''}
            #{ filtro == 'amanha' ? ' and agendamento_retornos.data_agendamento_retorno::date = current_date+1 ': ''}
            #{ filtro == 'prox' ? ' and agendamento_retornos.data_agendamento_retorno::date > current_date+2 and agendamento_retornos.data_agendamento_retorno::date <= current_date+9 ': ''}
            #{ filtro == 'demais' ? ' and agendamento_retornos.data_agendamento_retorno::date > current_date+7 ': ''}
            group by agendamento_retornos.id, agendamento_retornos.data_agendamento_retorno, agendamento_retornos.created_at, lig.observacao,
                  clientes.razao_social, users.name, status.descricao, status.id, clientes.id, parametros.qtd_ligacoes
          having (parametros.qtd_ligacoes is null or count(ligacoes.id)  = parametros.qtd_ligacoes)
            order by agendamento_retornos.data_agendamento_retorno asc
      "
  end

  def self.get_sql_retornos_implantacao(empresa, responsavel, cliente, filtro, cidade, telefone_preferencial)

    html = " with parametros as (
                      select 	#{ empresa.present? ? empresa : 'null'}::int as empresa,
                              #{ responsavel.present? ? responsavel : 'null'}::int as responsavel,
                              #{ cliente.present? ? cliente : 'null'}::int as cliente,
                              #{ cidade.present? ? cidade : 'null'}::int as cidade,
                              #{ telefone_preferencial.present? ? telefone_preferencial : 'null'}::boolean as telefone_preferencial
          )
          select agendamento_retornos.id,
                 agendamento_retornos.data_agendamento_retorno,
                 agendamento_retornos.created_at,
                 coalesce(implantacoes.observacao, '') as observacao,
                 clientes.razao_social,
                 users.name,
                 status.descricao,
                 status.id as status_id,
                 clientes.id  as cliente_id,
                 (clientes.telefone_enviado_whats or clientes.telefone2_enviado_whats) as whatsapp,
                 (clientes.telefone_preferencial or clientes.telefone2_preferencial) as telefone_preferencial,
                 comentarios.comentario ultimo_comentario_implantacao,
                 implantacoes.id as implantacao_id,
                 coalesce((coalesce(implantacoes.data_fim, current_timestamp)::date - implantacoes.data_inicio::date),0) as qtd_dias
          from agendamento_retornos
          left join parametros on true
          left join clientes on clientes.id = agendamento_retornos.cliente_id
          inner join implantacoes on implantacoes.id = agendamento_retornos.implantacao_id
          left join comentarios on comentarios.id = (select max(id) from comentarios where implantacao_id = implantacoes.id)
          left join status on status.id = clientes.status_id
          left join users on users.id = agendamento_retornos.user_id
          where agendamento_retornos.cancelado is false
            and agendamento_retornos.data_efetuado_retorno is null
            and agendamento_retornos.data_agendamento_retorno is not null
            and (parametros.empresa is null or agendamento_retornos.empresa_id = parametros.empresa)
            and (parametros.responsavel is null or users.id = parametros.responsavel)
            and (parametros.cliente is null or agendamento_retornos.cliente_id = parametros.cliente)
            and (parametros.cidade is null or clientes.cidade_id = parametros.cidade)
            and (parametros.telefone_preferencial is null or (clientes.telefone_preferencial or clientes.telefone2_preferencial) = parametros.telefone_preferencial)
            #{ filtro == 'hoje' ? ' and agendamento_retornos.data_agendamento_retorno::date = current_date and agendamento_retornos.data_agendamento_retorno >= current_timestamp ': ''}
            #{ filtro == 'atrasadas' ? ' and (agendamento_retornos.data_agendamento_retorno < current_timestamp) ': ''}
            #{ filtro == 'amanha' ? ' and agendamento_retornos.data_agendamento_retorno::date = current_date+1 ': ''}
            #{ filtro == 'prox' ? ' and agendamento_retornos.data_agendamento_retorno::date > current_date+2 and agendamento_retornos.data_agendamento_retorno::date <= current_date+9 ': ''}
            #{ filtro == 'demais' ? ' and agendamento_retornos.data_agendamento_retorno::date > current_date+7 ': ''}
            order by agendamento_retornos.data_agendamento_retorno asc
      "
  end

  def self.get_sql_retornos_acompanhamento(empresa, responsavel, cliente, filtro, cidade, telefone_preferencial)
    html = " with parametros as (
                      select 	#{ empresa.present? ? empresa : 'null'}::int as empresa,
                              #{ responsavel.present? ? responsavel : 'null'}::int as responsavel,
                              #{ cliente.present? ? cliente : 'null'}::int as cliente,
                              #{ cidade.present? ? cidade : 'null'}::int as cidade,
                              #{ telefone_preferencial.present? ? telefone_preferencial : 'null'}::boolean as telefone_preferencial
          )
          select  agendamento_retornos.id,
                  agendamento_retornos.data_agendamento_retorno,
                  agendamento_retornos.created_at,
                  coalesce(acompanhamentos.observacao,'') as observacao,
                  clientes.razao_social,
                  users.name,
                  status.descricao,
                  status.id as
                  status_id,
                  clientes.id  as cliente_id,
                  (cidades.nome || '-' || estados.sigla) as cidade,
                  (clientes.telefone_enviado_whats or clientes.telefone2_enviado_whats) as whatsapp,
                  (clientes.telefone_preferencial or clientes.telefone2_preferencial) as telefone_preferencial,
                  coalesce(comentarios.comentario,'') ultimo_comentario_acompanhamento,
                  acompanhamentos.id as acompanhamento_id,
                  (coalesce(acompanhamentos.data_fim, current_timestamp)::date - coalesce(acompanhamentos.data_inicio, current_timestamp)::date) as qtd_dias
          from agendamento_retornos
          left join parametros on true
          left join clientes on clientes.id = agendamento_retornos.cliente_id
          left join cidades on cidades.id = clientes.cidade_id
          left join estados on estados.id = cidades.estado_id
          inner join acompanhamentos on acompanhamentos.id = agendamento_retornos.acompanhamento_id
          left join comentarios on comentarios.id = (select max(id) from comentarios where acompanhamento_id = acompanhamentos.id)
          left join propostas on propostas.id = acompanhamentos.proposta_id
          left join status on status.id = clientes.status_id
          left join users on users.id = agendamento_retornos.user_id
          where agendamento_retornos.cancelado is false
            and agendamento_retornos.data_efetuado_retorno is null
            and agendamento_retornos.data_agendamento_retorno is not null
            and (parametros.empresa is null or agendamento_retornos.empresa_id = parametros.empresa)
            and (parametros.responsavel is null or users.id = parametros.responsavel)
            and (parametros.cliente is null or agendamento_retornos.cliente_id = parametros.cliente)
            and (parametros.cidade is null or clientes.cidade_id = parametros.cidade)
            and (parametros.telefone_preferencial is null or (clientes.telefone_preferencial or clientes.telefone2_preferencial) = parametros.telefone_preferencial)
            #{ filtro == 'hoje' ? ' and agendamento_retornos.data_agendamento_retorno::date = current_date and agendamento_retornos.data_agendamento_retorno >= current_timestamp ': ''}
            #{ filtro == 'atrasadas' ? ' and (agendamento_retornos.data_agendamento_retorno < current_timestamp) ': ''}
            #{ filtro == 'amanha' ? ' and agendamento_retornos.data_agendamento_retorno::date = current_date+1 ': ''}
            #{ filtro == 'prox' ? ' and agendamento_retornos.data_agendamento_retorno::date > current_date+2 and agendamento_retornos.data_agendamento_retorno::date <= current_date+9 ': ''}
            #{ filtro == 'demais' ? ' and agendamento_retornos.data_agendamento_retorno::date > current_date+7 ': ''}
            order by agendamento_retornos.data_agendamento_retorno asc
      "
  end

  def self.retornos_cancelados(data_inicio, data_fim, empresa, vendedor, cliente, conferido, atrasado)
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
        retorno.id,
        retorno.data_agendamento_retorno,
        retorno.data_cancelamento,
        retorno.conferido,
        retorno.baixado
      from agendamento_retornos retorno
      left join parametros on true
      left join clientes cliente on cliente.id = retorno.cliente_id
      left join users usuario on usuario.id = retorno.user_id
      left join contatos on contatos.id = (select min(id) from contatos where cliente_id = cliente.id)
      where retorno.cancelado is true
        and (parametros.data_inicial is null or retorno.data_cancelamento::date >= parametros.data_inicial)
        and (parametros.data_fim is null or retorno.data_cancelamento::date <= parametros.data_fim)
        and (parametros.empresa is null or retorno.empresa_id = parametros.empresa)
        and (parametros.vendedor is null or usuario.id = parametros.vendedor)
        and (parametros.cliente is null or cliente.id = parametros.cliente)
        and retorno.conferido = parametros.conferido
        and retorno.baixado is false
        and cliente.status_id in (1,6)
        and retorno.ligacao_id is not null
        #{ atrasado == 'true' ? ' and  retorno.data_agendamento_retorno < retorno.data_cancelamento' : ''}
        #{ atrasado == 'false' ? ' and retorno.data_agendamento_retorno > retorno.data_cancelamento' : ''}
       order by retorno.data_cancelamento desc"
  end

end
