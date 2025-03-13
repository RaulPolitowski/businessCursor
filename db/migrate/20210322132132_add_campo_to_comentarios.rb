class AddCampoToComentarios < ActiveRecord::Migration
  def change
    #tupla utilizada para controlar comentarios de histórico e de acordo das solicitação de desistencia
    add_column :comentarios, :isAcordo, :boolean
  end
end
