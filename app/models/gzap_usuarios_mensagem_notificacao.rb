class GzapUsuariosMensagemNotificacao < ActiveRecord::Base
  belongs_to :gzap_usuario
  belongs_to :mensagem_notificacao

  before_destroy :desativar_usuario_gzap
  before_save :ativar_gzap_usuario

  def send_changes_to_api_gzap(ativo: nil)
    WhatsappBotService.new(
      payload: {
        id: gzap_usuario.user_id,
        isNotificador: ativo || new_record?
      }.to_json
    ).activate_user
  end

  private

  def desativar_usuario_gzap
    send_changes_to_api_gzap ativo: false
  end

  def ativar_gzap_usuario
    send_changes_to_api_gzap ativo: true
  end
end
