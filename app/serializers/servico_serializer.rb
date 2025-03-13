class ServicoSerializer < ActiveModel::Serializer
  attributes :id, :nome_servico, :ordem, :tipocobranca_id
end
