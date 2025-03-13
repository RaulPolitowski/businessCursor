module NotificacoesHelper

  def self.registrar_fechamento(empresa_id, cliente, user_id, status, proposta)
    notificacao = Notificacao.where(tipo: 'FECHAMENTO', modelo_id: cliente.id).first

    if notificacao.nil?
      users = User.where(admin: true)
      user_fechamento = User.find user_id
      users.each do |user|
        Notificacao.criar_notificacao('FECHAMENTO', user.id, user_id,
                                      "Cliente #{cliente.razao_social},#{ status.descricao},#{user_fechamento.name},#{proposta.pacote.sistema.nome}",
                                      Time.now, empresa_id, cliente.id, 'Fechamento!', nil, nil)
      end
    end
  end

  def self.get_notificacoes_obrigatorias(operador)
    return "
      with parametros as (
        select  #{operador}::int as operador
      ),
      negociacao as (
        select  distinct cliente.id as cliente_id,
        cliente.razao_social,
        cliente.cnpj,
        negociacao.id,
        negociacao.data_inicio,
        negociacao.data_fim,
        negociacao.status,
        negociacao.empresa_id,
        current_date - negociacao.data_inicio::date as qtd_dias,
        case when cliente.telefone_preferencial then cliente.telefone when cliente.telefone2_preferencial then cliente.telefone2 else cliente.telefone end as telefone,
        negociacao.atendimento_whatsapp,
        negociacao.atendimento_telefone,
        vendedor.name as vendedor,
        coalesce(SPLIT_PART( contatos.nome, ' ', 1),'') as contato,
        agendamento_retornos.data_agendamento_retorno as retorno, agendamento_retornos.id as retorno_id,
        l.observacao as observacao,
        status.descricao,
        status.id as status_id,
        empresas.razao_social as empresa,
        'NEGOCIACAO'::text as tipo
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
        and (parametros.operador is null or vendedor.id = parametros.operador)
        and (agendamento_retornos.data_agendamento_retorno < current_timestamp or agendamento_retornos.id is null)
        and agendamento_retornos.cancelado is false
        order by agendamento_retornos.data_agendamento_retorno
      ),
      implantacao as (
        select  distinct cliente.id as cliente_id,
        cliente.razao_social,
        cliente.cnpj,
        impl.id,
        impl.data_inicio,
        impl.data_fim,
        impl.status,
        impl.empresa_id,
        current_date - impl.data_inicio::date as qtd_dias,
        case when cliente.telefone_preferencial then cliente.telefone when cliente.telefone2_preferencial then cliente.telefone2 else cliente.telefone end as telefone,
        negociacao.atendimento_whatsapp,
        negociacao.atendimento_telefone,
        implantador.name as implantador,
        coalesce(SPLIT_PART( contatos.nome, ' ', 1),'') as contato,
        agendamento_retornos.data_agendamento_retorno as retorno, agendamento_retornos.id as retorno_id,
        impl.observacao as observacao,
        status.descricao,
        status.id as status_id,
        empresas.razao_social as empresa,
        'IMPLANTACAO'::text as tipo
        from implantacoes impl
        left join parametros on true
        left join clientes cliente on cliente.id = impl.cliente_id
        left join status on status.id = cliente.status_id
        left join negociacoes negociacao on negociacao.cliente_id = impl.cliente_id
        left join users implantador on implantador.id = impl.user_id
        inner join agendamento_retornos on agendamento_retornos.id = (select max(id) from agendamento_retornos a where a.implantacao_id = impl.id and a.data_efetuado_retorno is null and a.cancelado is false)
        left join contatos on contatos.id = (select min(id) from contatos where cliente_id = cliente.id)
        left join empresas on empresas.id = impl.empresa_id
        where impl.status not in (7,8,9)
        and (parametros.operador is null or agendamento_retornos.user_id = parametros.operador)
        and (agendamento_retornos.data_agendamento_retorno < current_timestamp or agendamento_retornos.id is null)
        and agendamento_retornos.cancelado is false
        order by agendamento_retornos.data_agendamento_retorno
      ),
      acompanhamentos as (
        select  distinct cliente.id as cliente_id,
        cliente.razao_social,
        cliente.cnpj,
        acomp.id,
        acomp.data_inicio,
        acomp.data_fim,
        acomp.status,
        acomp.empresa_id,
        current_date - acomp.data_inicio::date as qtd_dias,
        case when cliente.telefone_preferencial then cliente.telefone when cliente.telefone2_preferencial then cliente.telefone2 else cliente.telefone end as telefone,
        negociacao.atendimento_whatsapp,
        negociacao.atendimento_telefone,
        responsavel.name as responsavel,
        coalesce(SPLIT_PART( contatos.nome, ' ', 1),'') as contato,
        agendamento_retornos.data_agendamento_retorno as retorno, agendamento_retornos.id as retorno_id,
        acomp.observacao as observacao,
        status.descricao,
        status.id as status_id,
        empresas.razao_social as empresa,
        'ACOMPANHAMENTO'::text as tipo
        from acompanhamentos acomp
        left join parametros on true
        left join clientes cliente on cliente.id = acomp.cliente_id
        left join status on status.id = cliente.status_id
        left join negociacoes negociacao on negociacao.cliente_id = acomp.cliente_id
        left join users responsavel on responsavel.id = acomp.user_id
        inner join agendamento_retornos on agendamento_retornos.id = (select max(id) from agendamento_retornos a where a.acompanhamento_id = acomp.id and a.data_efetuado_retorno is null and a.cancelado is false)
        left join contatos on contatos.id = (select min(id) from contatos where cliente_id = cliente.id)
        left join empresas on empresas.id = acomp.empresa_id
        where acomp.status not in (3,4,5)
        and (parametros.operador is null or agendamento_retornos.user_id = parametros.operador)
        and (agendamento_retornos.data_agendamento_retorno < current_timestamp or agendamento_retornos.id is null)
        and agendamento_retornos.cancelado is false
        order by agendamento_retornos.data_agendamento_retorno
      )
      select *
      from acompanhamentos
      union all
      select *
      from implantacao
      union all
      select *
      from negociacao
    "
  end

end
