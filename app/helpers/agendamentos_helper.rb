module AgendamentosHelper

  def self.get_sql_agendamentos_nao_confirmados(periodo, data_comentario, empresa, usuario)

    return " select agendamento.id,
                    TO_CHAR(agendamento.data_inicio, 'DD/MM/YYYY HH24:MI') as data,
                    agendamento.data_inicio,
                    agendamento.data_fim,
                    tipo.descricao,
                    cliente.razao_social,
                    agendamento.contato,
                    agendamento.telefone,
          	usuario.name
            from agendamentos agendamento
            left join clientes cliente on cliente.id = agendamento.cliente_id
            left join tipo_agendamentos tipo on tipo.id = agendamento.tipo_agendamento_id
            left join comentarios comentario on comentario.id = (select max(id) from comentarios where agendamento_id = agendamento.id)
            left join users usuario on usuario.id = agendamento.user_id
            #{ periodo == '1' ? "where agendamento.data_inicio > date_trunc('day', now()) + interval '12 hours'" :
                               "where agendamento.data_inicio < date_trunc('day', now()) + interval '36 hours'" }
            #{ periodo == '1' ? " and agendamento.data_inicio::date = current_date" :
                   "and agendamento.data_inicio::date = current_date + interval '1 day'" }
              and agendamento.confirmado is false
              and (comentario is null or comentario.created_at < '#{data_comentario}'::timestamp)
              and agendamento.empresa_id = #{empresa}
              and agendamento.ativo is true
              and agendamento.aviso_nao_confirmado is false
              and coalesce(agendamento.user_registro_id, agendamento.user_id) = #{usuario}
            order by agendamento.data_inicio limit 1
      "
  end

end
