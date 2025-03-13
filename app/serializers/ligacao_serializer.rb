class LigacaoSerializer < ActiveModel::Serializer
  attributes :id, :cliente_id, :user_id, :data_inicio, :status_ligacao_id, :empresa_id, :usuario, :status_ligacao, :data_inicio_formatada,
             :status_cliente, :observacao, :agendamento_retorno_id, :cliente, :cnpj, :cidade, :tipo, :escritorio_id, :escritorio, :data_fim_formatada,
            :status_cliente_id

  def usuario
    object.user.name
  end

  def data_inicio_formatada
    object.data_inicio.strftime("%d/%m/%Y %H:%M")
  end

  def data_fim_formatada
    object.data_fim.strftime("%d/%m/%Y %H:%M") unless object.data_fim.nil?
  end

  def status_ligacao
    object.status_ligacao.descricao unless object.status_ligacao.nil?
  end

  def status_cliente
    object.status_cliente.descricao unless object.status_cliente.nil?
  end

  def cliente
    object.cliente.razao_social unless object.cliente.nil?
  end

  def cnpj
    object.cliente.cnpj unless object.cliente.nil?
  end

  def cidade
    if object.cliente.present?
      object.cliente.cidade.descricao_completa unless object.cliente.cidade.nil?
    else
      object.escritorio.cidade.descricao_completa unless object.escritorio.cidade.nil?
    end
  end

end
