class MensagemNotificacao < ActiveRecord::Base
  belongs_to :numero_notificacao
  has_many :gzap_usuarios_mensagem_notificacoes
  has_many :gzap_usuarios, through: :gzap_usuarios_mensagem_notificacoes, dependent: :destroy

  validates_uniqueness_of :tipo, scope: [:ativo, :tipo], if: 'ativo?'
  validates :numero_notificacao, presence: true, if: 'vendas?'
  before_save :destroy_associative_table!, if: 'vendas?'

  scope :captacao, -> { find_by(tipo: 'CAPTACAO') }

  def variaveis_vendas(msg = {})
    {
      '[usuario]' => msg[:usuario],
      '[sistema]' => msg[:sistema],
      '[valor]' => msg[:valor],
      '[estado]' => msg[:estado],
      '[canal_de_venda]' => msg[:canal_de_venda],
      '[total_vendas]' => msg[:total_vendas],
      '[total_mensalidades]' => msg[:total_mensalidades],
      '[empresa]' => msg[:empresa]
    }
  end

  def variaveis_interesse(msg = {})
    {
      '[total_leads]' => msg[:total_leads],
      '[numero_comercial]' => msg[:numero_comercial],
      '[numero_cliente]' => msg[:numero_cliente],
      '[usuario]' => msg[:usuario]
    }
  end

  def variaveis_lista_captacao(msg = {})
    {
      '[usuario]' => msg[:usuario],
      '[empresa]' => msg[:msg_atendimento]
    }
  end

  def possui_variaveis_vendas?
    variaveis_vendas.keys.any? { |variavel| mensagem.include?(variavel.to_s) }
  end

  def troca_variaveis(msg, func_variaveis)
    func_variaveis.call(msg).each { |variavel, valor| mensagem.gsub!(variavel, valor.to_s) }

    mensagem
  end

  def interesse?
    tipo == 'INTERESSE'
  end

  def vendas?
    tipo == 'VENDAS'
  end

  def captacao?
    tipo == 'CAPTACAO'
  end

  private

  def destroy_associative_table!
    gzap_usuarios_mensagem_notificacoes.destroy_all
  end
end