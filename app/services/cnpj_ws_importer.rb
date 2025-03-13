class CnpjWsImporter
  attr_reader :cnpj

  def initialize(cnpj)
    @cnpj = cnpj
  end

  def import
    raise 'Informe o cep' if @cnpj.blank? || @cnpj.nil?
    response = call_cnpj_ws
    response
  end

  def call_cnpj_ws
    Api::GetConsumer.call ENV["cnpj_ws"] % cnpj, { x_api_token: "Bearer #{ENV["token_cnpj_ws"]}" }, timeout: 120
  end
end