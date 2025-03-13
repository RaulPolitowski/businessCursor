class Financeiro::ClienteFinanceiroShortSerializer < ActiveModel::Serializer
  attributes :id, :razaosocial, :cpfcnpj
end
