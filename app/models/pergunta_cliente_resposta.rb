class PerguntaClienteResposta < ActiveRecord::Base
  belongs_to :cliente
  belongs_to :pergunta
  has_many :pergunta_cliente_resposta_tags
end
