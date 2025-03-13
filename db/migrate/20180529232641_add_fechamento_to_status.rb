class AddFechamentoToStatus < ActiveRecord::Migration
  def change
    add_column :status, :fechamento, :boolean, default: false
  end
end
