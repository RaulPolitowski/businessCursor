class WhatsappBotService
  CONNECT_URL = ENV['bot_whatsapp_url'] + '/numero/startworker?numero=%s&nome=%s&instanciaId=%s&tokenChatPro=%s&isNotificacao=%s&webhook=%s'
  QRCODE_URL = ENV['bot_whatsapp_url'] + '/numero/qrcode?numero=%s'
  DISCONNECT_URL = ENV['bot_whatsapp_url'] + '/numero/destroy/%s'
  TRANSFER_URL = ENV['bot_whatsapp_url'] + '/campanha/transferir?id=%s&numero=%s'
  CAMPANHA_URL = ENV['bot_whatsapp_url'] + '/campanha/'
  GET_CAMPANHA_URL = ENV['bot_whatsapp_url'] + '/campanha/dados/%s'
  GET_SALDO_CHATPRO_URL = ENV['bot_whatsapp_url'] + '/numero/getSaldoChatPro/'
  RESPOSTA_AUTOMATICA_URL = ENV['bot_whatsapp_url'] + '/config/updateMessage/'
  WEBHOOK_DISCONNECT = ENV['business'] + '/whatsapp_numeros/desconectar_numero'
  NOTIFY_WHATSAPP_URL = ENV['bot_whatsapp_url'] + '/conexao/sendMessage'
  GET_NUMEROS_URL = ENV['bot_whatsapp_url'] + '/usuario/getUsersWithNumber'
  UPDATE_IS_NOTIFICADOR_URL = ENV['bot_whatsapp_url'] + '/usuario/updateIsNotificador'
  PAUSAR_CAMPANHA_URL = ENV['bot_whatsapp_url'] + '/campanha/pausar?id=%s&pause=%s'
  PAUSAR_TODAS_CAMPANHA_URL = ENV['bot_whatsapp_url'] + '/campanha/pausar_todas?pause=%s'
  PARAR_CAMPANHA_URL = ENV['bot_whatsapp_url'] + '/campanha/parar?id=%s'
  PARAR_TODAS_CAMPANHA_URL = ENV['bot_whatsapp_url'] + '/campanha/parar_todas'
  ENVIAR_LIGACOES_EM_MASSA = ENV['bot_whatsapp_url'] + '/conexao/sendListaCaptacao'

  attr_reader :numero, :payload, :campanha_id

  def initialize(numero: nil, payload: nil, campanha_id: nil)
    @numero = numero
    @payload = payload
    @campanha_id = campanha_id
  end

  def connect
    raise 'Informe o numero' if numero.nil?

    call(CONNECT_URL % [
      numero[:numero],
      numero[:nome],
      numero[:chat_pro] ? numero[:instancia_id] : '',
      numero[:chat_pro] ? numero[:token_chat_pro] : '',
      numero[:isNotificacao] || false,
      WEBHOOK_DISCONNECT
    ])
  end

  def qrcode
    raise 'Informe o numero' if numero.nil?

    call(QRCODE_URL % [ numero.numero ])
  end

  def create_campanha
    raise 'Informe os dados da campanha' if payload.nil?

    call_post(CAMPANHA_URL)
  end

  def get_campanha
    raise 'Informe o id da campanha' if campanha_id.nil?

    call(GET_CAMPANHA_URL % campanha_id)
  end

  def disconnect
    raise 'Informe o numero' if numero.nil?

    call(DISCONNECT_URL % [numero.numero])
  end

  def transfer_campanha
    raise 'Informe o id da campanha' if campanha_id.nil?
    raise 'Informe o numero' if numero.nil?

    call(TRANSFER_URL % [campanha_id, numero.numero])
  end

  def atualizar_resposta_automatica
    raise 'Informe o numero' if payload.nil?

    call_post(RESPOSTA_AUTOMATICA_URL)
  end

  def update_number_status(numeros, is_loja_item = false)
    numeros.each do |numero|
      response = WhatsappBotService.new(numero: numero).qrcode
      numero.update!(status: (response['isAutenticado'] ? 'CONECTADO' : response['isConectado'] ? 'QRCODE' : 'DESCONECTADO')) if !response.nil?

      loja_item = LojaItem.where.not(status: :COMPRADO).find_by(numero: numero.numero)
      loja_item.update!(status: response['isAutenticado'] ? 'DISPONIVEL' : 'INDISPONIVEL') if !loja_item.nil? && !response.nil?
    end
  end
 
  def atualizar_campanhas
    campanhas = Campanha.where("status in ('ENVIADA', 'ANDAMENTO', 'NAO ENVIADA')")
    campanhas.each do |campanha|

      if campanha.status.eql? 'NAO ENVIADA'
        WhatsappBotService.new(payload: ActiveModel::SerializableResource.new(campanha, each_serializer: CampanhaSerializer).to_json).create_campanha
        next
      end
      response = WhatsappBotService.new(campanha_id: campanha.id).get_campanha

      if response['campanha']['isFinalizada']
        campanha.update(qtd_enviado: response['campanha']['disparosEnviados'], qtd_erros: response['campanha']['disparosErro'].present? ? response['campanha']['disparosErro'] : 0, status: 'FINALIZADO')
      end

      campanha.update!(status: 'ANDAMENTO') if response['campanha']['isAndamento'] && !response['campanha']['isFinalizada']

      processar_disparos(response['disparos'], campanha)
    end
  end

  def atualizar_campanha
    campanha = Campanha.find campanha_id
    response = WhatsappBotService.new(campanha_id: campanha.id).get_campanha

    if response['campanha']['isFinalizada']
      campanha.update(qtd_enviado: response['campanha']['disparosEnviados'], qtd_erros: response['campanha']['disparosErro'].present? ? response['campanha']['disparosErro'] : 0, status: 'FINALIZADO')
      whatsapp_usuario = WhatsappNumero.find_by(numero: response['campanha']['numero'])
      whatsapp_usuario.update!(is_ocultado: true, data_inicio_ocultacao: DateTime.now()) if (whatsapp_usuario.tempo_ocultacao)
    end

    campanha.update(status: 'ANDAMENTO') if response['campanha']['isAndamento'] && !response['campanha']['isFinalizada']

    processar_disparos(response['disparos'], campanha)
  end

  def processar_disparos(disparos, campanha)
    disparos.each do |disparo|
      next unless disparo['isDisparado']

      campanha_envio = campanha.campanha_envios.where(numero: disparo['numero']).first
      campanha_envio.update!(status: (disparo['isFalhaEnvio'] ? 'ERROR' : 'ENVIADO')) if campanha_envio.status.eql? 'AGUARDANDO'
    end
  end

  def notify_whatsapp
    raise 'Informe o numero' if numero.nil?

    call_post(NOTIFY_WHATSAPP_URL)
  end

  def search_numbers
    call(GET_NUMEROS_URL)
  end

  def activate_user
    call_post(UPDATE_IS_NOTIFICADOR_URL)
  end

  def pausar_campanha
    raise 'Informe o id da campanha' if campanha_id.nil?
    raise 'Informe o tipo' if payload.nil?

    call(PAUSAR_CAMPANHA_URL % [campanha_id, payload[:pause]])
  end

  def pausar_campanhas
    raise 'Informe o a ação a ser executada' if payload.nil?

    call(PAUSAR_TODAS_CAMPANHA_URL % [payload[:pause]])
  end

  def parar_campanha
    raise 'Informe o id da campanha' if campanha_id.nil?

    call(PARAR_CAMPANHA_URL % [campanha_id])
  end

  def parar_campanhas
    call(PARAR_TODAS_CAMPANHA_URL)
  end

  def enviar_ligacoes_em_massa
    call_post(ENVIAR_LIGACOES_EM_MASSA % [payload])
  end

  def call(url)
    Api::GetConsumer.call url, nil
  end

  def call_post(url)
    Api::PostConsumer.call url, {cache_control: "no-cache", content_type: "application/json"}, payload
  end
end