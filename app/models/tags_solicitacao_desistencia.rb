class TagsSolicitacaoDesistencia < ActiveRecord::Base
  scope :sem_tags_troca_cnpj, -> { where("id != '45'") }
  scope :apenas_tags_troca_cnpj, -> { where("id = '45'") }
end
