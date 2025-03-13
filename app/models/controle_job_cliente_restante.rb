class ControleJobClienteRestante < ActiveRecord::Base
  belongs_to :controle_job
  belongs_to :cliente
end
