class Contato < ActiveRecord::Base
  belongs_to :cliente
  belongs_to :escritorio
  has_many :telefones
end
