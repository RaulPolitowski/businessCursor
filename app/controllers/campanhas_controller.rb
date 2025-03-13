class CampanhasController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!, only: [:finalizar_campanha, :disparo_efetuado]
  before_action :authenticate_user!, only: [:index, :by_status, :analise_dados, :create, :atualizar_campanhas, :transferir_campanha]

  def index
    @standby = WhatsappNumero.where(is_ocultado: false).distinct
      .includes(:user, :loja_item)
      .joins("left join campanhas on campanhas.numero = whatsapp_numeros.numero and campanhas.status in ('ANDAMENTO', 'ENVIADA', 'NAO ENVIADA') ")
      .joins("left join loja_itens li on li.numero = whatsapp_numeros.numero")
      .where(status: 'CONECTADO', banido: false)
      .where(' campanhas.id is null ')
      .where("li.status = 'COMPRADO' or (li.id IS NUll AND li.status IS NULL)")

    @numeros_ocultos = WhatsappNumero.includes(:user, :loja_item).where(is_ocultado: true).distinct.joins("left join campanhas on campanhas.numero = whatsapp_numeros.numero and campanhas.status in ('ANDAMENTO', 'ENVIADA', 'NAO ENVIADA') ").where(banido: false).where(' campanhas.id is null ')
    @numeros_desconectados = WhatsappNumero.includes(:user, :loja_item).where(status: 'DESCONECTADO', banido: false)
    @abordagens_ativas_resposta = AbordagemInicial.get_abordagens_tipo('RESPOSTA')
  end

  def by_status
    connection = ActiveRecord::Base.connection
    case params[:tipo]
    when 'ANDAMENTO'
      response = connection.select_all CampanhasHelper.get_sql_andamento params[:job], params[:telefone_id], params[:usuario_id], params[:estado_id], nil
    when 'AGUARDANDO'
      response = connection.select_all CampanhasHelper.get_sql_aguardando params[:job], params[:telefone_id], params[:usuario_id], params[:estado_id]
    when 'FINALIZADAS'
      response = connection.select_all CampanhasHelper.get_sql_finalizadas params[:data_inicio], params[:data_fim], params[:job], params[:telefone_id], params[:usuario_id], params[:estado_id], nil
    when 'ANDAMENTO_AGUARDANDO'
      numero = WhatsappNumero.find(params[:numero_id])
      andamento = connection.select_all CampanhasHelper.get_sql_andamento nil, nil, nil, nil, numero.numero
      aguardando = connection.select_all CampanhasHelper.get_sql_aguardando nil, params[:numero_id], nil, nil
      response = aguardando.as_json + andamento.as_json
    when 'FINALIZADAS_ANDAMENTO'
      numero = WhatsappNumero.find(params[:numero_id])
      created_at = [created_at: numero.created_at]

      finalizadas = connection.select_all CampanhasHelper.get_sql_finalizadas params[:data_inicio], params[:data_fim], nil, nil, nil, nil, numero.numero
      andamento = connection.select_all CampanhasHelper.get_sql_andamento nil, nil, nil, nil, numero.numero
      response = finalizadas.as_json + andamento.as_json + created_at.as_json
    end

    render json: response, status: 200
  rescue
    render json: {error: 'Ocorreu um erro'}, status: 500
  end

  def create
    numeros = WhatsappNumero.where id: [params[:whatsapp_numero_id].split(',')] if params[:whatsapp_numero_id]
    if params[:tipo].eql? 'CAPTACAO'
      params[:whatsapp_numero_id] = params[:whatsapp_numero_id].split(',')
      params[:is_resposta_automatica] = params[:is_resposta_automatica].present? ? params[:is_resposta_automatica] : false
      GerarCampanhasWorker.perform_async(campanha_params)
      return head :created
    elsif params[:tipo].eql? 'ANAGRUBER'
      texto = Campanha.texto_anagruber
      filas = FilaEmpresa.where(empresa_id: params[:empresa_id], numero_fila: params[:numero_job]).order('id').limit(params[:quantidade])
      clientes = filas.map{ |fila| fila.cliente }
      campanha = Importacao.create_campanha_personalizada(clientes, numeros.numero, texto, 'ANAGRUBER', true, params[:tempo_espera], params[:numero_job], params[:empresa_id])
    elsif params[:tipo].eql? 'CAPTACAO_MASSA'
      GerarCampanhaEmMassaWorker.perform_async(params, params[:user_ids])
      return head :created
    else
      texto = params[:abordagem_texto]
      filas = FilaEmpresa.where(empresa_id: params[:empresa_id], numero_fila: params[:numero_job]).order('id').limit(params[:quantidade])
      clientes = filas.map{ |fila| fila.cliente }
      campanha = Importacao.create_campanha_personalizada(clientes, numeros.numero, texto, params[:tipo], true, params[:tempo_espera], params[:numero_job], params[:empresa_id])
    end

    campanha.enviar_campanha_para_gzap
    head 201
  end

  def reenviar_campanha
    begin
      campanha = Campanha.find(params[:campanha_id])
      campanhaGzap = WhatsappBotService.new(campanha_id: params[:campanha_id]).get_campanha
      if campanhaGzap.blank?
        if (campanha)
          WhatsappBotService.new(payload: ActiveModel::SerializableResource.new(campanha, each_serializer: CampanhaSerializer).to_json).create_campanha
          campanha.update!(status: 'ENVIADA')
          render json: {success: 'Campanha Reenviada'}, status: 201
        else
          render json: {error: 'Campanha não encontrada'}, status: 200
        end
      elsif campanhaGzap['campanha']['isFinalizada']
        render json: {error: 'A campanha já foi finalizada'}, status: 404
      else
        campanha.update!(status: 'ANDAMENTO')
        render json: {error: 'Campanha já existente, movido para andamento'}, status: 200
      end
    rescue Exception => e
      campanha.update!(status: 'NAO ENVIADA')
    end
  end

  def transferir_campanha
    campanha = Campanha.find params[:id]
    numero = WhatsappNumero.find params[:numero_whatsapp_id]
    return render json: {error: 'Informe número da campanha e whatsapp'}, status: 500 if campanha.nil? || numero.nil?
    WhatsappBotService.new(numero: numero, campanha_id: campanha.id).transfer_campanha

    campanha.update!(numero: numero.numero)

    render json: campanha, status: 200
  end

  def finalizar_campanha
    WhatsappBotService.new(campanha_id: params[:id]).atualizar_campanha

    render json: {}.to_json, status: 202
  end

  def pausar
    campanha = Campanha.find params[:id]
    return render json: { error: 'Informe a campanha' }, status: 500 if campanha.nil?

    ActiveRecord::Base.transaction do
      begin
        WhatsappBotService.new(
          payload: {
            pause: params[:pause]
          },
          campanha_id: campanha.id
        ).pausar_campanha
        campanha.update!(is_pausada: params[:pause])
      rescue => exception
        raise ActiveRecord::Rollback
      end
    end
    render json: campanha, status: 200
  end

  def pausar_todas
    return render json: { error: 'Informe a ação a ser executada(PAUSE ou DESPAUSE)' }, status: 500 if params[:pause].nil?
    ActiveRecord::Base.transaction do
      begin
        Campanha.where(status: 'ANDAMENTO').update_all(is_pausada: params[:pause] == 'true')

        WhatsappBotService.new(
          payload: {
            pause: params[:pause]
          }
        ).pausar_campanhas
      rescue => exception
        render json: {}, status: 404
        raise ActiveRecord::Rollback
      end
    end
    render json: {}, status: 200
  end

  def parar
    campanha = Campanha.find params[:id]
    return render json: { error: 'Informe a campanha' }, status: 500 if campanha.nil?

    ActiveRecord::Base.transaction do
      begin
        WhatsappBotService.new(campanha_id: campanha.id).parar_campanha
        campanha.update!(status: 'FINALIZADO')
      rescue => exception
        raise ActiveRecord::Rollback
      end
    end
    render json: campanha, status: 200
  end

  def parar_todas
    ActiveRecord::Base.transaction do
      begin
        Campanha.where(status: 'ANDAMENTO').update_all(status: 'FINALIZADO')

        WhatsappBotService.new.parar_campanhas
      rescue => exception
        render json: {}, status: 404
        raise ActiveRecord::Rollback
      end
    end

    render json: {}, status: 200
  end

  def disparo_efetuado
    disparo = CampanhaEnvio.find params[:id]

    if disparo.campanha.status.eql? 'ENVIADA'
      disparo.campanha.update(status: 'ANDAMENTO')
    end

    disparo.update!(status: params[:isFalhaEnvio] == true ? 'ERROR' : 'ENVIADO')

    render json: {}.to_json, status: 202
  end

  def analise_dados
    connection = ActiveRecord::Base.connection

    case params[:tipo]
    when "TOTALIZADOR_ESTADO"
      response = connection.select_all CampanhasHelper.get_sql_totalizadores_estado params[:data_inicio], params[:data_fim]
    when "TOTALIZADOR_USUARIO"
      response = connection.select_all CampanhasHelper.get_sql_totalizadores_usuario params[:data_inicio], params[:data_fim]
    when "INFO_NUMEROS"
      response = connection.select_all CampanhasHelper.get_sql_info_numeros params[:data_inicio], params[:data_fim]
    when "DEMONSTRACAO_SOLICITANTE"
      response = connection.select_all CampanhasHelper.get_sql_demonstracao_solicitante params[:data_inicio], params[:data_fim]
    when "DEMONSTRACAO_ESTADO"
      response = connection.select_all CampanhasHelper.get_sql_demonstracao_estado params[:data_inicio], params[:data_fim]
    end

    render json: response, status: 200
  end

  def simples_nacional
    connection = ActiveRecord::Base.connection

    case params[:tipo]
    when "JOB0"
      response = connection.select_all DashboardsHelper.get_total_empresas_ligadas_job0 params[:data_inicio]
    end

    render json: response, status: 200
  end

  def numeros_ativos_usuario
    connection = ActiveRecord::Base.connection
    response = connection.select_all DashboardsHelper.get_total_numeros_ativos
    render json: response, status: 200
  end

  def previsao_termino
    render json: { Erro: 'Campanha não encontrada' }, status: 404 unless params[:id]

    connection = ActiveRecord::Base.connection

    response = connection.select_all CampanhasHelper.get_sql_previsao_termino params[:id]
    render json: response, status: 200
  end

  def atualizar_campanhas
    WhatsappBotService.new.atualizar_campanhas
  end

  def campanha_params
    params.permit(:empresa_id, :numero_job, :quantidade, :tempo_espera, :agendado_at, :tempo_total, :tipo_disparo, :is_resposta_automatica, :tempo_ocultacao, :abordagem_inicial_especifica, :abordagem_resposta_especifica, :palavra_chave_especifica, :whatsapp_numero_id, whatsapp_numero_id: [])
  end
end
