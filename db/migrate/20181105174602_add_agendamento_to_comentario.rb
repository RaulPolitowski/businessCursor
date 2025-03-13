class AddAgendamentoToComentario < ActiveRecord::Migration
  def change
    add_reference :comentarios, :agendamento, index: true, foreign_key: true
  end
end
