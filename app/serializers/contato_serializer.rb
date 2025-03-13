class ContatoSerializer < ActiveModel::Serializer
  attributes :id, :nome, :cpf, :telefones, :celulares, :enviado_whats

  def telefones
    object.telefones.where(tipo: 0).order('preferencial desc, enviado_whats desc')
  end

  def celulares
    object.telefones.where(tipo: 1).order('preferencial desc, enviado_whats desc')
  end

  def enviado_whats
    object.telefones.where(tipo: 1, enviado_whats: true).order('respondeu_whats desc')
  end
end
