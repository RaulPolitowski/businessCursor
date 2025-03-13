class ReceitawsContaSerializer < ActiveModel::Serializer
  attributes :id, :nome, :chave, :qtd_disponivel, :qtd_usada, :dia_renovacao
end
