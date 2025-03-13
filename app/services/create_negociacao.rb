class CreateNegociacao
  attr_reader :ligacao, :cliente, :negociador_id, :current_user

  def initialize(ligacao, cliente, negociador_id, current_user)
    @ligacao = ligacao
    @cliente = cliente
    @negociador_id = negociador_id
    @current_user = current_user
  end

  def call
    return cliente.negociacao if cliente.negociacao.present?

    negociacao = create_negociacao

    create_activity(negociacao) if negociador_id.present? && negociador_id != current_user.id

    negociacao
  end

  private

  def create_negociacao
    Negociacao.create(
      data_inicio: ligacao.data_inicio,
      user_id: (negociador_id.present? ? negociador_id : current_user.id),
      prospectador_id: current_user.id,
      status: 0,
      cliente: cliente,
      empresa_id: cliente.empresa_id,
      atendimento_telefone: atendimento_telefone?,
      atendimento_whatsapp: atendimento_whatsapp?
    )
  end

  def create_activity(negociacao)
    negociacao.create_activity(
      :prospectador,
      owner: current_user,
      recipient: negociacao,
      params: { negociador_id: negociador_id }
    )
  end

  def atendimento_telefone?
    (cliente.telefone_preferencial? && !cliente.telefone_enviado_whats?) ||
    (cliente.telefone2_preferencial? && !cliente.telefone2_enviado_whats?)
  end

  def atendimento_whatsapp?
    cliente.telefone_enviado_whats? || cliente.telefone2_enviado_whats?
  end
end
