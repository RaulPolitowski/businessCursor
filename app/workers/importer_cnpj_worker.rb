class ImporterCnpjWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'default', retry: false

  def perform(cnpj)
    cliente = Cliente.where(cnpj: cnpj, empresa_id: 20).first
    Importacao.importar_dados_receita(cliente) if !cliente.nil?
  end
end
