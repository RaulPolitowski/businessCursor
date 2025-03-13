class AddAtivaToPropostas < ActiveRecord::Migration
  def change
    add_column :propostas, :ativa, :boolean, default: true
  end
end
