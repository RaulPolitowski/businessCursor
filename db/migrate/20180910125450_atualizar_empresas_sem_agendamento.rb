class AtualizarEmpresasSemAgendamento < ActiveRecord::Migration
  def change
    execute <<-SQL
      insert into agendamento_retornos (ligacao_id, user_id, data_agendamento_retorno, created_at, updated_at, empresa_id, cancelado, cliente_id)
      select lig.id, coalesce(clientes.user_negociacao_id, lig.user_id), now() + interval '24 hours', current_date, current_date, clientes.empresa_id, false, clientes.id
      from clientes
      left join agendamento_retornos age on age.cliente_id = clientes.id and cancelado is false and data_efetuado_retorno is null
      left join ligacoes lig on lig.id = (select id from ligacoes where cliente_id = clientes.id order by id desc limit 1)
      where status_id in (28, 6, 7,29,30)
        and age.id is null;

    SQL
  end
end
