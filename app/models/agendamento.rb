class Agendamento < ActiveRecord::Base
  include PublicActivity::Model

  belongs_to :user
  belongs_to :tipo_agendamento
  belongs_to :empresa
  belongs_to :cliente
  belongs_to :implantacao
  belongs_to :user_registro, class_name: 'User'
  belongs_to :user_cancelamento, class_name: 'User'
  belongs_to :user_confirmacao, class_name: 'User'

  def self.cancelar agendamento, motivo, user_id
    agendamento.update(ativo: false, motivo: motivo, user_cancelamento_id: user_id, data_cancelamento: Time.now)

    if agendamento.implantacao.present?
      agendamento.create_activity(:agenda_cancelada, owner: agendamento.user_cancelamento, recipient: agendamento.implantacao, params: {motivo: motivo})

      if agendamento.cliente.fechamento.present? && agendamento.cliente.fechamento.user_id != user_id
        proposta = agendamento.cliente.propostas.where(ativa: true).first
        Notificacao.criar_notificacao('AGENDA_CANCELADA', agendamento.cliente.fechamento.user_id, user_id,
                                      "Cliente #{agendamento.cliente.razao_social},#{ agendamento.data_inicio.strftime("%d/%m/%Y %H:%M ")},#{(agendamento.user.present? ? agendamento.user.name : '')},#{proposta.pacote.sistema.nome}",
                                      agendamento.data_cancelamento, agendamento.empresa_id, agendamento.id, 'Cancelamento!', nil,nil)

        adms = User.where(admin: true, active: true)
        adms.each do |user|
          if user.notificacao_agenda_cancelada?
            Notificacao.criar_notificacao('AGENDA_CANCELADA', user.id, user.id,
                                          "Cliente #{agendamento.cliente.razao_social},#{ agendamento.data_inicio.strftime("%d/%m/%Y %H:%M ")},#{(agendamento.user.present? ? agendamento.user.name : '')},#{proposta.pacote.sistema.nome}",
                                          agendamento.data_cancelamento, agendamento.empresa_id, agendamento.id, 'Cancelamento!', nil,nil)
          end
        end
      end
    else
      agendamento.create_activity(:agenda_cancelada, owner: agendamento.user_cancelamento, recipient: agendamento.cliente, params: {motivo: motivo})
    end
  end
end
