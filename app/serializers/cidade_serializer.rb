class CidadeSerializer < ActiveModel::Serializer
  attributes :id, :nome, :codigo, :estado

  belongs_to :estado
end
