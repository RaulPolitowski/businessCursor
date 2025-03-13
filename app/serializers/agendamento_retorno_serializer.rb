class AgendamentoRetornoSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :data_agendamento_retorno, :data_criacao_formatada,
             :data_retorno_formatada, :user_id, :user_name, :razao_social_cliente,
             :ligacao_id, :cliente_id, :empresa, :status_descricao, :observacao

  def empresa
    object.cliente.empresa.razao_social unless object.cliente.nil?
  end

  def data_retorno_formatada
    object.data_agendamento_retorno.strftime("%d/%m/%Y %H:%M") #strftime("%d/%m/%Y - %H:%M")
  end

  def data_criacao_formatada
    object.created_at.strftime("%d/%m/%Y %H:%M") #strftime("%d/%m/%Y - %H:%M")
  end

  def razao_social_cliente
    object.cliente.razao_social unless object.cliente.nil?
  end

  def user_name
    object.user.name unless object.user.nil?
  end

  def status_descricao
    object.ligacao.cliente.status.descricao unless object.ligacao.nil? || object.ligacao.cliente.nil? || object.ligacao.cliente.status.nil?
  end

  def observacao
    object.ligacao.observacao unless object.ligacao.nil?
  end

end
