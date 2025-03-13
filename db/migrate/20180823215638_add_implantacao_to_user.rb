class AddImplantacaoToUser < ActiveRecord::Migration
  def change
    add_column :users, :implantacao_id, :int
  end
end
