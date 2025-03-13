class PerguntaSerializer < ActiveModel::Serializer
  attributes :id, :pergunta, :fechamento, :implantacao, :acompanhamento, :pergunta_gatilho, :tipo
end
