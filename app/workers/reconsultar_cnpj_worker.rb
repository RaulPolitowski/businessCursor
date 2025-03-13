class ReconsultarCnpjWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'default', retry: false

  def perform(cnpj)
    cliente = Cliente.where(cnpj: cnpj).first
    Importacao.reconsultar_dados_receita(cliente) if !cliente.nil?
  end
end
  