class ContratoSerializer < ActiveModel::Serializer
  attributes :id, :nome, :descricao, :texto
end
