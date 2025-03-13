class Cnae < ActiveRecord::Base

  validates :codigo, uniqueness: true

  scope :permitidos, -> { where(blacklist: false) }

  def self.importar_cnae(code)
    uri = URI("http://cnae.ibge.gov.br/?view=subclasse&tipo=cnae&versao=9.1.0&subclasse=" + code.to_s + "&chave=" + code.to_s)
    http = Net::HTTP.start(uri.host, uri.port)
    request = Net::HTTP::Get.new uri.request_uri
    response = http.request request # Net::HTTPResponse object
    body = response.body

    doc = Nokogiri::HTML(body)

    descriction = doc.xpath('//*[@id="hierarquia"]/table/tbody/tr[5]/td[3]/span').children.text
    if descriction.nil? || descriction.empty?
      #se não encontrar na consulta, cadastra CNAE em com descricao em branco.
      cnae = Cnae.new

      cnae.codigo = code
      cnae.descricao = ''

      cnae.save

      return cnae
    else
      cnae = Cnae.new

      cnae.codigo = code
      cnae.descricao = descriction.strip

      cnae.save

      return cnae
    end
  end

end
