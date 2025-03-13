class AddAnotacoesToLigacoes < ActiveRecord::Migration
  def change
    add_column :ligacoes, :anotacoes, :text
  end
end
