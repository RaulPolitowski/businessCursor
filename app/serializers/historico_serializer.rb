class HistoricoSerializer < ActiveModel::Serializer
  attributes :id, :escritorio_id, :data, :data_formatada,
             :user_id, :usuario, :observacao


  def data_formatada
    object.data.strftime("%d/%m/%Y") #strftime("%d/%m/%Y - %H:%M")
  end

  def usuario
    object.user.name
  end
end
