class ClienteImplantacaoSerializer < ActiveModel::Serializer
  attributes  :id, :cnpj, :razao_social, :email, :fechamento

  has_one :fechamento

end
