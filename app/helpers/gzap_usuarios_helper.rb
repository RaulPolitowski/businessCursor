module GzapUsuariosHelper
  def select_users_from_gzap(form)
    select_options = {
      include_blank: false,
      class: 'form-control input-sm chosen-select',
      data: { placeholder: 'Selecione um usuário' }
    }

    users = GzapUsuario.get_numero_interesse

    users_collection = users.collect { |p| [p['name'], p['_id']] }
    html_div = form.select(:user_id, options_for_select(
      users_collection,
      form.object.user_id
    ), {}, select_options)

    html_div
  end
end
