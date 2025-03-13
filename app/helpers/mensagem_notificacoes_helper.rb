module MensagemNotificacoesHelper
  def select_numero(form, mensagem_notificacao)
    numeros = NumeroNotificacao.where(banido: false, status: :CONECTADO)
    numeros_collection = numeros.collect { |p| [p.numero_nome, p.id] }
    html_div = form.select(:numero_notificacao_id, options_for_select(
      numeros_collection,
      mensagem_notificacao.numero_notificacao_id
    ), {}, include_blank: false, class: 'form-control input-sm chosen-select', data: { placeholder: 'Selecione um Número' })

    html_div
  end

  def select_usuario_gzap(form)
    users = GzapUsuario.where ativo: true
    users_collection = users.collect { |p| [p['name'], p['id']] }
    select_html = form.select(:gzap_usuario_ids, options_for_select(
      users_collection,
      form.object.gzap_usuario_ids
    ), {}, { class: "form-control input-sm chosen-select", data: { placeholder: 'Selecione uma usuario gzap' }, include_blank: true, multiple: true })
    select_html
  end

  def get_eachs_from_gzap_usuario(usuarios, coluna)
    usuarios.map { |u| u.send coluna }.join(' | ')
  end
end