class MensagemNotificacaoSerializer < ActiveModel::Serializer
  attributes :id, :destinatarios, :mensagem, :tipo, :numero, :ativo

  def numero
    object.numero_notificacao.numero if object.numero_notificacao.present?
  end
end
