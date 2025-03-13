class Cep::CallOpencep
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
    Api::GetConsumer.call ENV["opencep"] % [cep], nil
  end

  def extract_cep_values_from_response(response)
    return {
      cep: response['cep'],
      estado_sigla: response['uf'],
      estado: get_estado_nome(response['uf']),
      bairro: response['bairro'],
      cidade: response['localidade'],
      logradouro: response['logradouro'],
      ibge: response['ibge'],
      service: 'opencep'
    }
  end

  def get_estado_nome(sigla)
    Estado.find_by_sigla(sigla).nome
  end
end
