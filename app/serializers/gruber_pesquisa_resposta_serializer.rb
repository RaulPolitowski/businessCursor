class GruberPesquisaRespostaSerializer < ActiveModel::Serializer
  attributes :id, :motivo, :nota, :servico_id, :servico, :setor_id, :setor, :setor_financeiro_id, :setor_financeiro_nome

end
