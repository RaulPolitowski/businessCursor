class Acompanhamento < ActiveRecord::Base
  include PublicActivity::Model
  require 'rest-client'
  require 'digest'

  belongs_to :cliente
  belongs_to :empresa
  belongs_to :user
  belongs_to :proposta
  has_many :agendamento_retornos

  def sistema
    proposta.nil? || proposta.pacote.nil? ? '' : proposta.pacote.sistema.nome
  end

  def retorno
    agendamento_retornos.where(cancelado: false, data_efetuado_retorno: nil).order(data_agendamento_retorno: :asc).first
  end

  def dias_sem_uso
    response = RestClient::Request.execute(method: :get,  url: "http://api.gtech.site/companies/#{cliente.cnpj}",
                                           headers: { Accept: 'application/vnd.germantech.v2',
                                                      Authorization: Digest::MD5.hexdigest(Time.new.strftime('%Y11586637000128%m%-d')) },
                                           timeout: 300, open_timeout: 300, read_timeout: 300)
    resposta = JSON.parse(response)

    return 'Sem Info.' unless resposta['last_login'].present?

    ((Time.current - Time.parse(resposta['last_login'])).round / 1.day).to_i
  rescue StandardError
    'Sem Info.'
  end

  def em_andamento?
    [1].include? status
  end

  def is_stand_by?
    [2].include? status
  end

  def aguardando?
    [0].include? status
  end

  def desistente?
    [3, 4].include? status
  end

  def finalizado?
    [5].include? status
  end

  def self.update_or_create(attributes)
    assign_or_new(attributes).save
  end

  def self.assign_or_new(attributes)
    obj = first || new
    obj.assign_attributes(attributes)
    obj
  end
end
