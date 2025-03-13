class LigacaoEmMassa::CriarLigacao
  def initialize(cliente_id, user)
    @cliente_id = cliente_id
    @user = user
  end

  def call
    create
  end

  def create
    ligacao = Ligacao.new(cliente_id: @cliente_id)

    ligacao.update(
      user_id: @user,
      data_inicio: Time.now,
      empresa: ligacao.cliente.empresa,
      is_captacao_coletiva: true,
      tipo: 0
    )

    if ligacao.agendamento_retorno_id.nil?
      retorno = AgendamentoRetorno.where(
        cliente: ligacao.cliente,
        data_efetuado_retorno: nil,
        cancelado: false
      ).first
      ligacao.agendamento_retorno = retorno if retorno.present?
    end

    ligacao
  end
end
