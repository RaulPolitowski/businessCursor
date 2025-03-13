class Formapagamento < ActiveRecord::Base
  self.table_name = "formas_pagamento"

  belongs_to :empresa
end
