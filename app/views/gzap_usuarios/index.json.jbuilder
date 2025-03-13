json.array!(@gzap_usuarios) do |gzap_usuario|
  json.extract! gzap_usuario, :id, :destinatarios, :user_id, :name
  json.url gzap_usuario_url(gzap_usuario, format: :json)
end
