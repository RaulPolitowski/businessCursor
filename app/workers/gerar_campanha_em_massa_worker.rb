class GerarCampanhaEmMassaWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'critical', retry: false

  def perform(params, user_ids)
    user_ids = user_ids.split(',')
    whatsapp_numeros = WhatsappNumero.sem_loja_item.where(user_id: user_ids, is_ocultado: false, status: 'CONECTADO', banido: false)
    numero_agrupado_por_usuario = whatsapp_numeros.group_by(&:user_id)
    qtd_total = params['quantidade'].to_i
    qtd_por_usuario = qtd_total / whatsapp_numeros.size
    user_ids.each_with_index do |u, index|
      params['whatsapp_numero_id'] = numero_agrupado_por_usuario[u.to_i]&.map(&:id)
      params['quantidade'] = qtd_por_usuario
      params['quantidade'] += (qtd_total % whatsapp_numeros.size) if user_ids.size - 1 == index
      GerarCampanhasWorker.perform_async(params)
      sleep rand(15..25)
    end
  end
end
