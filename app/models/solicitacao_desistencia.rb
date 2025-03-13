class SolicitacaoDesistencia < ActiveRecord::Base
  belongs_to :cliente
  belongs_to :empresa
  belongs_to :user
  has_many :agendamentos
  has_many :comentarios

  scope :sem_tags_troca_cnpj, -> { where("tags IS NULL OR NOT tags::jsonb ?| array['45']") }
  scope :apenas_tags_troca_cnpj, -> { where("tags::jsonb ?| array['45']") }
end