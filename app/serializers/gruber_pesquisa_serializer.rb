class GruberPesquisaSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :cliente, :cliente_id, :cliente_nome, :cliente_email, :cliente_telefone, :gruber_pesquisa_respostas, :cliente_municipio, :pendencia_financeira, :cliente_razao_social, :cliente_cpf_cnpj, :tem_avaliacao_negativa

  has_many :gruber_pesquisa_respostas

  def cliente_municipio
    object.cliente.present? && object.cliente.municipio.present? ? object.cliente.municipio.descricao_completa : ""
  end

  def created_at
    object.created_at.strftime("%d/%m/%Y %H:%M")
  end

  def pendencia_financeira
    connection = Financeiro::ClienteFornecedor.connection
    lista = connection.select_all FinanceiroHelper.get_debitos_pendentes object.cliente_id

    lista[0]['count'].to_i > 0 ? "Sim" : "Não"
  end
end
