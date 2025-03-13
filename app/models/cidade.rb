class Cidade < ActiveRecord::Base
  require 'open-uri'
  require 'csv'

  belongs_to :estado

  scope :por_estado, ->(estado_sigla) { joins(:estado).where('estados.sigla = ?', estado_sigla) }

  def self.importar_cidades_sefaz_pr()
    file  = open('http://www.fazenda.pr.gov.br/arquivos/File/tabcodmunicipio.txt') {|f| f.read }

    csv = CSV.parse(file, :headers=> false)

    csv.each do |t|
      cidade = Cidade.new()

      linha = t.to_s.split(';')
      reg = Cidade.find_by_codigo linha[0].gsub("[\"", "")

      if(reg.nil?)
        cidade.codigo = linha[0].gsub("[\"", "")
        cidade.nome = linha[1].gsub("\"]", "")
        cidade.estado = Estado.find_by_sigla 'PR'

        cidade.save
      end
    end
  end

  def descricao_completa
    "#{nome} - #{estado.sigla}"
  end
end
