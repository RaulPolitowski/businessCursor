class AddAcompanhamentoToComentario < ActiveRecord::Migration
  def change
    add_reference :comentarios, :acompanhamento, index: true, foreign_key: true
  end
end
