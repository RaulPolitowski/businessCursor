module DashboardsPainelVendasHelper

  def self.get_fechamentos(data_inicio, data_fim, empresa, estado, vendedor, status, efetivo)
    sql =  "select tf.descricao, COALESCE(SUM(p.valor_mensalidade), 0) as total, tf.id
            from fechamentos f
            inner join status s on f.status_id = s.id
            inner join tipo_fechamentos tf on tf.id = f.tipo_fechamento_id
            LEFT JOIN propostas p on p.id = f.proposta_id "

    sql += "left join clientes cliente on cliente.id = f.cliente_id
          left join cidades cidade on cidade.id = cliente.cidade_id
          where s.fechamento is true
            and f.data_fechamento::date between '#{data_inicio}' and '#{data_fim}'
            and f.empresa_id in  (#{ ApplicationHelper.get_empresas_by_codigo(empresa) })"
    sql += "and (#{ vendedor.present? ? vendedor : 'null'} is null or f.user_id =  #{ vendedor.present? ? vendedor : 'null'})
            and (#{ estado.present? ? (ApplicationHelper.get_estado_by_codigo(estado)) : 'null'} is null or cidade.estado_id = #{ estado.present? ? (ApplicationHelper.get_estado_by_codigo(estado)) : 'null'})
            and (#{ status.present? ? status : 'null'} is null or s.id =  #{ status.present? ? status : 'null'})
          group by tf.id, tf.descricao
          order by tf.id"
    return sql
  end

  def self.get_fechamentos_by_sistemas(data_inicio, data_fim, empresa, estado, vendedor, status, efetivo)
    sql = "select coalesce(sis.nome, 'Sem proposta') as descricao, count(f.id), sis.id
              from fechamentos f
              inner join status s on f.status_id = s.id
              left join propostas p on p.id = f.proposta_id
              left join pacotes pac on pac.id = p.pacote_id
              left join sistemas sis on sis.id = pac.sistema_id
              left join clientes cliente on cliente.id = f.cliente_id
              left join cidades cidade on cidade.id = cliente.cidade_id
              where s.fechamento is true
                and f.data_fechamento::date between '#{data_inicio}' and '#{data_fim}'
                and f.empresa_id in  (#{ ApplicationHelper.get_empresas_by_codigo(empresa) }) "
    sql += "
                and (#{ vendedor.present? ? vendedor : 'null'} is null or f.user_id =  #{ vendedor.present? ? vendedor : 'null'})
                and (#{ estado.present? ? (ApplicationHelper.get_estado_by_codigo(estado)) : 'null'} is null or cidade.estado_id = #{ estado.present? ? (ApplicationHelper.get_estado_by_codigo(estado)) : 'null'})
                and (#{ status.present? ? status : 'null'} is null or s.id =  #{ status.present? ? status : 'null'})
              group by sis.id, sis.nome
              order by sis.id"
    return sql
  end

  def self.get_tipo_fechamentos(data_inicio, data_fim, empresa, estado, vendedor, status, efetivo)
    sql =  "select tf.descricao, count(f.id), tf.id
            from fechamentos f
            inner join status s on f.status_id = s.id
            inner join tipo_fechamentos tf on tf.id = f.tipo_fechamento_id "
    if efetivo == "true"
      sql += "LEFT JOIN propostas p on p.id = f.proposta_id "
    end 
      sql += "left join clientes cliente on cliente.id = f.cliente_id
            left join cidades cidade on cidade.id = cliente.cidade_id
            where s.fechamento is true
              and f.data_fechamento::date between '#{data_inicio}' and '#{data_fim}'
              and f.empresa_id in  (#{ ApplicationHelper.get_empresas_by_codigo(empresa) })"
      sql += "and (#{ vendedor.present? ? vendedor : 'null'} is null or f.user_id =  #{ vendedor.present? ? vendedor : 'null'})
              and (#{ estado.present? ? (ApplicationHelper.get_estado_by_codigo(estado)) : 'null'} is null or cidade.estado_id = #{ estado.present? ? (ApplicationHelper.get_estado_by_codigo(estado)) : 'null'})
              and (#{ status.present? ? status : 'null'} is null or s.id =  #{ status.present? ? status : 'null'})
            group by tf.id, tf.descricao
            order by tf.id"
    return sql
  end

  def self.get_valores_fechamento(data_inicio, data_fim, empresa, estado, vendedor, data_inicio_anterior, data_fim_anterior, efetivo)
    sql =  "WITH mes_anterior AS
            (SELECT sum(coalesce(p.valor_mensalidade, 0)) AS mensalidade,
                    CASE WHEN sum(coalesce(p.valor_implantacao, 0)) = 0 then
                        1 else sum(coalesce(p.valor_implantacao, 0)) end AS implantacao,
                    CASE
                        WHEN count(f.id) = 0 THEN NULL
                        ELSE count(f.id)
                    END AS quantidade
             FROM fechamentos f
             INNER JOIN status s ON f.status_id = s.id
             LEFT JOIN propostas p ON p.id = f.proposta_id
             LEFT JOIN pacotes pac ON pac.id = p.pacote_id
             LEFT JOIN sistemas sis ON sis.id = pac.sistema_id
             left join clientes cliente on cliente.id = f.cliente_id
             left join cidades cidade on cidade.id = cliente.cidade_id
             WHERE s.fechamento IS TRUE
               AND f.data_fechamento::date between '#{data_inicio_anterior}' and '#{data_fim_anterior}'
               and f.empresa_id in  (#{ ApplicationHelper.get_empresas_by_codigo(empresa) })"
      sql += "
               and (#{ vendedor.present? ? vendedor : 'null'} is null or f.user_id =  #{ vendedor.present? ? vendedor : 'null'})
               and (#{ estado.present? ? (ApplicationHelper.get_estado_by_codigo(estado)) : 'null'} is null or cidade.estado_id = #{ estado.present? ? (ApplicationHelper.get_estado_by_codigo(estado)) : 'null'})
            ),
             mes_atual AS
            ( SELECT sum(p.valor_mensalidade) AS mensalidade,
                     sum(p.valor_implantacao) AS implantacao,
                     CASE
                         WHEN count(f.id) = 0 THEN NULL
                         ELSE count(f.id)
                     END AS quantidade
             FROM fechamentos f
             INNER JOIN status s ON f.status_id = s.id
             LEFT JOIN propostas p ON p.id = f.proposta_id
             LEFT JOIN pacotes pac ON pac.id = p.pacote_id
             LEFT JOIN sistemas sis ON sis.id = pac.sistema_id
             left join clientes cliente on cliente.id = f.cliente_id
             left join cidades cidade on cidade.id = cliente.cidade_id
             WHERE s.fechamento IS TRUE
               AND f.data_fechamento::date between '#{data_inicio}' and '#{data_fim}'
               and f.empresa_id in  (#{ ApplicationHelper.get_empresas_by_codigo(empresa) })"
      sql += "
               and (#{ vendedor.present? ? vendedor : 'null'} is null or f.user_id =  #{ vendedor.present? ? vendedor : 'null'})
               and (#{ estado.present? ? (ApplicationHelper.get_estado_by_codigo(estado)) : 'null'} is null or cidade.estado_id = #{ estado.present? ? (ApplicationHelper.get_estado_by_codigo(estado)) : 'null'})
            ),
               qtd_dias AS
            ( SELECT CASE
                         WHEN count(DISTINCT data_inicio::date) = 0 THEN 1
                         ELSE count(DISTINCT data_inicio::date)
                     END AS COUNT
             FROM ligacoes
             WHERE data_inicio between '#{data_inicio}' and '#{data_fim}'
               and empresa_id in  (#{ ApplicationHelper.get_empresas_by_codigo(empresa) }) )

          SELECT mes_atual.mensalidade,
                 mes_atual.implantacao,
                 mes_atual.quantidade,
                 coalesce(mes_anterior.implantacao, 0) AS mes_anterior_implantacao,
                 coalesce(mes_anterior.mensalidade, 0) mes_anterior_mensalidade,
                 mes_anterior.quantidade AS mes_anterior_quantidade,
                 ROUND(mes_atual.mensalidade/mes_atual.quantidade, 2) media_mensalidade,
                 ROUND(mes_atual.implantacao/mes_atual.quantidade, 2) media_implantacao,
                 ROUND(mes_atual.quantidade::numeric/qtd_dias.count, 2) media_fechamento,
                 qtd_dias.count AS qtddias,
                 CASE
                     WHEN mes_anterior.mensalidade > mes_atual.mensalidade THEN coalesce(ROUND((1 - (mes_atual.mensalidade/mes_anterior.mensalidade))*100, 2), 0)
                     ELSE coalesce(ROUND(((mes_atual.mensalidade/mes_anterior.mensalidade) - 1)*100, 2), 0)
                 END AS perc_mensalidade,
                 CASE
                     WHEN mes_anterior.implantacao > mes_atual.implantacao THEN coalesce(ROUND((1 - (mes_atual.implantacao/mes_anterior.implantacao))*100, 2), 0)
                     ELSE coalesce(ROUND(((mes_atual.implantacao/mes_anterior.implantacao) - 1)*100, 2), 0)
                 END AS perc_implantacao,
                 CASE
                     WHEN mes_anterior.quantidade > mes_atual.quantidade THEN coalesce(ROUND((1 - (mes_atual.quantidade::numeric/mes_anterior.quantidade::numeric))*100, 2), 0)
                     ELSE coalesce(ROUND(((mes_atual.quantidade::numeric/mes_anterior.quantidade::numeric) - 1)*100, 2), 0)
                 END AS perc_quantidade
          FROM mes_atual
          INNER JOIN mes_anterior ON TRUE
          INNER JOIN qtd_dias ON TRUE"
  end

  def self.get_top_fechamentos(data_inicio, data_fim, empresa, estado, efetivo)
    sql =  "WITH qtd_dias AS
              ( SELECT CASE
                           WHEN count(DISTINCT data_inicio::date) = 0 THEN 1
                           ELSE count(DISTINCT data_inicio::date)
                       END AS COUNT
               FROM ligacoes
               WHERE data_inicio between '#{data_inicio}' and '#{data_fim}'
                 and empresa_id in  (#{ ApplicationHelper.get_empresas_by_codigo(empresa) }) )
            SELECT u.name AS nome,
                   count(f.id) AS qtd,
                   u.id,
                   qtd_dias.count,
                   ROUND(count(f.id)::numeric/qtd_dias.count, 2) AS media
            FROM fechamentos f
            INNER JOIN status s ON f.status_id = s.id "
            
    if efetivo == "true"
      sql += "LEFT JOIN propostas p on p.id = f.proposta_id"
    end 
      sql += "
            INNER JOIN users u ON u.id = f.user_id
            INNER JOIN qtd_dias ON TRUE
            left join clientes cliente on cliente.id = f.cliente_id
            left join cidades cidade on cidade.id = cliente.cidade_id
            WHERE s.fechamento IS TRUE
              AND f.data_fechamento::date between '#{data_inicio}' and '#{data_fim}'
              and f.empresa_id in  (#{ ApplicationHelper.get_empresas_by_codigo(empresa) }) "
    sql += "and (#{ estado.present? ? (ApplicationHelper.get_estado_by_codigo(estado)) : 'null'} is null or cidade.estado_id = #{ estado.present? ? (ApplicationHelper.get_estado_by_codigo(estado)) : 'null'})
            GROUP BY u.id,
                     u.name,
                     qtd_dias.count
            ORDER BY count(f.id) DESC"
    return sql
  end

  def self.get_top_mensalidade(data_inicio, data_fim, empresa, estado, efetivo)
    sql = "SELECT u.name AS nome,
                   sum(coalesce(p.valor_mensalidade, 0)) AS valor,
                   u.id,
                   ROUND(sum(coalesce(p.valor_mensalidade, 0))/count(f.id), 2) AS media
            FROM fechamentos f
            INNER JOIN status s ON f.status_id = s.id
            INNER JOIN users u ON u.id = f.user_id
            LEFT JOIN propostas p ON p.id = f.proposta_id
            LEFT JOIN pacotes pac ON pac.id = p.pacote_id
            LEFT JOIN sistemas sis ON sis.id = pac.sistema_id
            left join clientes cliente on cliente.id = f.cliente_id
            left join cidades cidade on cidade.id = cliente.cidade_id
            WHERE s.fechamento IS TRUE
              AND f.data_fechamento::date between '#{data_inicio}' and '#{data_fim}'"      
    sql += "  and f.empresa_id in  (#{ ApplicationHelper.get_empresas_by_codigo(empresa) })
              and (#{ estado.present? ? (ApplicationHelper.get_estado_by_codigo(estado)) : 'null'} is null or cidade.estado_id = #{ estado.present? ? (ApplicationHelper.get_estado_by_codigo(estado)) : 'null'})
            GROUP BY u.id,
                     u.name
            ORDER BY sum(coalesce(p.valor_mensalidade, 0)) DESC"
    return sql
  end

  def self.get_top_implantacao(data_inicio, data_fim, empresa, estado)
    return "SELECT u.name AS nome,
                   sum(coalesce(p.valor_implantacao, 0)) AS valor,
                   u.id,
                   ROUND(sum(coalesce(p.valor_implantacao, 0))/count(f.id), 2) AS media
            FROM fechamentos f
            INNER JOIN status s ON f.status_id = s.id
            INNER JOIN users u ON u.id = f.user_id
            LEFT JOIN propostas p ON p.id = f.proposta_id
            LEFT JOIN pacotes pac ON pac.id = p.pacote_id
            LEFT JOIN sistemas sis ON sis.id = pac.sistema_id
            left join clientes cliente on cliente.id = f.cliente_id
            left join cidades cidade on cidade.id = cliente.cidade_id
            WHERE s.fechamento IS TRUE
              AND f.data_fechamento::date between '#{data_inicio}' and '#{data_fim}'
              and f.empresa_id in  (#{ ApplicationHelper.get_empresas_by_codigo(empresa) })
              and (#{ estado.present? ? (ApplicationHelper.get_estado_by_codigo(estado)) : 'null'} is null or cidade.estado_id = #{ estado.present? ? (ApplicationHelper.get_estado_by_codigo(estado)) : 'null'})
            GROUP BY u.id,
                     u.name
            ORDER BY sum(coalesce(p.valor_implantacao, 0)) DESC"
  end

  def self.get_top_estados_vendas(data_inicio, data_fim, empresa, efetivo)
    sql = "SELECT e.sigla,
                   sum(coalesce(p.valor_mensalidade, 0)) AS valor,
                   count(f.id) AS qtd,
                   ROUND(sum(coalesce(p.valor_mensalidade, 0))/count(f.id), 2) AS media
            FROM fechamentos f
            INNER JOIN status s ON f.status_id = s.id
            INNER JOIN users u ON u.id = f.user_id
            LEFT JOIN propostas p ON p.id = f.proposta_id
            LEFT JOIN pacotes pac ON pac.id = p.pacote_id
            LEFT JOIN sistemas sis ON sis.id = pac.sistema_id
            left join clientes cliente on cliente.id = f.cliente_id
            left join cidades cidade on cidade.id = cliente.cidade_id
            left join estados e on e.id = cidade.estado_id
            WHERE s.fechamento IS TRUE
              AND f.data_fechamento::date between '#{data_inicio}' and '#{data_fim}'
              and f.empresa_id in  (#{ ApplicationHelper.get_empresas_by_codigo(empresa) }) "
                       
        sql +=    "GROUP BY e.sigla
            ORDER BY sum(coalesce(p.valor_mensalidade, 0)) DESC"
    return sql
  end

  def self.get_fechamentos_table(data_inicio, data_fim, empresa, estado, status, sistema, vendedor, efetivo)
    sql = "SELECT c.id,
                   c.cnpj,
                   c.razao_social,
                   s.id,
                   s.descricao AS status,
                   p.valor_implantacao,
                   p.valor_mensalidade,
                   sis.id,
                   sis.nome AS sistema,
                   u.name AS vendedor,
                   f.data_fechamento,
                   tf.descricao AS tipo_fechamento,
                   cidade.nome || ' - ' || estado.sigla as cidade
            FROM fechamentos f
            INNER JOIN clientes c ON c.id = f.cliente_id
            INNER JOIN status s ON f.status_id = s.id
            INNER JOIN users u ON u.id = f.user_id
            LEFT JOIN propostas p ON p.id = f.proposta_id
            LEFT JOIN pacotes pac ON pac.id = p.pacote_id
            LEFT JOIN sistemas sis ON sis.id = pac.sistema_id
            LEFT JOIN tipo_fechamentos tf ON tf.id = f.tipo_fechamento_id
            left join cidades cidade on cidade.id = c.cidade_id
            left join estados estado on estado.id = cidade.estado_id
            WHERE s.fechamento IS TRUE
              AND f.data_fechamento::date BETWEEN '#{data_inicio}' and '#{data_fim}'
              and f.empresa_id in  (#{ ApplicationHelper.get_empresas_by_codigo(empresa) }) "
              sql += "
              and (#{ status.present? ? status : 'null'} is null or s.id =  #{ status.present? ? status : 'null'})
              AND (#{ sistema.present? ? sistema : 'null'} IS NULL OR sis.id = #{ sistema.present? ? sistema : 'null'})
              and (#{ vendedor.present? ? vendedor : 'null'} is null or f.user_id =  #{ vendedor.present? ? vendedor : 'null'})
              and (#{ estado.present? ? (ApplicationHelper.get_estado_by_codigo(estado)) : 'null'} is null or cidade.estado_id = #{ estado.present? ? (ApplicationHelper.get_estado_by_codigo(estado)) : 'null'})
            ORDER BY f.data_fechamento DESC"
  end

end
