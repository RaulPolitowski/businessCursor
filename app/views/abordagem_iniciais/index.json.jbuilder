json.array!(@abordagem_iniciais) do |abordagem_inicial|
  json.extract! abordagem_inicial, :id, :texto, :tipo
  json.url abordagem_inicial_url(abordagem_inicial, format: :json)
end
