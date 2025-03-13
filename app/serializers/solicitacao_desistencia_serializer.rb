class SolicitacaoDesistenciaSerializer < ActiveModel::Serializer
  attributes :id, :status, :data_solicitacao, :motivo_desistencia, :solicitante, :telefone, :motivo_solicitacao
  has_one :cliente
  has_one :empresa
  has_one :user
end
