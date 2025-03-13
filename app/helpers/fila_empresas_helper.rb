module FilaEmpresasHelper

  def self.get_top_cnaes(empresa_id, limit)
      " select cnaes.id, cnaes.descricao, count(fechamentos.id) AS qtd_vendas
            from fechamentos
            inner join clientes on clientes.id = fechamentos.cliente_id
            inner join cnaes on cnaes.id = clientes.cnae_id
            where fechamentos.empresa_id = #{empresa_id}
            and blacklist IS false
            group by cnaes.id, cnaes.descricao
            order by count(fechamentos.id) desc limit #{limit}
      "
  end

  def self.get_qtd_vendas_cnae_ano(cnae_id)
    " SELECT COUNT(fechamento.id) AS qtd_vendas
      FROM fechamentos fechamento
      INNER JOIN clientes cliente ON cliente.id = fechamento.cliente_id
      WHERE
        cliente.cnae_id = #{cnae_id}
        AND fechamento.data_fechamento BETWEEN CURRENT_DATE - INTERVAL '1 year' AND CURRENT_DATE
      GROUP BY cliente.cnae_id
    "
  end
end
