class TelefoneSerializer < ActiveModel::Serializer
  attributes :id, :telefone, :preferencial, :enviado_whats, :contato, :respondeu_whats, :msg_whats

  def msg_whats
    parametro = Parametro.find_by_empresa_id object.contato.cliente.empresa_id
    parametro.nil? || parametro.msg_whats.nil? ? '' : parametro.msg_whats
  end
end
