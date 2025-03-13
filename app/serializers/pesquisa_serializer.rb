class PesquisaSerializer < ActiveModel::Serializer
  attributes :id, :data, :data_form, :cliente, :empresa_id, :ultimo_login, :ultimo_login_form,
             :user_avaliacao_id, :data_avaliacao, :data_avaliacao_form, :avaliacao, :tempo,
             :sistema, :versao, :positivo_desc, :positivo, :data_pesquisa, :data_pesquisa_form, :tempo,
             :situacao_financeira, :com_pendencia_financeira, :bloqueado, :bloqueado_desc, :com_pendencia_financeira_desc

  belongs_to :cliente

  def data_form
    object.data.strftime("%d/%m/%Y") if object.data.present?
  end

  def ultimo_login_form
    object.ultimo_login.strftime("%d/%m/%Y %H:%M") if object.ultimo_login.present?
  end

  def data_pesquisa_form
    object.data_pesquisa.strftime("%d/%m/%Y %H:%M") if object.data_pesquisa.present?
  end

  def data_avaliacao_form
    object.data_avaliacao.strftime("%d/%m/%Y %H:%M") if object.data_avaliacao.present?
  end

  def positivo_desc
    object.positivo ? 'Sim' : 'Não'
  end

  def bloqueado_desc
    object.bloqueado ? 'Sim' : 'Não'
  end

  def com_pendencia_financeira_desc
    object.com_pendencia_financeira ? 'Sim' : 'Não'
  end
end
