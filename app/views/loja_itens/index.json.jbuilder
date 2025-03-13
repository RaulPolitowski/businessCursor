json.array!(@loja_itens) do |loja_item|
  json.extract! loja_item, :id, :status, :numero, :user_id, :qrCode
  json.url loja_item_url(loja_item, format: :json)
end
