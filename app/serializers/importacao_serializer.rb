class ImportacaoSerializer < ActiveModel::Serializer
  attributes :id, :data_importacao, :total, :empresas_boas, :importado, :nao_importado, :ja_existente, :sigla

  def data_importacao
    object.data_importacao.strftime("%d/%m/%Y")
  end

  def empresas_boas
    object.empresas_boas
  end

  def sigla
    object.estado.sigla
  end

end
