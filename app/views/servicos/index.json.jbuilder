json.array!(@servicos) do |servico|
  json.extract! servico, :id, :nome_servico, :ordem
  json.url servico_url(servico, format: :json)
end
