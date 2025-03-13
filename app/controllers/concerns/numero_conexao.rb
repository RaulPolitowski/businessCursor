module NumeroConexao
  extend ActiveSupport::Concern

  def conectar_numero_gzap(numero)
      response = WhatsappBotService.new(numero: numero).connect
      render json: response, status: 200
    rescue Exception => e
      error = JSON.parse(e.response)
      render json: error, status: 422
  end

  def desconectar_numero_gzap(numero)
    response = WhatsappBotService.new(numero: numero).disconnect
    response["msg"] = "Número #{response["numero"]} foi desconectado!"
    response
  rescue Exception => e
    error = JSON.parse(e.response)
    render json: error, status: 422
  end

  def procurar_qrcode(numero)
      response = WhatsappBotService.new(numero: numero).qrcode
      response
    rescue Exception => e
      error = JSON.parse(e.response)
      render json: error, status: 422
  end

end