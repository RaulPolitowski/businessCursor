module CampanhasHelper

  def self.get_sql_previsao_termino(id)
    "
    SELECT
    TO_CHAR(CURRENT_TIMESTAMP + ((round(((CASE WHEN tempo_espera > 0 THEN tempo_espera ELSE tempo_total / (qtd_total - SUM(case when env.status IN ('ERROR', 'ENVIADO', 'IGNORADO') then 1 else 0 end)) END) / 60::decimal), 2) * (qtd_total - SUM(case when env.status IN ('ERROR', 'ENVIADO', 'IGNORADO') then 1 else 0 end))) * interval '1 minute'), 'DD/MM/YYYY HH24:MI') AS previsao,
    sum(case when env.status = 'AGUARDANDO' then 1 else 0 end) as qtd_aguardando,
    sum(case when env.status = 'ENVIADO' then 1 else 0 end) as qtd_enviado,
    sum(case when env.status = 'ERROR' then 1 else 0 end) as qtd_erro,
    sum(case when env.status = 'IGNORADO' then 1 else 0 end) as qtd_ignorado
    FROM campanhas camp
    LEFT JOIN campanha_envios env ON env.campanha_id = camp.id
    WHERE camp.id = #{id}
    GROUP BY camp.agendado_at, camp.created_at, tempo_espera, tempo_total, qtd_total;
    "
  end

  def self.get_sql_andamento(job, telefone_id, usuario_id, estado, numero)
    "with parametros as (
                         select #{ job.present? ? job : 'null'}::int as job,
                       #{ estado.present? ?  "'#{estado}'" : 'null'}::varchar as estado,
                       #{ numero.present? ?  numero : 'null'}::varchar as numero
                       ),
    sql as (
    select num.numero, camp.id, camp.qtd_total,
    sum(case when env.status = 'AGUARDANDO' then 1 else 0 end) as qtd_aguardando,
    sum(case when env.status = 'ENVIADO' then 1 else 0 end) as qtd_enviado,
    sum(case when env.status = 'ERROR' then 1 else 0 end) as qtd_erro,
    sum(case when env.status = 'IGNORADO' then 1 else 0 end) as qtd_ignorado,
    TO_CHAR(COALESCE(camp.agendado_at, CURRENT_TIMESTAMP) + ((round(((CASE WHEN tempo_espera > 0 THEN tempo_espera ELSE tempo_total / (qtd_total - SUM(case when env.status IN ('ERROR', 'ENVIADO', 'IGNORADO') then 1 else 0 end)) END) / 60::decimal), 2) * (qtd_total - SUM(case when env.status IN ('ERROR', 'ENVIADO', 'IGNORADO') then 1 else 0 end))) * interval '1 minute'), 'DD/MM/YYYY HH24:MI') AS previsao,
    camp.tempo_espera,
    camp.tempo_total,
    coalesce(num.nome, users.name) as nome,
    camp.job,
    camp.agendado_at,
    case when estados.sigla = 'DF' then 'CD' else estados.sigla end as sigla,
    TO_CHAR(camp.created_at, 'DD/MM/YYYY HH24:MI') as created_at,
    camp.created_at as criado,
    num.created_at as numero_created_at,
    emp.id as empresa_id,
    num.status as numero_status,
    camp.is_pausada as is_pausada,
    (num.banido)::varchar as banido
    from whatsapp_numeros num
    left join parametros on true
    left join campanhas camp on camp.numero = num.numero
    left join campanha_envios env on env.campanha_id = camp.id
    left join empresas emp on emp.id = camp.empresa_id
    left join cidades on cidades.id = emp.cidade_id
    left join estados on estados.id = cidades.estado_id
    left join users on users.id = num.user_id
    where camp.status = 'ANDAMENTO'
      and num.status != 'DESCONECTADO'
      and (parametros.job is null or camp.job = parametros.job)
      and (parametros.estado is null or estados.sigla = parametros.estado)
      #{ numero.present? ? " and (parametros.numero = num.numero) " : ''}
      #{ telefone_id.present? ? " and num.id in (#{telefone_id}) " : ''}
      #{ usuario_id.present? ? " and users.id in (#{usuario_id}) " : ''}
    group by num.numero, camp.id, camp.qtd_total, num.nome, camp.created_at, camp.job, estados.sigla, users.name, num.status, num.created_at, num.banido, emp.id
    )
    select *,
      (((qtd_enviado + qtd_erro + qtd_ignorado) * 100)/qtd_total) as status
    from sql
  order by criado
    "
  end

  def self.get_sql_finalizadas(data_inicio, data_fim, job, telefone_id, usuario_id, estado, numero)
    "with parametros as (
                         select 	#{ data_inicio.present? ? '\'' + data_inicio + '\'': 'null'}::date as data_inicial,
                       #{ data_fim.present? ? '\'' + data_fim + '\'': 'null'}::date as data_fim,
                       #{ job.present? ? job : 'null'}::int as job,
                       #{ estado.present? ?  "'#{estado}'" : 'null'}::varchar as estado,
                       #{ numero.present? ?  numero : 'null'}::varchar as numero
                       )
    select num.numero, camp.id, camp.qtd_total,camp.qtd_enviado, coalesce(camp.qtd_erros,0) as qtd_erros, camp.qtd_ignorado,
    camp.tempo_espera,
    camp.tempo_total,
    coalesce(num.nome, users.name) as nome,
    camp.job,
    case when estados.sigla = 'DF' then 'CD' else estados.sigla end as sigla,
    TO_CHAR(camp.updated_at, 'DD/MM/YYYY HH24:MI') as updated_at,
    emp.id as empresa_id,
    num.status as numero_status,
    (num.banido)::varchar as banido
    from whatsapp_numeros num
    left join parametros on true
    left join campanhas camp on camp.numero = num.numero
    left join empresas emp on emp.id = camp.empresa_id
    left join cidades on cidades.id = emp.cidade_id
    left join estados on estados.id = cidades.estado_id
    left join users on users.id = num.user_id
    where camp.status = 'FINALIZADO'
      and (parametros.data_inicial is null or camp.updated_at::date between parametros.data_inicial and parametros.data_fim)
      and (parametros.job is null or camp.job = parametros.job)
      and (parametros.estado is null or estados.sigla = parametros.estado)
      #{ numero.present? ? " and (parametros.numero = num.numero) " : ''}
      #{ telefone_id.present? ? " and num.id in (#{telefone_id}) " : ''}
      #{ usuario_id.present? ? " and users.id in (#{usuario_id}) " : ''}
	  order by camp.updated_at desc
    "
  end

  def self.get_sql_aguardando(job, telefone_id, usuario_id, estado)
    "with parametros as (
                         select #{ job.present? ? job : 'null'}::int as job,
                       #{ estado.present? ?  "'#{estado}'" : 'null'}::varchar as estado
                       )
    select num.numero, camp.id, camp.qtd_total, camp.qtd_enviado, camp.qtd_erros, camp.qtd_ignorado,
    camp.tempo_espera,
    camp.tempo_total,
    num.created_at as numero_created_at,
    coalesce(num.nome, users.name) as nome,
    camp.agendado_at,
    camp.job,
    case when estados.sigla = 'DF' then 'CD' else estados.sigla end as sigla,
    TO_CHAR(camp.created_at, 'DD/MM/YYYY HH24:MI') as created_at,
    camp.status,
    num.status as numero_status,
    (num.banido)::varchar as banido
    from whatsapp_numeros num
    left join parametros on true
    left join loja_itens li on li.numero = num.numero
    left join campanhas camp on camp.numero = num.numero
    left join empresas emp on emp.id = camp.empresa_id
    left join cidades on cidades.id = emp.cidade_id
    left join estados on estados.id = cidades.estado_id
    left join users on users.id = num.user_id
    where camp.status in ('AGUARDANDO', 'ENVIADA', 'NAO ENVIADA')
      and num.status != 'DESCONECTADO'
      and (parametros.job is null or camp.job = parametros.job)
      and (li.status = 'COMPRADO' OR (li.id IS NUll AND li.status IS NULL))
      and (parametros.estado is null or estados.sigla = parametros.estado)
      #{ telefone_id.present? ? " and num.id in (#{telefone_id}) " : ''}
    #{ usuario_id.present? ? " and users.id in (#{usuario_id}) " : ''}
	  order by camp.updated_at desc limit 50"
  end

  def self.get_sql_totalizadores_estado(data_inicio, data_fim)
    "WITH parametros AS (
      select 	#{ data_inicio.present? ? '\'' + data_inicio + '\'': 'null'}::date as data_inicial,
      #{ data_fim.present? ? '\'' + data_fim + '\'': 'null'}::date as data_fim
    )
    SELECT e.nome, SUM(camp.qtd_enviado - camp.qtd_erros) AS qtd,
    CASE WHEN e.sigla = 'DF' THEN 'CD' ELSE e.sigla END as sigla
    FROM whatsapp_numeros num
    INNER JOIN parametros ON true
    INNER JOIN campanhas camp ON camp.numero = num.numero
    INNER JOIN empresas emp ON emp.id = camp.empresa_id
    INNER JOIN cidades ON cidades.id = emp.cidade_id
    INNER JOIN estados e ON e.id = cidades.estado_id
    WHERE ((camp.status = 'FINALIZADO')
      AND ((parametros.data_inicial IS null)
        OR (camp.updated_at::date BETWEEN parametros.data_inicial AND parametros.data_fim)
      )
    )
    GROUP BY e.id, e.nome
    ORDER BY qtd DESC;"
  end

  def self.get_sql_totalizadores_usuario(data_inicio, data_fim)
    "WITH parametros AS (
      SELECT #{ data_inicio.present? ? '\'' + data_inicio + '\'': 'null'}::date AS data_inicial,
      #{ data_fim.present? ? '\'' + data_fim + '\'': 'null'}::date AS data_fim
    )
    SELECT users.name, SUM(camp.qtd_enviado - camp.qtd_erros) AS qtd FROM whatsapp_numeros num
    INNER JOIN parametros ON true
    INNER JOIN campanhas camp ON camp.numero = num.numero
    INNER JOIN users ON users.id = num.user_id
    WHERE (
      (camp.status = 'FINALIZADO')
      AND (
        (parametros.data_inicial IS null)
        OR (camp.updated_at::date BETWEEN parametros.data_inicial AND parametros.data_fim)
      )
    )
    GROUP BY users.name
    ORDER BY qtd DESC;"
  end

  def self.get_sql_info_numeros(data_inicio, data_fim)
    "WITH parametros AS (
      SELECT #{ data_inicio.present? ? '\'' + data_inicio + '\'': 'null'}::date AS data_inicial,
      #{ data_fim.present? ? '\'' + data_fim + '\'': 'null'}::date AS data_fim
    ),
    numeros_cadastrados AS (
      SELECT whatsapp_numeros.*
      FROM whatsapp_numeros
      INNER JOIN parametros ON true
      RIGHT JOIN loja_itens li ON li.id = whatsapp_numeros.loja_item_id
      WHERE whatsapp_numeros.created_at::date BETWEEN parametros.data_inicial AND parametros.data_fim
        AND (
          (li.status = 'COMPRADO')
          OR (li.id IS NULL AND li.status IS NULL)
        )
    ),
    numeros_banidos AS (
      SELECT *
      FROM whatsapp_numeros
      INNER JOIN parametros ON true
      WHERE ((whatsapp_numeros.banido = true) AND (data_banimento::date BETWEEN parametros.data_inicial AND parametros.data_fim))
    )
    SELECT 
    COUNT(DISTINCT num.id) AS qtd_numero_inicial,
    (SELECT COUNT(numeros_banidos.id) FROM numeros_banidos) AS qtd_numero_banido,
    (SELECT COUNT(numeros_cadastrados.id) FROM numeros_cadastrados) AS qtd_numeros_cadastrados
    FROM whatsapp_numeros num
    LEFT JOIN loja_itens li ON li.id = num.loja_item_id
    INNER JOIN parametros ON true
    INNER JOIN campanhas camp ON camp.numero = num.numero
    INNER JOIN users ON users.id = num.user_id
    WHERE (
      (
        (parametros.data_inicial IS null)
        OR (camp.updated_at::date BETWEEN parametros.data_inicial AND parametros.data_fim)
      )
      AND (
        (li.status = 'COMPRADO')
        OR (li.id is null and li.status is null)
      )
    );"
  end

  def self.get_sql_demonstracao_solicitante(data_inicio, data_fim)
    "WITH parametros AS (
      SELECT
        #{data_inicio.present? ? '\'' + data_inicio + '\'': 'null'}::date AS data_inicial,
        #{data_fim.present? ? '\'' + data_fim + '\'': 'null'}::date AS data_fim
    )
    SELECT
      users.name,
      COUNT(agenda) AS qtd_total,
      CASE WHEN estado.sigla = 'DF' THEN 'CD' ELSE estado.sigla END AS sigla
    FROM
      users
    INNER JOIN
      parametros ON true
    INNER JOIN
      agendamentos agenda ON agenda.user_registro_id = users.id
    INNER JOIN
      clientes cliente ON cliente.id = agenda.cliente_id
    INNER JOIN
      cidades cidade ON cidade.id = cliente.cidade_id
    INNER JOIN
      estados estado ON estado.id = cidade.estado_id
    WHERE
      (
        (permissao_id IN (2, 7) OR (users.id = 99))
        AND (agenda.tipo_agendamento_id IN (3, 4))
        AND (
          parametros.data_inicial IS NULL
          OR agenda.created_at::date BETWEEN parametros.data_inicial AND parametros.data_fim
        )
      )
    GROUP BY
      users.name,
      estado.sigla
    ORDER BY
      users.name DESC;"
  end

  def self.get_sql_demonstracao_estado(data_inicio, data_fim)
    "WITH parametros AS (
      SELECT
        #{data_inicio.present? ? '\'' + data_inicio + '\'': 'null'}::date AS data_inicial,
        #{data_fim.present? ? '\'' + data_fim + '\'': 'null'}::date AS data_fim
    )
    SELECT
    CASE WHEN estado.sigla = 'DF' THEN 'CD' ELSE estado.sigla END AS sigla,
    COUNT(agenda.id) AS qtd_total
  FROM
    users
  INNER JOIN
    parametros ON true
  INNER JOIN
    agendamentos agenda ON agenda.user_registro_id = users.id
  INNER JOIN
    clientes cliente ON cliente.id = agenda.cliente_id
  INNER JOIN
    cidades cidade ON cidade.id = cliente.cidade_id
  INNER JOIN
    estados estado ON estado.id = cidade.estado_id
  WHERE
    (
      (permissao_id IN (2, 7) OR (users.id = 99))
      AND (agenda.tipo_agendamento_id IN (3, 4))
      AND (
        parametros.data_inicial IS NULL
        OR agenda.created_at::date BETWEEN parametros.data_inicial AND parametros.data_fim
      )
    )
  GROUP BY
    estado.sigla
  ORDER BY
    qtd_total DESC;"
  end
end
