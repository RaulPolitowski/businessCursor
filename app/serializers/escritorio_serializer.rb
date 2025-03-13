class EscritorioSerializer < ActiveModel::Serializer
  attributes  :id, :razao_social, :nome_fantasia, :telefone, :responsavel, :possui_parceria,
              :empresa_parceria, :observacao, :tem_interesse_parceria, :motivo_sem_interesse,
              :parceria_obs, :cidade, :passa_contato, :status_id, :empresa_id

  belongs_to :cidade
end
