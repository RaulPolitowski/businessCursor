class AddAtivoToMensagemNotificacao < ActiveRecord::Migration
  def change
    add_column :mensagem_notificacoes, :ativo, :boolean, default: true
  end
end
