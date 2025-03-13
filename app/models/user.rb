class User < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader
  include PublicActivity::Model

  validates :email, uniqueness: true
  has_many :agendamentos
  has_many :whatsapp_numeros
  has_and_belongs_to_many :empresas
  belongs_to :permissao

  scope :empresas_acesso, ->(empresa_id) { select("distinct users.*").joins(:empresas).where("users.active is true and empresas_users.empresa_id in(#{empresa_id})") }
  scope :comercial, -> { where(permissao_id: 2, active: true) }
  scope :ativos_com_telefone, -> { where(active: true).where.not(telefone: nil) }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable,
         :trackable, :validatable, :timeoutable

  def admin?
    admin
  end

  def nome_destinatarios
    nome + destinatarios
  end

  def active_for_authentication?
    super if active unless false
  end
end
