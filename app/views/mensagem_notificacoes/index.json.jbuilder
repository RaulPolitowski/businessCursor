json.array!(@mensagem_notificacoes) do |mensagem_notificacao|
  json.extract! mensagem_notificacao, :id, :destinatarios, :whatsapp_numero_id, :mensagem, :tipo
  json.url mensagem_notificacao_url(mensagem_notificacao, format: :json)
end
