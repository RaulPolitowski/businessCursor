class CnaeCliente < ActiveRecord::Base
  belongs_to :cnae
  belongs_to :cliente
end
