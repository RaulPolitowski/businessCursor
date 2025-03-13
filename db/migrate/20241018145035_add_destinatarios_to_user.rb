class AddDestinatariosToUser < ActiveRecord::Migration
  def change
    add_column :users, :telefone, :string, default: nil
  end
end
