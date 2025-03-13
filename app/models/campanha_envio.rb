class CampanhaEnvio < ActiveRecord::Base
  belongs_to :campanha
  belongs_to :cliente
  belongs_to :abordagem_inicial
end
