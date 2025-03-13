class FechamentoSerializer < ActiveModel::Serializer
  attributes :id, :data_fechamento, :user, :vendedor_nome

  belongs_to :tipo_fechamento
  belongs_to :user
  belongs_to :status
  belongs_to :empresa
  belongs_to :proposta

  def data_fechamento
    object.data_fechamento.strftime("%d/%m/%Y %H:%M")
  end

  def vendedor_nome
    object.user.present? ? object.user.name : ''
  end
end
