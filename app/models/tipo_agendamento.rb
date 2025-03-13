class TipoAgendamento < ActiveRecord::Base
  #belongs_to :empresa

  validates_uniqueness_of :descricao #, :scope => :empresa_id
end
