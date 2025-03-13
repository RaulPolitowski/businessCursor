class LembreteSerializer < ActiveModel::Serializer
  attributes :id, :data, :user_registro_id, :user_lembrete_id, :observacao, :data_formatada,
             :user_registro, :user_lembrete, :privado

  def data_formatada
    object.data.strftime("%d/%m/%Y %H:%M") #strftime("%d/%m/%Y - %H:%M")
  end

  def user_registro
    object.user_registro.name
  end

  def user_lembrete
    object.user_lembrete.name
  end
end
