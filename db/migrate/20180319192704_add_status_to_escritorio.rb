class AddStatusToEscritorio < ActiveRecord::Migration
  def change
    add_reference :escritorios, :status, index: true, foreign_key: true
  end
end
