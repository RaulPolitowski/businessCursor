class AddUserRegistroToEscritorios < ActiveRecord::Migration
  def change
    add_reference :escritorios, :user, index: true, foreign_key: true
  end
end
