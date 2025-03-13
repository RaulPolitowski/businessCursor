class PropostaImplantacaoSerializer < ActiveModel::Serializer
  attributes :id, :sistema

  def sistema
    object.pacote.sistema.nome unless object.pacote.sistema.nil?
  end

end
