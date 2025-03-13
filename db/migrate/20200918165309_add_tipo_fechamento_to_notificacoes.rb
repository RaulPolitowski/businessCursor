class AddTipoFechamentoToNotificacoes < ActiveRecord::Migration
  def change
    add_column :notificacoes, :tipo_fechamento, :string
  end
end
