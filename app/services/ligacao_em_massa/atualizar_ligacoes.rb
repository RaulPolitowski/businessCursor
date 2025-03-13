class LigacaoEmMassa::AtualizarLigacoes
  attr_reader :clientes, :ultimas_ligacoes, :observacao, :user_id

  def initialize(obs, user_id, cliente_ids)
    @clientes = Cliente.where(id: cliente_ids)
    @ultimas_ligacoes = Cliente.where(id: cliente_ids).includes(:ligacoes).map do |cliente|
      ultima_ligacao = cliente.ligacoes.order(data_fim: :desc).first
      ultima_ligacao
    end
    @observacao = obs || 'ENVIADO WHATSAPP'
    @user_id = user_id
  end

  def call
    update_cliente
    update_ultima_ligacao
  end

  private

  def update_cliente
    clientes.update_all(status_id: 31, user_atendimento_id: nil, numero_fila: nil, status_empresa: 2)
  end

  def update_ultima_ligacao
    ligacoes_id = []
    ultimas_ligacoes.each { |ligacao| ligacoes_id << ligacao[:id] }
    Ligacao.where(id: ligacoes_id).update_all(data_fim: Time.now, observacao: observacao, status_cliente_id: 31)
    ultimas_ligacoes.each { |ligacao| update_negociacao(ligacao) }
  end

  def update_negociacao(ligacao)
    UpdateStatusNegociacaoClosed.new(ligacao, ligacao.cliente, user_id, user_id).call
  end
end