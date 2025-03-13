class AddClienteRefToLigacao < ActiveRecord::Migration
  def change
    add_reference :ligacoes, :cliente, index: true, foreign_key: true
  end
end
