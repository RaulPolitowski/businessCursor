class Pacote < ActiveRecord::Base
  belongs_to :sistema
  belongs_to :empresa

  validates_uniqueness_of :sistema_id, :scope => :empresa_id

  def replicar_pacote_todas_empresas(not_emp)
    empresas = Empresa.ativas
    empresas.each do |emp|
      pacote = Pacote.new(self.attributes.merge({empresa: emp, id: nil}))
      pacote.save unless emp.id.eql? not_emp
    end
  end

  def self.replicar_pacote_empresa_origem_destino(empresa_origem_id, empresa_id)
    pacotes = Pacote.where(empresa: empresa_origem_id)
    pacotes.each do |pacote|
      pacote = Pacote.new(pacote.attributes.merge({empresa_id: empresa_id, id: nil}))
      pacote.save
    end
  end

end
