module SolicitacaoDesistenciaExternoHelper

  def self.get_cliente_financeiro_ativo(cnpj)
        "select cliente.*, municipio.nome as cidade, sigla, (municipio.nome || '/' || estado.sigla) as cidade_uf, 
                  case when contrato.cliforparceiro_id is null then '' else parceiro.razaosocial end as parceiro,
                  case when contrato.empresa_id = 17 then 'German Tech Matriz' when contrato.empresa_id = 3253 then 'German Tech Filial' else 'German Serviços' end as local,
                  honorario.valor as valor_mensalidade, sistema.nome as sistema,
                  (CURRENT_DATE - honorario.datainicial) as dias_cliente, honorario.situacao as situacao
        from financeiro.clientefornecedorfinanceiro cliente
        inner join municipio on municipio.id = cliente.municipio_id
        inner join estado on estado.id = estado_id
        inner join contrato on contrato.cliente_id = cliente.id and contrato.ativo is true
        inner join sistema on sistema.id = contrato.sistema_id
        inner join honorariomensal honorario on honorario.clifor_id = cliente.id and honorario.tipo_id = 16 and honorario.ativo is true
        left join financeiro.clientefornecedorfinanceiro parceiro on parceiro.id = contrato.cliforparceiro_id
        where cliente.cpfcnpj='#{cnpj}'"
  end

  def self.get_cliente_financeiro(cnpj)
    "
    with dados as (
      select cliente.*, municipio.nome as cidade, sigla, (municipio.nome || '/' || estado.sigla) as cidade_uf, 
                  case when contrato.cliforparceiro_id is null then '' else parceiro.razaosocial end as parceiro,
                  case when contrato.empresa_id = 17 then 'German Tech Matriz' when contrato.empresa_id = 3253 then 'German Tech Filial' else 'German Serviços' end as local,
                  sistema.nome as sistema
        from financeiro.clientefornecedorfinanceiro cliente
        inner join municipio on municipio.id = cliente.municipio_id
        inner join estado on estado.id = estado_id
        inner join contrato on contrato.cliente_id = cliente.id
        inner join sistema on sistema.id = contrato.sistema_id
        left join financeiro.clientefornecedorfinanceiro parceiro on parceiro.id = contrato.cliforparceiro_id
        where cliente.cpfcnpj='#{cnpj}'
    ),
    last_honorario as (
      select max(honorariomensal.id) as max_honorario
      from dados
      inner join honorariomensal on honorariomensal.clifor_id = dados.id and honorariomensal.tipo_id = 16
      
    )
    select dados.*, honorario.valor as valor_mensalidade, (CURRENT_DATE - honorario.datainicial) as dias_cliente, honorario.situacao as situacao
    from dados
    inner join last_honorario on true
    inner join honorariomensal honorario on honorario.id = last_honorario.max_honorario
    "
end

end
