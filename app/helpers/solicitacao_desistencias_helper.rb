module SolicitacaoDesistenciasHelper

    def self.get_debitos_pagos(cnpj)
        "
        with dados as (	
            select cliente.id as cliente_id, datapagamento, trunc(desconto,2) as desconto, trunc(juro,2) as juro, trunc(total,2) as total, debito.valor, coalesce(debitospagos.multa, 0.00) as multa,
                    complemento, debito.empresa_id as empresa_id,
                    TO_CHAR(datapagamento, 'DD/MM/YYYY') as data_baixa
                from financeiro.clientefornecedorfinanceiro cliente
                left join debitos debito on debito.clifor_id= cliente.id
                inner join debito_debitospagos d_pago on d_pago.debito_id = debito.id
                left join debitospagos on debitospagos.id = d_pago.debitopago_id
                where cliente.cpfcnpj='#{cnpj}'
                and status = 'PAGO'        
        ),
        last_honorario as (
              select max(honorariomensal.id) as max_honorario
              from dados
              inner join honorariomensal on honorariomensal.clifor_id = dados.cliente_id and honorariomensal.tipo_id = 16      
        )
        select dados.*
        from dados
        inner join last_honorario on true
        inner join honorariomensal honorario on honorario.id = last_honorario.max_honorario
        where dados.empresa_id = honorario.empresa_id
        order by datapagamento desc
                
        "
    end

    def self.get_debitos_pendentes(cnpj)
        "
        with dados as (
            select cliente.id as cliente_id, datavencimento, saldo, trunc(coalesce(juro,0.00),2) as juro, debito.valor, coalesce(debitospagos.multa, 0.00) as multa, trunc(total,2) as total, 
                case when (CURRENT_DATE - datavencimento) <0 then 0 else (CURRENT_DATE - datavencimento) end as dias_vencido, complemento,
                TO_CHAR(datavencimento, 'DD/MM/YYYY') as data_vencimento, status, debito.empresa_id as empresa_id
            from financeiro.clientefornecedorfinanceiro cliente
            left join debitos debito on debito.clifor_id= cliente.id
            left join debito_debitospagos d_pago on d_pago.debito_id = debito.id
            left join debitospagos on debitospagos.id = d_pago.debitopago_id
            where cliente.cpfcnpj='#{cnpj}'
            and status not in ('PAGO', 'EXCLUIDO', 'PARCIALMENTE_PAGO')
        ),
        last_honorario as (
                select max(honorariomensal.id) as max_honorario
                from dados
                inner join honorariomensal on honorariomensal.clifor_id = dados.cliente_id and honorariomensal.tipo_id = 16      
        )
        select dados.*
        from dados
        inner join last_honorario on true
        inner join honorariomensal honorario on honorario.id = last_honorario.max_honorario
        where dados.empresa_id = honorario.empresa_id
        order by datavencimento
		
        "
    end
end
