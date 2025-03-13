class AddTipoComissaoUser < ActiveRecord::Migration
  def change
    add_column :users, :tipo_comissao, :integer
  end
end
