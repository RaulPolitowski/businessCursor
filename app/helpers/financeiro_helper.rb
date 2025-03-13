module FinanceiroHelper

  def self.get_contrato_ativo(cnpj, ativo)
    return "select d.*
            from contrato d
            inner join financeiro.clientefornecedorfinanceiro clifor on clifor.id = d.cliente_id
            where clifor.cpfcnpj = '#{cnpj}'
              and d.ativo is #{ativo} limit 1"
  end

  def self.get_honorario_ativo(cnpj, ativo)
    return "select d.*
            from honorariomensal d
            inner join financeiro.clientefornecedorfinanceiro clifor on clifor.id = d.clifor_id
            where clifor.cpfcnpj = '#{cnpj}'
              and d.tipo_id = 16
              and d.ativo is #{ativo} limit 1"
  end

  def self.get_honorario_gruber(client_id)
    return "select d.*
            from honorariomensal d
            where d.clifor_id = #{client_id}
              and d.tipo_id = 2
              and d.ativo is true limit 1"
  end

  def self.get_servicos_feitos(client_id)
    return "select distinct tipocobranca_id
            from debitos debito
            left join tipocobrancavalor tcv on debito.id = tcv.debito_id
            where clifor_id = #{client_id}"
  end

  def self.get_debitos_pendentes(cliente_id)
    return "select count(debito.id)
            from debitos debito
            left join boletogerado boleto on boleto.id = debito.boletogerado_id
            where debito.status = 'PENDENTE'
              and debito.clifor_id = #{cliente_id}
              and coalesce(boleto.datavencimento, debito.datavencimento) < current_date"
  end

  def self.get_debitos_financeiro(cnpj)
    return "with sql as (
              select cliente.razaosocial, debito.complemento, debito.valor,
                    coalesce(boleto.datavencimento, debito.datavencimento) as datavencimento,
                    TO_CHAR(coalesce(boleto.datavencimento, debito.datavencimento), 'DD/MM/YYYY') as vencimento,
                    debito.status
              from debitos debito
              left join boletogerado boleto on boleto.id = debito.boletogerado_id
              left join financeiro.clientefornecedorfinanceiro cliente on cliente.id = debito.clifor_id
              where cliente.cpfcnpj = '#{cnpj}'
                and debito.status in ('PAGO')
                and debito.empresa_id in (17, 3253, 3422)
                and coalesce(boleto.datavencimento, debito.datavencimento) > (current_date - interval '6 month')

              UNION ALL

              select cliente.razaosocial, debito.complemento, debito.valor,
                    coalesce(boleto.datavencimento, debito.datavencimento) as datavencimento,
                    TO_CHAR(coalesce(boleto.datavencimento, debito.datavencimento), 'DD/MM/YYYY') as vencimento,
                    'VENCIDO' as status
              from debitos debito
              left join boletogerado boleto on boleto.id = debito.boletogerado_id
              left join financeiro.clientefornecedorfinanceiro cliente on cliente.id = debito.clifor_id
              where cliente.cpfcnpj = '#{cnpj}'
                and debito.status in ('PENDENTE')
                and debito.empresa_id in (17, 3253, 3422)
                and coalesce(boleto.datavencimento, debito.datavencimento) < current_date
            )
            select *
            from sql
            order by sql.datavencimento"
  end

  def self.get_sql_clientes_ativos
    return "
          select  clifor.id,
                  clifor.cpfcnpj,
                  clifor.razaosocial,
                  sistema.nome as sistema,
                  sistema.tiposistema,
		              (municipio.nome || '-' || estado.sigla) as cidade,
		              honorario.valor as mensalidade,
                  controle.tipo as situacao
          from financeiro.controle_bloqueio_business controle
          left join financeiro.controle_bloqueio_business_clientes cliente on controle.id = cliente.controle_bloqueio_business_id
          left join honorariomensal honorario on honorario.id = cliente.honorario_id
          left join contrato on contrato.id = honorario.contrato_id
          left join sistema on sistema.id = contrato.sistema_id
          left join financeiro.clientefornecedorfinanceiro clifor on clifor.id = honorario.clifor_id
          left join municipio on municipio.id = clifor.municipio_id
          left join estado on municipio.estado_id = estado.id
          where controle.empresa_id in (17,3422,3253)
            and controle.data_controle = ((date_trunc('month', current_date) + interval '1 month') - interval '1 day')::date
            and controle.tipo in  ('BLOQUEADO', 'NORMAL')
    "
  end

  def self.get_equipe(empresa, setor_tipo, cliente_id)
    if setor_tipo.nil?
      return ""
    end
    if (setor_tipo.eql? "CONTABIL") && empresa.present?
      return "select equipecontabil.*
              from controlecontabil
              inner join equipecontabil on equipecontabil.id = controlecontabil.equipe_id
              where cliente_id =#{empresa.id}"
    elsif (setor_tipo.eql? "EXTERNO") && cliente_id.present?
      return "select funcionario.*
              from preferenciafinanceira pref
              inner join preferenciafinanceiracliente cli on cli.preferencia_id = pref.id
              inner join funcionario on funcionario.id = cli.funcionario_id
              where empresa_id in(42, 1706)
                and clientefornecedor_id = #{cliente_id}
              order by empresa_id limit 1"
    else
      return ""
    end
  end

  def self.get_all_setores(cpfcnpj, cliente_id)
    return "
          with equiperh as (
          select equiperh.*
          from empresa
          inner join controlerh on controlerh.cliente_id = empresa.id
          inner join equiperh on equiperh.id = controlerh.equipe_id
          where empresa.cnpj = '#{cpfcnpj}'
          limit 1
            ),
          equipecontabil as(
          select equipecontabil.*
          from empresa
          inner join controlecontabil on controlecontabil.cliente_id = empresa.id
          inner join equipecontabil on equipecontabil.id = controlecontabil.equipe_id
          where empresa.cnpj = '#{cpfcnpj}'
          limit 1
            ),
          atendimento as(
          select funcionario.*
          from preferenciafinanceira pref
          inner join preferenciafinanceiracliente cli on cli.preferencia_id = pref.id
          left join funcionario on funcionario.id = cli.funcionario_id
          where empresa_id in(42, 1706)
            and clientefornecedor_id = #{cliente_id}
            order by empresa_id limit 1
          )
          select 	equiperh.id as rh_id, coalesce(equiperh.nome, 'Sem informações') as rh_nome,
              equipecontabil.id as contabil_id, coalesce(equipecontabil.nome, 'Sem informações') as contabil_nome,
              atendimento.id as atendimento_id, coalesce(atendimento.nome, 'Sem informações') as atendimento_nome
          from (select true) x
          left join equiperh on true
          left join equipecontabil on true
          left join atendimento on true
      "
  end

end
