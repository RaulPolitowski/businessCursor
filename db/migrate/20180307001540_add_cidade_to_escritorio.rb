class AddCidadeToEscritorio < ActiveRecord::Migration
  def change
    add_reference :escritorios, :cidade, index: true, foreign_key: true
  end
end
