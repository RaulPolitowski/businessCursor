class GzapUsuario < ActiveRecord::Base
  has_many :gzap_usuarios_mensagem_notificacoes
  has_many :mensagem_notificacoes, through: :gzap_usuarios_mensagem_notificacoes

  def self.get_numero_interesse
    WhatsappBotService.new.search_numbers
  end
end