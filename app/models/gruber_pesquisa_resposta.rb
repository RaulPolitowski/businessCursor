class GruberPesquisaResposta < ActiveRecord::Base
  belongs_to :servico
  belongs_to :setor
  belongs_to :gruber_pesquisa
end
