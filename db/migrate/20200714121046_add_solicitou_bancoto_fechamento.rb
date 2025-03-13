class AddSolicitouBancotoFechamento < ActiveRecord::Migration
  def change
    add_column :fechamentos, :solicitou_banco, :boolean
    remove_column :solicitacao_bancos, :status
    add_column :solicitacao_bancos, :status, :string
  end
end
