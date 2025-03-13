class Campanha < ActiveRecord::Base
  belongs_to :empresa
  belongs_to :whatsapp_numero

  has_many :campanha_envios

  def self.new_campanha(qtd_total, empresa_id, job, tipo, numero_telefone, tempo_espera, agendado_at, tempo_total, tipo_disparo, is_resposta_automatica, is_abordagem_inicial_especifica, is_abordagem_resposta_especifica)
    camp = new(
      qtd_total: qtd_total,
      empresa_id: empresa_id,
      job: job,
      qtd_enviado: 0,
      qtd_erros: 0,
      qtd_ignorado: 0,
      tipo: tipo,
      status: 'CADASTRO',
      numero: numero_telefone,
      tempo_espera: tempo_espera,
      agendado_at: agendado_at,
      tempo_total: tempo_total,
      tipo_disparo: tipo_disparo,
      is_resposta_automatica: is_resposta_automatica,
      is_abordagem_inicial_especifica: is_abordagem_inicial_especifica,
      is_abordagem_resposta_especifica: is_abordagem_resposta_especifica
    )
    camp.save!
    camp
  end

  def self.texto_anagruber
    return "Oi, tudo bem?"
    #return "Olá! Meu nome é *Ana Gruber* e quero te convidar para conhecer meu Podcast, o Talk Land. Lá você verá convidados incríveis falando sobre negócios, viagens, culinária, família, positividade e muito mais!%0a%0aAdicione meu contato e me siga!%0a%0aSerá uma alegria ter você comigo!%0a%0a*Todas as semanas teremos sorteios para os inscritos.*%0a%0a*Se inscreva clicando no link abaixo e lembre de ativar o sininho!*%0a%0a*YouTube:*%0a%0ahttps://www.youtube.com/channel/UCpiJHlfdahNvjc6oO1Z64wg %0a%0aTe espero lá!!"
  end

  def whatsapp_numero
    WhatsappNumero.find_by_numero numero
  end

  def self.qtd_disparo
    User.joins(:whatsapp_numeros).distinct(:name)
      .joins("left join loja_itens li on li.numero = whatsapp_numeros.numero")
      .where(whatsapp_numeros: { banido: false, status: 'CONECTADO', is_ocultado: false })
      .where("li.status = 'COMPRADO' or (li.id IS NUll AND li.status IS NULL)")
  end

  def enviar_campanha_para_gzap
    begin
      WhatsappBotService.new(payload: ActiveModel::SerializableResource.new(self, each_serializer: CampanhaSerializer).to_json).create_campanha
      update(status: 'ENVIADA')
    rescue Exception => e
      update(status: 'NAO ENVIADA')
    end
  end

  def nome_whatsapp
    whatsapp_numero.present? ? whatsapp_numero.nome : ''
  end
end