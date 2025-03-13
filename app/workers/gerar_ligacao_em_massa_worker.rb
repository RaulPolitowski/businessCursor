class GerarLigacaoEmMassaWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'critical', retry: false

  def perform(ligacoes)
    ligacoes.each do |ligacao|
      numero_cliente = ligacao.keys.first
      numero_disparador = MensagemNotificacao.captacao.numero_notificacao.numero
      LigacaoEmMassa::EnviarLigacoesEmMassa.new(numero_disparador, numero_cliente.to_s, ligacao[numero_cliente]).call
      sleep rand(5..10)
    end
  end
end
