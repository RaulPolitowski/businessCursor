class NumeroNotificacao < ActiveRecord::Base
	validates :numero, uniqueness: true

	def numero_nome
		"#{numero} - #{nome}"
	end
end
