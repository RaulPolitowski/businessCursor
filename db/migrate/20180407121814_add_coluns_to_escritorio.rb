class AddColunsToEscritorio < ActiveRecord::Migration
  def change
    add_column :escritorios, :em_atendimento, :boolean, default: false
    add_column :escritorios, :user_atendimento_id, :integer
  end
end
