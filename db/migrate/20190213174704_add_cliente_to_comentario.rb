class AddClienteToComentario < ActiveRecord::Migration
  def change
    add_reference :comentarios, :cliente, index: true, foreign_key: true
  end
end
