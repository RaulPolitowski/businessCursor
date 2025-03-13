class Implantacao < ActiveRecord::Base
  include PublicActivity::Model

  belongs_to :cliente
  belongs_to :proposta
  belongs_to :empresa
  belongs_to :user
  has_many :agendamentos
  has_many :comentarios

  def sistema
    return  proposta.nil? || proposta.pacote.nil? ? "" : proposta.pacote.sistema.nome
  end

  def agenda
    agenda =  Agendamento.where('implantacao_id = ? and ativo is true and tipo_agendamento_id IN (5,6)', id).order(:data_inicio).first if status > 3
    agenda = Agendamento.where('implantacao_id = ? and ativo is true and tipo_agendamento_id IN (1,2)', id).order(:data_inicio).first if agenda.nil?
    return agenda
  end

  def is_em_andamento?
    [3, 4, 5].include? status
  end

  def is_aguardando?
    [0, 1, 2, 10].include? status
  end

  def is_desistente?
    [7,8].include? status
  end

  def is_finalizado?
    [9].include? status
  end

  def self.ajustar_motivos
    implantacoes = Acompanhamento.where('status in (4)')
    implantacoes.each do |implantacao|
      act = implantacao.activities.where(key: "acompanhamento.desistente_acompanhamento").first
      implantacao.update(motivo: act.parameters[:motivo], user_cancelamento_id: act.owner_id) unless act.nil?
    end
  end

  def self.alterar_empresas_limbo
    connection = ActiveRecord::Base.connection

    sql = ImplantacoesHelper.get_sql_implantacoes nil, nil, nil, nil, nil, nil, '(0,1,2)', false, 'criar_limbo', false, nil

    @implantacoes = connection.select_all sql

    user = User.find 1

    @implantacoes.each do |implantacao|
      impl = Implantacao.find implantacao['id']
      impl.update(status: 10)
      impl.cliente.update(status_id: 47)

      impl.create_activity(:limbo, owner: user, recipient: impl)
    end
  end

  def notificar_alteracoes
    activity = activities.last
    if cliente.fechamento.present?
      Notificacao.criar_notificacao('IMPLANTACAO_ALTERACAO', cliente.fechamento.user_id, cliente.fechamento.user_id,
                                    Implantacao.criar_observacao_alteracao(activity),
                                    activity.created_at, empresa_id, id, 'Implantação!', "../implantacoes/#{ id }",nil)

      if is_finalizado? || is_em_andamento?
        adms = User.where(admin: true, active: true)
        adms.each do |user|
          if user.notificacao_implantacao?
            Notificacao.criar_notificacao('IMPLANTACAO_ALTERACAO', user.id, user.id,
                                          Implantacao.criar_observacao_alteracao(activity),
                                          activity.created_at, empresa_id, id, 'Implantação!', "../implantacoes/#{ id }",nil)
          end
        end
      end
    end
  end

  def self.criar_observacao_alteracao activity
    case activity.key
      when 'implantacao.iniciada'
        "#{activity.owner.name } iniciou a implantação na empresa #{ activity.recipient.cliente.razao_social } às #{ activity.created_at.strftime("%d/%m/%Y %H:%M ") }."
      when 'implantacao.pausada'
        "#{activity.owner.name } pausou a implantação na empresa #{ activity.recipient.cliente.razao_social } às #{ activity.created_at.strftime("%d/%m/%Y %H:%M ") }."
      when 'implantacao.continuou'
        "#{activity.owner.name } deu continuidade a implantação na empresa #{ activity.recipient.cliente.razao_social } às #{ activity.created_at.strftime("%d/%m/%Y %H:%M ") }."
      when 'implantacao.instalacao_terminada'
        "#{activity.owner.name } finalizou a instalação na empresa #{ activity.recipient.cliente.razao_social } às #{ activity.created_at.strftime("%d/%m/%Y %H:%M ") }."
      when 'implantacao.iniciado_treinamento'
        "#{activity.owner.name } iniciou o treinamento na empresa #{ activity.recipient.cliente.razao_social } às #{ activity.created_at.strftime("%d/%m/%Y %H:%M ") }."
      when 'implantacao.finalizado_implantacao'
        "#{activity.owner.name } finalizou a implantação na empresa #{ activity.recipient.cliente.razao_social } às #{ activity.created_at.strftime("%d/%m/%Y %H:%M ") }."
      else
        ""
    end
  end

  def self.update_or_create(attributes)
    assign_or_new(attributes).save
  end

  def self.assign_or_new(attributes)
    obj = first || new
    obj.assign_attributes(attributes)
    obj
  end
end
