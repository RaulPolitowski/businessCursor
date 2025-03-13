class Financeiro::Estado < Financeiro::FiscalDatabase
  self.table_name = 'estado'

  def descricao_completa
    "#{nome} - #{sigla}"
  end
end
