json.array!(@numero_notificacoes) do |numero_notificacao|
  json.extract! numero_notificacao, :id, :numero, :nome, :banido, :qrcode, :status
  json.url numero_notificacao_url(numero_notificacao, format: :json)
end
