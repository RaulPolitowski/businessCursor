class CepImporter
  attr_reader :cep, :only_one_api

  def initialize(cep, only_one_api = false)
    @cep = cep
    @only_one_api = only_one_api
  end

  def import
    raise 'Informe o cep' if cep.blank?
    call_api_cep
  end

  def call_api_cep
    return call_awesome if only_one_api

    response = call_viacep
    response = call_opencep if response.nil?
    response = call_awesome if response.nil?
    response
  end

  def call_viacep
    puts 'API CEP | ViaCep'
    Cep::CallViacep.new(cep).call
  end

  def call_awesome
    puts 'API CEP | Awesome'
    Cep::CallAwesome.new(cep).call
  end

  def call_opencep
    puts 'API CEP | OpenCep'
    Cep::CallOpencep.new(cep).call
  end
end

