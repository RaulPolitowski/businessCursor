class AddMotivoUserCancelamentoToImplantacao < ActiveRecord::Migration
  def change
    add_column :implantacoes, :motivo, :string
    add_column :implantacoes, :user_cancelamento_id, :int
  end
end
