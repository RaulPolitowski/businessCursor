class AddPrivadoToLembrete < ActiveRecord::Migration
  def change
    add_column :lembretes, :privado, :boolean, default: true
  end
end
