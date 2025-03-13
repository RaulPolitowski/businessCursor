class LigacaoEmMassa::EnviarLigacoesEmMassa
  attr_reader :ligacoes, :numero_disparador, :numero_cliente

  def initialize(numero_disparador, numero_cliente, clientes)
    @numero_disparador = numero_disparador
    @numero_cliente = numero_cliente
    @ligacoes = clientes
  end

  def call
    enviar_gzap
  end

  private

  def enviar_gzap
    payload = {
      ligacoes: ligacoes,
      numeroDisparador: numero_disparador,
      numeroCliente: numero_cliente
    }
    WhatsappBotService.new(payload: payload).enviar_ligacoes_em_massa
  end
end