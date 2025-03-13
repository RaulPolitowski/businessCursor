class Financeiro::Cidade < Financeiro::FiscalDatabase
  self.table_name = 'municipio'

  belongs_to :estado, :class_name => 'Financeiro::Estado'

  def descricao_completa
    "#{nome} - #{estado.sigla}"
  end
end
