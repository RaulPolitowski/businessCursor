class Api::GetConsumer < Api::ApiBase

  def self.call(url, headers, timeout: 30)
    new(url, headers, nil, :get, timeout).process
  end

end