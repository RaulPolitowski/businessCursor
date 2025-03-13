class AddConferidoBaixadoToNegociacao < ActiveRecord::Migration
  def change
    add_column :negociacoes, :conferido, :boolean, default: false
    add_column :negociacoes, :baixado, :boolean, default: false
  end
end
