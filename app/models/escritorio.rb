class Escritorio < ActiveRecord::Base
  has_many :clientes
  has_many :contatos
  belongs_to :empresa
  belongs_to :user
  belongs_to :cidade
  belongs_to :status
  belongs_to :user_atendimento, class_name: 'User'
  has_many :ligacoes

  accepts_nested_attributes_for :contatos, :allow_destroy => true

  scope :abc_paulista, -> { where("escritorios.cidade_id in (34,51,52,54,60,93,115)") }
  scope :sao_paulo, -> { where("escritorios.cidade_id = 29") }
  scope :demais_cidades_sp, -> { joins(:cidade).where("escritorios.cidade_id not in (34,51,52,54,60,93,115, 29) and cidades.estado_id = 2 ") }
  scope :join_ultima_ligacao, -> { joins("left join ligacoes on ligacoes.escritorio_id = escritorios.id and ligacoes.id = (select max(id) from ligacoes where escritorio_id = escritorios.id)") }
  scope :telefone, ->(telefone) { where(" replace(replace(replace(replace(replace(telefone, '-', '') ,'(', ''), ')', ''), ' ', ''), '/', '') = replace(substring(replace(replace(replace(replace(?, '-', '') ,'(', ''), ')', ''), ' ', ''), 0, 12), '/', '') ", telefone) }
  scope :telefone_contato, ->(telefone) { select("distinct escritorios.*").joins(:contatos).where(" replace(replace(replace(replace(replace(contatos.telefone, '-', '') ,'(', ''), ')', ''), ' ', ''), '/', '') = replace(substring(replace(replace(replace(replace(?, '-', '') ,'(', ''), ')', ''), ' ', ''), 0, 12), '/', '') ", telefone) }

  def nome
    razao_social.nil? ? nome_fantasia : razao_social
  end

  ransacker :created_at do
    Arel::Nodes::SqlLiteral.new("date(created_at)")
  end
end
