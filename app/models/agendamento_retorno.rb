class AgendamentoRetorno < ActiveRecord::Base
  include PublicActivity::Model

  belongs_to :ligacao
  belongs_to :cliente
  belongs_to :acompanhamento
  belongs_to :implantacao
  belongs_to :user
  belongs_to :user_retorno, class_name: "User"
  belongs_to :usuario_cancelamento, class_name: "User"
  belongs_to :empresa
  belongs_to :solicitacao_desistencia

  validates_presence_of :data_agendamento_retorno, :cliente_id

  ransacker :data_agendamento_retorno do
    Arel::Nodes::SqlLiteral.new("date(data_agendamento_retorno)")
  end

  def self.criarRetornoAcompanhamento(data, acompanhamento, user_id)
    retornos = AgendamentoRetorno.where(acompanhamento: acompanhamento)
    retornos.update_all(user_retorno_id: user_id, data_efetuado_retorno: Time.now)

    if data.present?
      AgendamentoRetorno.create(cancelado:false, cliente: acompanhamento.cliente, empresa_id: acompanhamento.empresa_id, user_id: user_id, data_agendamento_retorno: data,
                                acompanhamento: acompanhamento)
    end
  end

  def self.criarRetornoImplantacao(data, implantacao, user_id)
    retornos = AgendamentoRetorno.where(implantacao: implantacao)
    retornos.update_all(user_retorno_id: user_id, data_efetuado_retorno: Time.now)

    if data.present?
      AgendamentoRetorno.create(cancelado:false, cliente: implantacao.cliente, empresa_id: implantacao.empresa_id, user_id: user_id, data_agendamento_retorno: data,
                                implantacao: implantacao)
    end
  end

  def self.criarRetornoSolicitacaoDesistencia(data, solicitacao_desistencia, user_id)
    retornos = AgendamentoRetorno.where(solicitacao_desistencia: solicitacao_desistencia)
    retornos.update_all(user_retorno_id: user_id, data_efetuado_retorno: Time.now)

    if data.present?
      AgendamentoRetorno.create(cancelado:false, cliente: solicitacao_desistencia.cliente, empresa_id: solicitacao_desistencia.empresa_id, user_id: user_id, data_agendamento_retorno: data,
                                solicitacao_desistencia: solicitacao_desistencia)
    end
    
  end

  def observacao
    return ligacao.observacao if ligacao.present?
    return acompanhamento.observacao if acompanhamento.present?
  end
end
