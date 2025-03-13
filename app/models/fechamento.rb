class Fechamento < ActiveRecord::Base
  belongs_to :tipo_fechamento
  belongs_to :user
  belongs_to :proposta
  belongs_to :cliente
  belongs_to :status
  belongs_to :empresa

  after_create :notificar_venda_whatsapp

  Mensagem = Struct.new(:usuario, :sistema, :valor, :estado, :canal_de_venda, :total_vendas, :total_mensalidades, :empresa)

  def self.update_or_create(attributes)
    assign_or_new(attributes).save
  end

  def self.assign_or_new(attributes)
    obj = first || new
    obj.assign_attributes(attributes)
    obj
  end

  def total_vendas
    Fechamento.unscoped.where("created_at::date = ?", Date.today()).count
  end

  def total_mensalidades
    qtd = Proposta.joins("INNER JOIN fechamentos ON propostas.id = fechamentos.proposta_id")
          .where("ativa = true AND data_fechamento::date = ?", Date.today()).sum(:valor_mensalidade).to_f

    sprintf("%.2f", qtd)
  end

  private

    def notificar_venda_whatsapp
      @mensagem_notificacao = MensagemNotificacao.find_by tipo: 'VENDAS', ativo: true
      if @mensagem_notificacao.present? && @mensagem_notificacao.destinatarios.length > 0 && @mensagem_notificacao.numero_notificacao.present?
        if @mensagem_notificacao.possui_variaveis_vendas?
          mensagem = Mensagem.new(
            self.user.name,
            self.proposta.pacote.sistema.nome,
            sprintf("%.2f", self.proposta.valor_mensalidade.to_f),
            self.cliente.cidade.estado.sigla,
            self.tipo_fechamento.descricao,
            self.total_vendas,
            self.total_mensalidades,
            self.cliente.razao_social
          )
          @mensagem_notificacao.mensagem = @mensagem_notificacao.troca_variaveis(mensagem, ->(msg) { @mensagem_notificacao.variaveis_vendas(msg) })
        end
        WhatsappBotService.new(
          payload: ActiveModel::SerializableResource.new(@mensagem_notificacao, each_serializer: MensagemNotificacaoSerializer).to_json,
          numero: @mensagem_notificacao.numero_notificacao
        ).notify_whatsapp
      end
    end
end
