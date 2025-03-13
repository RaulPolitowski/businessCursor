class AddPermissaoToUser < ActiveRecord::Migration
  def change
    add_reference :users, :permissao, index: true, foreign_key: true
  end
end
