class CnaeClienteSerializer < ActiveModel::Serializer
  attributes :id, :cnae, :blacklist

  belongs_to :cnae

  def blacklist
    object.cnae.blacklist ? 'Sim' : 'Não'
  end
end
