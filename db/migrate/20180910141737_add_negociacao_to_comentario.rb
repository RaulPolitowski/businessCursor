class AddNegociacaoToComentario < ActiveRecord::Migration
  def change
    add_reference :comentarios, :negociacao, index: true, foreign_key: true
  end
end
