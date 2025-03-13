class SistemaTerceiroSerializer < ActiveModel::Serializer
  attributes :id, :mensalidade, :cliente_id, :cliente, :empresa, :nome, :observacao

  include ActionView::Helpers::NumberHelper

   def mensalidade
    number_with_precision(object.mensalidade , precision: 2)
  end

  def cliente
    object.cliente.razao_social unless object.cliente.nil?
  end
end
