class Financeiro::ClienteFornecedor < Financeiro::FiscalDatabase
  self.table_name = 'financeiro.clientefornecedorfinanceiro'

  belongs_to :municipio, :class_name => 'Financeiro::Cidade'
end
