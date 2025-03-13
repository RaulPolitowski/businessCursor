module ApplicationHelper

  def is_active_controller(controller_name, class_name = nil)
    if params[:controller] == controller_name
      class_name == nil ? "active" : class_name
    else
      nil
    end
  end

  def self.get_job(numero_fila, empresa_id)
    return nil if numero_fila.nil?
    # Desativo, pois fila de SP esta praticamente igual ao dos outros estados
    # if empresa_id.eql? 2
    #   return 1 if [1,2,3,4,5,6].include? numero_fila
    #   return 2 if 20.eql? numero_fila
    #   return 3 if 30.eql? numero_fila
    #   return 5 if [50,60,61].include? numero_fila
    # end
    return numero_fila
  end

  def get_codigo_empresa(empresa)
    return [1,20] if [1,2,3,4,7,8,9,13,14,15,16,17,18,19,21,22,23,24,25,26,27,28,29,30,31,32,33].include? empresa #GRUPO PR

    # Juntando SP com restante
    # return 2 if [2].include? empresa # GRUPO SP

    return 5 if [5].include? empresa # GRUPO ESCRITORIOS
    return 11 if [11].include? empresa # PRO VENDAS
    return [1, 20] if [20].include? empresa #CENTRO DE DIST
  end

  def self.get_empresas_by_codigo(codigo)
    begin
      array = codigo.split(',')
      empresa = ''
      empresa += '1,2,3,4,7,8,9,13,14,15,16,17,18,19,21,22,23,24,25,26,27,28,29,30,31,32,33,' if (array.include? '1') || (array.include? '17') ||
                                                                                              (array.include? '3253') || (array.include? '2') ||
                                                                                              (array.include? '3422')

      # Juntando SP com restante
      # empresa += '1,3,4,7,8,9,13,14,15,16,17,18,19,' if (array.include? '1') || (array.include? '17') || (array.include? '3253')
      # empresa += '2,' if (array.include? '2') || (array.include? '3422')

      empresa += '5,' if (array.include? '5') || (array.include? '5')
      empresa += '11,' if (array.include? '11')
      empresa += '20,' if (array.include? '20')
      if empresa.blank?
        return '1'
      else
        return empresa[0..-2]
      end
    rescue
      return '1'
    end
  end


  def self.get_estado_by_codigo(estado_id)
    return 1	if estado_id == '41' #PR
    return 2	if estado_id == '35' #SP
    return 3	if estado_id == '50' #MS
    return 4	if estado_id == '29' #BA
    return 5	if estado_id == '31' #MG
    return 7	if estado_id == '17' #TO
    return 8	if estado_id == '11' #RO
    return 9	if estado_id == '12' #AC
    return 10	if estado_id == '13' #AM
    return 11	if estado_id == '14' #RR
    return 12	if estado_id == '15' #PA
    return 13	if estado_id == '16' #AP
    return 14	if estado_id == '21' #MA
    return 15	if estado_id == '22' #PI
    return 16	if estado_id == '23' #CE
    return 17	if estado_id == '24' #RN
    return 18	if estado_id == '25' #PB
    return 19	if estado_id == '27' #AL
    return 20	if estado_id == '28' #SE
    return 21	if estado_id == '26' #PE
    return 22 if estado_id == '32' #ES
    return 23	if estado_id == '33' #RJ
    return 24	if estado_id == '42' #SC
    return 25	if estado_id == '43' #RS
    return 26	if estado_id == '51' #MT
    return 27	if estado_id == '52' #GO
    return 28	if estado_id == '53' #DF
    return 99 if estado_id.present? && estado_id != "undefined"
    return 'null'
  end

  def is_active_action(action_name)
    params[:action] == action_name ? "active" : nil
  end

  def human_date(date)
    return date.strftime("%d/%m/%Y") unless date.nil?
  end

  def human_datetime(date)
    return date.strftime("%d/%m/%Y %H:%M:%S") unless date.nil?
  end

  def human_boolean(boolean)
    return boolean ? 'Sim' : 'Não'
  end

  def human_boolean_positivo(boolean)
    return boolean ? 'Positivo' : 'Negativo'
  end

  def self.human_boolean_con(boolean)
    return boolean ? 'Sim' : 'Não'
  end

  def custom_bootstrap_flash
    flash_messages = []
    flash.each do |type, message|
      type = 'success' if type == 'notice'
      type = 'error'   if type == 'alert'
      text = "<script>toastr.#{type}('#{message}');</script>"
      flash_messages << text.html_safe if message
    end
    flash_messages.join("\n").html_safe
  end

  def human_currency(value)
    return number_to_currency(value, :format => "%u %n", :separator => ",", :delimiter => ".")
  end

  def self.true?(obj)
    obj.to_s == "true" || obj.to_s == "t"
  end

  def cor_implantacao proposta
    return '' if proposta.nil? || proposta.pacote.nil?
    return 'warning-element' if proposta.pacote.sistema_id == 1
    return 'danger-element' if proposta.pacote.sistema_id == 3
    return 'info-element' if proposta.pacote.sistema_id == 2
    return 'success-element' if proposta.pacote.sistema_id == 4
  end

  def self.human_telefone(value)
    return "(#{ value[0..1] }) #{ value[2..6] }-#{ value[7..15] }" if value.size == 11
    return "(#{ value[0..1] }) #{ value[2..5] }-#{ value[6..15] }" if value.size == 10
    return value
  end

  def options_from_collection_for_select_with_attributes(collection, value_method, text_method, attr_name, attr_field, selected = nil)
    options = collection.map do |element|
      [element.send(text_method), element.send(value_method), attr_name => element.send(attr_field)]
    end

    selected, disabled = extract_selected_and_disabled(selected)
    select_deselect = {}
    select_deselect[:selected] = extract_values_from_collection(collection, value_method, selected)
    select_deselect[:disabled] = extract_values_from_collection(collection, value_method, disabled)

    options_for_select(options, select_deselect)
  end

  # Utilizado na renderização do comentário
  def render_comment(trackable)
    # pega o texto do comentário (que vem em forma de trackable)
    html = trackable.comentario

    # Transforma os anchors
    # Esse regex não ignora os parênteses no fim de uma url. Ex tarefa 20
    html = html.gsub( %r{http[s]*://[^\s)<]+} ) do |url|
      if url[/(?:png|jpe?g|gif|svg)$/]
        "<img src='#{url}' />"
      else
        "<a href='#{url}'>#{url}</a>" #link_to url, url
      end
    end

    content_tag :div, simple_format(html)
  end

  def human_status_acompanhamento(status)
    case status
      when '0'
        'Aguardando acompanhamento'
      when '1'
        'Em andamento'
      when '2'
        'Stand by'
      when '3'
        'Desistente - Stand By'
      when '4'
        'Desistente - Durante acompanhamento'
      when '5'
        'Acompanhamento concluído'
      else
        ""
    end
  end

  def human_status_implantacao(status)
    case status
      when '0'
        'Agendado'
      when '1'
        'Reagendado'
      when '2'
        'Aguardando terceiros'
      when '3'
        'Em processo de instalação'
      when '4'
        'Aguardando treinamento'
      when '5'
        'Em processo de treinamento'
      when '6'
        'Aguardando terceiros'
      when '7'
        'Desistente - Pré instalação'
      when '8'
        'Desistente - Durante implantação'
      when '9'
        'Implantação concluída'
      when '10'
        'Limbo'
      else
        ""
    end
  end

  def human_tipo_solicitacao_banco(tipo)
    case tipo
      when 1
        'Novo banco de dados'
      when 2
        'Agrupamento de bancos'
      when 3
        'Agrupamento de bancos com migração'
      else
        ""
    end
  end

  def human_local_banco(tipo)
    case tipo
      when 1
        'Local'
      when 2
        'Em nuvem'
      else
        ""
    end
  end

  def self.mascara_cnpj(value)
    return "#{ value[0..1] }.#{ value[2..4] }.#{ value[5..7] }/#{ value[8..11] }-#{ value[12..13] }"
  end

  def mes_extenso (mes)
    case mes
      when 1
        'Janeiro'
      when 2
        'Fevereiro'
      when 3
        'Março'
      when 4
        'Abril'
      when 5
        'Maio'
      when 6
        'Junho'
      when 7
        'Julho'
      when 8
        'Agosto'
      when 9
        'Setembro'
      when 10
        'Outubro'
      when 11
        'Novembro'
      when 12
        'Dezembro'
    end
  end
end
