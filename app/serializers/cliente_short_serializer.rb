class ClienteShortSerializer < ActiveModel::Serializer
  attributes :id, :razao_social, :cnpj, :cnae, :cidade

  def cnae
    object.cnae.codigo unless object.cnae.nil?
  end

  def cidade
    object.cidade.nome + ' - ' + object.cidade.estado.sigla  unless object.cidade.nil?
  end
end
