class AbordagemInicial < ActiveRecord::Base
  has_many :campanha_envios
  before_save :remove_params

  def self.ajuste_saudacao(texto)
    if texto.include? '[saudacao]'
      time = Time.now
      if (time.hour >= 06) && (time.hour < 12)
        texto = texto.sub '[saudacao]', 'Bom dia' 
      elsif (time.hour >= 12) && (time.hour < 18)
        texto = texto.sub '[saudacao]', 'Boa tarde'
      elsif time.hour >= 18
        texto = texto.sub '[saudacao]', 'Boa noite'
      end
    end
    texto
  end

  def self.ajuste_empresa(texto, cliente_razao_social)
    regex_empresa = /^\d{2}\.\d{3}\.\d{3}\s+/
    if texto.include? '[empresa]'
      razao_social = cliente_razao_social.sub(regex_empresa, '')
      texto = texto.sub '[empresa]', razao_social
    end
    texto
  end

  def self.ajuste_usuario(texto, username)
    texto = texto.sub '[usuario]', username if texto.include? '[usuario]'

    texto
  end

  def self.ajuste_lista_ligacao(texto, username)
    texto = texto.sub '[lista]', username if texto.include? '[lista]'

    texto
  end

  def self.ajuste_para_captacao(texto, params)
    texto = ajuste_lista_ligacao(texto, params[:user])
    texto = ajuste_usuario(texto, params[:user])
    texto = ajuste_empresa(texto, params[:empresa])
    texto
  end

  def self.get_abordagens_tipo(tipo)
    AbordagemInicial.where(ativa: true, tipo: tipo)
  end

  def resposta?
    tipo == 'RESPOSTA'
  end

  def fila?
    ['RESPOSTA', 'CAPTACAO'].include? tipo
  end

  private
    def remove_params
      return if resposta?

      self.palavra_chave_validacao = nil
      self.intervalo_resposta_automatica = nil
      self
    end
end