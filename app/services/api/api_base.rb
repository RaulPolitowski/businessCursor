class Api::ApiBase
  require 'rest-client'

  attr_reader :url, :headers, :data, :metodo, :timeout

  def initialize(url, headers, data, metodo, timeout)
    @headers = headers
    @url = url
    @data = data
    @metodo = metodo
    @timeout = timeout
  end

  def process
    response = RestClient::Request.execute(method: metodo, headers: headers, url: url, payload: data, :timeout => timeout, :open_timeout => timeout, :read_timeout => timeout)
    JSON.parse(response)
  rescue Exception => e
    puts e
    nil
  end

end