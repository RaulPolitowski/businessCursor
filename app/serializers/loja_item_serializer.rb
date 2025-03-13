class LojaItemSerializer < ActiveModel::Serializer
  attributes :id, :status, :numero, :qrCode, :apelido, :created_at
  has_one :user
end
