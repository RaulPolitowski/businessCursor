class NaoPerturbeRetornoSerializer < ActiveModel::Serializer
  attributes :id, :data_fim
  has_one :user
end
