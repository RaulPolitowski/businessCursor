class AddTipoToLigacao < ActiveRecord::Migration
  def change
    add_column :ligacoes, :tipo, :integer, default: 0
    add_reference :ligacoes, :escritorio, index: true, foreign_key: true
  end
end
