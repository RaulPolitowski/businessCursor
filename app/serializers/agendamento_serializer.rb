class AgendamentoSerializer < ActiveModel::Serializer
  attributes :id, :data_inicio, :data_fim, :user_id, :titulo, :observacao, :tipo_agendamento_id,
             :user_name, :color, :tipo_agendamento, :cliente_razao_social, :cliente_id, :empresa,
             :telefone, :responsavel, :user_registro, :responsavel2, :telefone2, :implantacao_id,
             :vendedor, :sistema, :tipo_fechamento, :vendedor_id, :empresa_id, :ativo,
             :data_fechamento, :motivo, :user_cancelamento, :data_cancelamento, :confirmado,
             :usuario_confirmacao, :data_confirmacao, :cidade,
             :telefone_preferencial,:telefone_preferencial2,
             :telefone_whats,:telefone_whats2, :negociador_id, :negociacao_id


  def user_name
    object.user.name unless object.user.nil?
  end

  def cliente_razao_social
    object.cliente.razao_social unless object.cliente.nil?
  end

  def color
    object.tipo_agendamento.cor
  end

  def tipo_agendamento
    object.tipo_agendamento.descricao
  end

  def empresa
    object.empresa.razao_social
  end

  def responsavel
    if object.contato.present?
      object.contato
    else
      object.cliente.contatos.first.nil? ? "" : object.cliente.contatos.first.nome unless object.cliente.nil? || object.cliente.contatos.first.nil?
    end
  end

  def responsavel2
    if object.responsavel2.present?
      object.responsavel2
    else
      object.cliente.contatos.second.nil? ? "" : object.cliente.contatos.second.nome unless object.cliente.nil? || object.cliente.contatos.second.nil?
    end
  end

  def telefone
    object.telefone ||= object.cliente.telefone unless object.cliente.nil?
  end

  def telefone2
    object.telefone2 ||= object.cliente.telefone2 unless object.cliente.nil?
  end

  def user_registro
    object.user_registro.name unless object.user_registro.nil?
  end

  def vendedor
    object.cliente.fechamento.user.name unless object.cliente.nil? || object.cliente.fechamento.nil?
  end

  def vendedor_id
    object.cliente.fechamento.user.id unless object.cliente.nil? || object.cliente.fechamento.nil?
  end

  def sistema
    object.cliente.fechamento.proposta.pacote.sistema.nome unless object.cliente.nil? || object.cliente.fechamento.nil? || object.cliente.fechamento.proposta.nil? || object.cliente.fechamento.proposta.pacote.nil?
  end

  def tipo_fechamento
    object.cliente.fechamento.tipo_fechamento.descricao unless object.cliente.nil? || object.cliente.fechamento.nil? || object.cliente.fechamento.tipo_fechamento.nil?
  end

  def data_fechamento
    object.cliente.fechamento.data_fechamento.strftime("%d/%m/%Y %H:%M") unless object.cliente.nil? || object.cliente.fechamento.nil?
  end

  def data_cancelamento
    object.data_cancelamento.strftime("%d/%m/%Y %H:%M") unless object.data_cancelamento.nil?
  end

  def user_cancelamento
    object.user_cancelamento.name unless object.user_cancelamento.nil?
  end

  def usuario_confirmacao
    object.user_confirmacao.name unless object.user_confirmacao.nil?
  end

  def data_confirmacao
    object.data_confirmacao.strftime("%d/%m/%Y %H:%M") unless object.data_confirmacao.nil?
  end

  def cidade
    object.cliente.cidade.descricao_completa unless object.cliente.cidade.nil?
  end

  def negociador_id
    object.cliente.negociacao.user.id unless object.cliente.nil? || object.cliente.negociacao.nil?
  end

  def negociacao_id
    object.cliente.negociacao.id unless object.cliente.nil? || object.cliente.negociacao.nil?
  end

end
