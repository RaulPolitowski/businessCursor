class AddFinalizadoToLembrete < ActiveRecord::Migration
  def change
    add_column :lembretes, :finalizado, :boolean, default: false
  end
end
