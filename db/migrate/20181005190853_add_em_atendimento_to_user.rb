class AddEmAtendimentoToUser < ActiveRecord::Migration
  def change
    add_column :users, :em_atendimento, :boolean, default: false
  end
end
