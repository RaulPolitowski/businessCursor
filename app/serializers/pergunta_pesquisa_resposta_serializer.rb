class PerguntaPesquisaRespostaSerializer < ActiveModel::Serializer
  attributes :id, :pergunta, :pesquisa, :resposta
end
