class AddTipoToPergunta < ActiveRecord::Migration
  def change
    add_column :perguntas, :tipo, :varchar
  end
end
