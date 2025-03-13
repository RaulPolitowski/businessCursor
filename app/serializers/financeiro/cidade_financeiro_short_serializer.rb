class Financeiro::CidadeFinanceiroShortSerializer < ActiveModel::Serializer
  attributes :id, :nome


  def nome
    object.descricao_completa
  end
end
