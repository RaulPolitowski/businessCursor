class WhatsappNumero < ActiveRecord::Base

  belongs_to :campanha
  belongs_to :user
  belongs_to :loja_item

  validates :numero, uniqueness: true

  scope :sem_loja_item, -> {
    joins("left join loja_itens li on li.numero = whatsapp_numeros.numero")
    .where("li.status = 'COMPRADO' or (li.id IS NUll AND li.status IS NULL)")
  }

  def numero_nome
    "#{numero} - #{nome}"
  end

  def numero_usuario_nome
    "#{numero} - #{user.present? ? user.name : nome}"
  end

  def self.update_or_create(attributes)
    obj = assign_or_new(attributes)
    obj.save!
    obj
  end

  def self.assign_or_new(attributes)
    obj = first || new
    obj.assign_attributes(attributes)
    obj
  end

  def self.ativar_numero_ocultado(id)
    numero_oculto = WhatsappNumero.find(id)
    numero_oculto&.update!(is_ocultado: false, tempo_ocultacao: nil, data_inicio_ocultacao: nil)
  end

  def self.atualizar_numeros_ocultos
    numeros_ocultos = WhatsappNumero.where(status: :CONECTADO, is_ocultado: :true)
    numeros_ocultos.each do |numero|
      data_liberacao = numero.data_inicio_ocultacao + numero.tempo_ocultacao.hours
      numero.update!(is_ocultado: false, tempo_ocultacao: nil, data_inicio_ocultacao: nil) if DateTime.current >= data_liberacao
    end
  end
end
