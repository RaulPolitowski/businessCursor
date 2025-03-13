module Api
  class Api::ClienteSerializer < ActiveModel::Serializer
    attributes  :id, :cnpj, :inscricao_estadual, :razao_social, :email, :telefone, :telefone2,
                :telefone_preferencial, :telefone2_preferencial, :telefone_enviado_whats, :telefone2_enviado_whats,
                :cidade, :fechamento

    has_one :fechamento
  end
end
