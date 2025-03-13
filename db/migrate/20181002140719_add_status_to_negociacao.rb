class AddStatusToNegociacao < ActiveRecord::Migration
  def change
    add_reference :negociacoes, :status, index: true, foreign_key: true
  end
end
