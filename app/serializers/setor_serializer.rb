class SetorSerializer < ActiveModel::Serializer
  attributes :id, :nome_setor, :ordem, :setor_financeiro_id, :tipo_setor
end
