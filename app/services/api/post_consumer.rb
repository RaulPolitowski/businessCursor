class Api::PostConsumer < Api::ApiBase

  def self.call(url, headers, payload, timeout: 30)
    new(url, headers, payload, :post, timeout).process
  end

end