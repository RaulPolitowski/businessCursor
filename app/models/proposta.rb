class Proposta < ActiveRecord::Base
  belongs_to :pacote
  belongs_to :empresa
  belongs_to :cliente
  belongs_to :user
  belongs_to :forma_pagamento
end
