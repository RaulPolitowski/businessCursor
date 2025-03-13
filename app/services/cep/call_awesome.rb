class Cep::CallAwesome
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
    Api::GetConsumer.call ENV["awesome"] % [cep], nil
  end

  def extract_cep_values_from_response(response)
    return {
      cep: format_cep(response['cep']),
      estado_sigla: response['state'],
      estado: get_estado_nome(response['state']),
      bairro: response['district'],
      cidade: response['city'],
      logradouro: response['address'],
      ibge: response['city_ibge'],
      service: 'awesome'
    }
  end

  def get_estado_nome(sigla)
    Estado.find_by_sigla(sigla).nome
  end

  def format_cep(cep_desformatado)
    cep_desformatado.insert(5, '-')
  end
end
