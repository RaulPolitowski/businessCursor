class AcompanhamentoSerializer < ActiveModel::Serializer
  attributes :id, :data_inicio, :data_fim, :status, :pausada, :observacao, :retorno,
             :dias_sem_uso, :implantacao_id

  has_one :cliente, :serializer => ClienteImplantacaoSerializer
  has_one :user
  has_one :proposta, :serializer => PropostaImplantacaoSerializer

  def data_inicio
      object.data_inicio.present? ? object.data_inicio.strftime("%d/%m/%Y %H:%M") : ''
  end

  def data_fim
    object.data_fim.present? ? object.data_fim.strftime("%d/%m/%Y %H:%M") : ''
  end

  def retorno
    object.retorno
  end

  def dias_sem_uso
    object.dias_sem_uso
  end

  def implantacao_id
    Implantacao.select(:id).where(cliente_id: object.cliente.id).first
  end
end
