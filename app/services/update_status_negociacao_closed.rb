class UpdateStatusNegociacaoClosed
  attr_reader :ligacao, :cliente, :negociador_id, :status_empresa, :user

  def initialize(ligacao, cliente, negociador_id, user = nil)
    @ligacao = ligacao
    @cliente = cliente
    @negociador_id = negociador_id
    @status_empresa = ligacao.status_cliente&.status_empresa
    @user = user.class.eql?(String) ? User.find(user) : user
  end

  def call
    return if without_content?

    negociacao = CreateNegociacao.new(ligacao, cliente, negociador_id, user).call
    return unless negociacao

    case status_empresa
    when 2
      update_status_fechado(negociacao)
    when 5
      update_status_em_andamento(negociacao)
    when 3
      cancelar_negociacao(negociacao)
    end
  end

  private

  def without_content?
    ligacao.status_cliente.blank? || status_empresa == 4
  end

  def update_status_fechado(negociacao)
    negociacao.update(status_id: cliente.status_id)
    return unless negociacao.data_fim.present?

    negociacao.update(
      data_fim: ligacao.data_fim,
      status: 0,
      user_id: negociador_id || user.id,
      obs: ligacao.observacao
    )
  end

  def update_status_em_andamento(negociacao)
    negociacao.update(
      data_fim: ligacao.data_fim,
      status: 1,
      user: user,
      status_id: nil
    )
  end

  def cancelar_negociacao(negociacao)
    negociacao.update(
      data_fim: ligacao.data_fim,
      status: 2,
      user: user,
      obs: ligacao.observacao
    )
    negociacao.create_activity(:cancelado, owner: user, recipient: negociacao, params: { motivo: ligacao.observacao })
  end
end