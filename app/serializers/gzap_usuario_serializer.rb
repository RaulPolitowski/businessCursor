class GzapUsuarioSerializer < ActiveModel::Serializer
  attributes :id, :destinatarios, :user_id, :name, :gzap_usuario_ids
end
