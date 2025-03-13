class CnaeSerializer < ActiveModel::Serializer
  attributes  :id, :codigo, :descricao, :preferencial, :blacklist

  def blacklist
    object.blacklist ? 'Sim' : 'Não'
  end
end
