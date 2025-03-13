class LojaItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :whatsapp_numero

  validates :numero, uniqueness: {message: '%{value} já existe, tente novamente'}
end
