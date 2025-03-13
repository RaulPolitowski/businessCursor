class CreateGzapUsuarioAndMensagemNotificacao < ActiveRecord::Migration
  def change
    create_table :gzap_usuarios_mensagem_notificacoes do |t|
      t.references :gzap_usuario, index: { name: :gzap_usuarios_msg_notificacoes_usuario }, foreign_key: true
      t.references :mensagem_notificacao, index: { name: :gzap_usuarios_msg_notificacoes_notificacao }, foreign_key: true
    end
  end
end
