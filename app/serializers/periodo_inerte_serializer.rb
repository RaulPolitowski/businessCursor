class PeriodoInerteSerializer < ActiveModel::Serializer
  attributes :id, :avaliacao, :data, :feedback, :last_login, :positivo, :tempo_inerte, :cliente, :data_form, :last_login_form,
             :user_feedback, :data_feedback, :data_feedback_form, :user_avaliacao, :data_avaliacao, :data_avaliacao_form,
             :sistema, :versao, :positivo_desc, :situacao_financeira, :com_pendencia_financeira, :com_pendencia_financeira_desc,
             :ignorar_inerte_ate, :bloqueado, :bloqueado_desc

  belongs_to :cliente

  def data_form
    object.data.strftime("%d/%m/%Y") if object.data.present?
  end

  def last_login_form
    object.last_login.strftime("%d/%m/%Y %H:%M") if object.last_login.present?
  end

  def data_feedback_form
    object.data_feedback.strftime("%d/%m/%Y %H:%M") if object.data_feedback.present?
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

  def ignorar_inerte_ate
    object.cliente.sem_inerte_ate.strftime("%d/%m/%Y") if object.cliente.sem_inerte_ate.present?
  end


end
