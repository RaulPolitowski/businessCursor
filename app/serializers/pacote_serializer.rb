class PacoteSerializer < ActiveModel::Serializer
  attributes :sistema_id, :mensalidade, :mensalidade_promocional, :implantacao,
             :implantacao_promocional, :implantacao_remota, :implantacao_remota_promocional

  include ActionView::Helpers::NumberHelper

  def implantacao
    number_with_precision(object.implantacao , precision: 2)
  end

  def mensalidade_promocional
    number_with_precision(object.mensalidade_promocional , precision: 2)
  end

  def mensalidade
    number_with_precision(object.mensalidade , precision: 2)
  end

  def implantacao_promocional
    number_with_precision(object.implantacao_promocional , precision: 2)
  end

  def mensalidade_promocional
    number_with_precision(object.mensalidade_promocional , precision: 2)
  end

  def implantacao_remota
    number_with_precision(object.implantacao_remota , precision: 2)
  end

  def implantacao_remota_promocional
    number_with_precision(object.implantacao_remota_promocional , precision: 2)
  end
end
