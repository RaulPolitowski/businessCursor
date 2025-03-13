class CampanhaSerializer < ActiveModel::Serializer
  attributes :id, :numero, :qtd_total, :tempo_espera, :webhook_disparo, :webhook_campanha, :agendado_at, :tempo_total, :tipo_disparo, :is_resposta_automatica, :is_pausada

  has_many :campanha_envios

  def webhook_disparo
    "#{ENV['business']}/campanhas/disparo_efetuado"
  end

  def webhook_campanha
    "#{ENV['business']}/campanhas/finalizar_campanha"
  end
end
