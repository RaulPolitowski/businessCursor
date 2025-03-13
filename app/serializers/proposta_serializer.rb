class PropostaSerializer < ActiveModel::Serializer
  attributes :id, :cliente_id, :data, :pacote_id, :tipo_mensalidade, :valor_mensalidade, :tipo_implantacao,
             :valor_implantacao, :formas_pagamento_id, :qtde_parcela, :valor_parcelas, :observacao,
             :sistema, :data_formatada, :forma_pagamento, :ativa, :user, :qtd_maquinas,
             :meses_fidelidade, :fidelidade, :data_primeira_mensalidade

  include ActionView::Helpers::NumberHelper

  def valor_implantacao
    number_with_precision(object.valor_implantacao , precision: 2)
  end

  def valor_mensalidade
    number_with_precision(object.valor_mensalidade , precision: 2)
  end

  def sistema
    object.pacote.sistema.nome unless object.pacote.sistema.nil?
  end

  def forma_pagamento
    unless object.formas_pagamento_id.nil?
      forma = Formapagamento.find object.formas_pagamento_id
      forma.descricao
    end
  end

  def data_formatada
    object.data.strftime("%d/%m/%Y")
  end

  def data_primeira_mensalidade
    object.data_primeira_mensalidade.strftime("%d/%m/%Y") if object.data_primeira_mensalidade.present?
  end
end
