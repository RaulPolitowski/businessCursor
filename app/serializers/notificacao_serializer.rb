class NotificacaoSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :user_registro_id, :data_hora, :empresa_id, :observacao, :tipo, :lido, :visualizada,
             :modelo_id, :data_hora_formatada, :usuario, :title, :path, :empresa, :cidade, :tipo_fechamento

  def usuario
    object.user.name
  end

  def data_hora_formatada
    object.data_hora.strftime("%d/%m/%Y %H:%M")
  end

  def cidade
    if object.tipo.eql? 'FECHAMENTO'
      begin
        cliente = Cliente.find object.modelo_id

        return "#{cliente.cidade.nome.upcase }-#{cliente.cidade.estado.sigla}"
      rescue
        return ''
      end
    end
    if object.tipo.eql? 'EFETIVACAO'
      begin
        acompanhamento = Acompanhamento.find object.modelo_id

        return "#{acompanhamento.cliente.cidade.nome.upcase }-#{acompanhamento.cliente.cidade.estado.sigla}"
      rescue
        return ''
      end
    end
    if object.tipo.eql? 'DESATIVACAO'
      begin
        acompanhamento = Acompanhamento.find object.modelo_id

        return "#{acompanhamento.cliente.cidade.nome.upcase }-#{acompanhamento.cliente.cidade.estado.sigla}"
      rescue
        return ''
      end
    end

    if object.tipo.eql? 'SOLICITACAO_DESATIVACAO'
      begin
        desistencias = SolicitacaoDesistencia.find object.modelo_id

        return "#{desistencias.cliente.cidade.nome.upcase }-#{desistencias.cliente.cidade.estado.sigla}"
      rescue
        return ''
      end
    end

    if object.tipo.eql? 'IMPLANTACAO'
      begin
        implantacao = Implantacao.find object.modelo_id

        return "#{implantacao.cliente.cidade.nome.upcase }-#{implantacao.cliente.cidade.estado.sigla}"
      rescue
        return ''
      end
    end
    if object.tipo.eql? 'AGENDA_CANCELADA'
      begin
        agenda = Agendamento.find object.modelo_id

        return "#{agenda.cliente.cidade.nome.upcase }-#{agenda.cliente.cidade.estado.sigla}"
      rescue
        return ''
      end
    end
  end

end
