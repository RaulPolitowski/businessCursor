class AddAtivoToPerguntas < ActiveRecord::Migration
  def change
    add_column :perguntas, :ativo, :boolean, default: true
  end
end
