class ImplantacaoSerializer < ActiveModel::Serializer
  attributes :id, :status, :data_inicio, :data_fim, :cliente, :proposta, :pausada, :agenda, :vendedor

  has_one :cliente, :serializer => ClienteImplantacaoSerializer
  has_one :proposta, :serializer => PropostaImplantacaoSerializer
  has_one :user

  def agenda
    object.agenda.present? ? object.agenda.data_inicio.strftime("%d/%m/%Y %H:%M:%S") : 'Sem agenda'
  end

  def vendedor
    object.cliente.fechamento.user.name unless object.cliente.nil? || object.cliente.fechamento.nil? || object.cliente.fechamento.user.nil?
  end
end
