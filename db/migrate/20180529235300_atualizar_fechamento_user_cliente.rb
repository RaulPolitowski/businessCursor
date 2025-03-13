class AtualizarFechamentoUserCliente < ActiveRecord::Migration
  def change
    execute <<-SQL
      update clientes
      set data_fechamento = x.data_inicio::date, user_negociacao_id = x.user_id
      from (
      select c.id as clienteId, *
        from clientes c
            inner join ligacoes l on l.cliente_id = c.id and l.status_cliente_id in  (2, 3, 20, 27)
            where c.status_id in (2, 3, 20, 27)
            order by c.id, l.data_inicio desc) x
            where x.clienteId = clientes.id;


      update clientes
      set data_fechamento = x.data_inicio::date, user_negociacao_id = x.user_id
      from (
      select c.id as clienteId, *
        from clientes c
            inner join ligacoes l on l.cliente_id = c.id 
            where c.status_id in (2, 3, 20, 27)
              and c.data_fechamento is null
            order by c.id, l.data_inicio desc) x
            where x.clienteId = clientes.id;
    SQL
  end
end
