class NumeroNotificacaoSerializer < ActiveModel::Serializer
  attributes :id, :numero, :nome, :banido, :qrcode, :status
end
