class Comentario < ActiveRecord::Base
  include PublicActivity::Model

  belongs_to :user
  belongs_to :implantacao
  belongs_to :acompanhamento
  belongs_to :negociacao
  belongs_to :agendamento
  belongs_to :cliente
  belongs_to :solicitacao_desistencia
end
