class CampanhaEnvioSerializer < ActiveModel::Serializer
  attributes :id, :numero, :cliente_razao_social, :message, :resposta_automatica_message, :intervalo_resposta_automatica, :palavra_chave_resposta, :mensagem_notificacao, :destinatarios

  def cliente_razao_social
    object.cliente.razao_social unless object.cliente.nil?
  end

  def destinatarios
    msg = MensagemNotificacao.where(tipo: 'INTERESSE', ativo: true).first
    msg&.gzap_usuarios&.pluck(:user_id, :destinatarios)
  end
end
