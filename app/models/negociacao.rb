class Negociacao < ActiveRecord::Base
  include PublicActivity::Model

  belongs_to :user
  belongs_to :cliente
  belongs_to :empresa
  belongs_to :prospectador, class_name: 'User'
  has_many :agendamento_retornos
end
