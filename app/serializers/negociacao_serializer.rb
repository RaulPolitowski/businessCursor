class NegociacaoSerializer < ActiveModel::Serializer
  attributes :id, :data_inicio, :data_fim, :user, :cliente, :obs, :status, :qtd_dias, :telefones,
             :contato, :retorno

  belongs_to :user

  def data_inicio
    object.data_inicio.strftime("%d/%m/%Y")
  end

  def data_fim
    object.data_fim.strftime("%d/%m/%Y") unless object.data_fim.nil?
  end

  def qtd_dias
    timediff = (Time.now - object.data_inicio)
    (timediff / 1.day).round
  end

  def telefones
     object.cliente.telefones_preferenciais
  end

  def obs
    object.obs.present? ? object.obs : ''
  end

  def contato
     contato = object.cliente.contatos.first
     return '' if contato.nil?
     nome = contato.nome.split(' ')
     nome[1].present? ? nome[1] : ''
  end

  def retorno
    AgendamentoRetorno.where(cancelado: false, data_efetuado_retorno: nil, cliente_id: object.cliente.id).order('id desc').first
  end

end
