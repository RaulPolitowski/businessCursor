class GerarCampanhasWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'critical', retry: false

  def perform(parametros)
    numeros = WhatsappNumero.where id: [parametros['whatsapp_numero_id']]

    numeros.each do |numero|
      campanha = Importacao.create_campanha(
        parametros['empresa_id'],
        parametros['numero_job'],
        parametros['quantidade'],
        0,
        numero.numero,
        parametros['tempo_espera'],
        parametros['agendado_at'],
        parametros['tempo_total'],
        parametros['tipo_disparo'],
        parametros['is_resposta_automatica'],
        parametros['tempo_ocultacao'],
        parametros['abordagem_inicial_especifica'],
        parametros['abordagem_resposta_especifica'],
        parametros['palavra_chave_especifica']
      )
      campanha.enviar_campanha_para_gzap
      sleep rand(15..25)
    end
  end
end