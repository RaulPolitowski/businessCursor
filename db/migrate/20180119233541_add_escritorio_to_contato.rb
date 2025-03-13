class AddEscritorioToContato < ActiveRecord::Migration
  def change
    add_reference :contatos, :escritorio, index: true, foreign_key: true
  end
end
