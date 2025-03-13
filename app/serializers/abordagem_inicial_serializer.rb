class AbordagemInicialSerializer < ActiveModel::Serializer
  attributes :id, :texto, :tipo, :fila, :intervalo_resposta_automatica, :palavra_chave_validacao
end
