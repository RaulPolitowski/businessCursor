class PerguntaPesquisaResposta < ActiveRecord::Base
  belongs_to :pergunta
  belongs_to :pesquisa
end
