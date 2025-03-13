class Estado < ActiveRecord::Base

  scope :estados_preferidos, -> { where('id in (1,2,3,4,5,12,14,18,21,22,23,24,25,26,27,28)') }
  # Se quer adicionar algum estado para dentro do CD, adicione o estado no estados_ignoraveis do gerar_fila_empresa_centro.rb
  scope :estados_demais, -> { where('id in (7,8,9,10,11,13,15,16,17,19,20)') }
  scope :estados_demais_e_preferidos, -> { where("id not in (29)")}
  scope :todos, -> { where("sigla not in ('CD')")}

  def descricao_completa
    "#{nome} - #{sigla}"
  end
end
