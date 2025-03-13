class Cep::CallViacep
  attr_reader :cep

  def initialize(cep)
    @cep = cep
  end

  def call
    raise 'Informe o cep' if cep.blank?

    response = call_request
    return if response.nil?

    extract_cep_values_from_response(response)
  end

  private

  def call_request
    Api::GetConsumer.call ENV["viacep"] % [cep], nil
  end

  def extract_cep_values_from_response(response)
    return {
      cep: response['cep'],
      estado_sigla: response['uf'],
      estado: response['estado'],
      bairro: response['bairro'],
      cidade: response['localidade'],
      logradouro: response['logradouro'],
      ibge: response['ibge'],
      service: 'viacep'
    }
  end
end
