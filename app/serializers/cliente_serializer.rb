class ClienteSerializer < ActiveModel::Serializer
  attributes  :id, :cnpj, :inscricao_estadual, :data_importacao, :data_licenca,
              :razao_social, :email, :telefone, :telefone2, :cnae, :cidade,
              :triagem, :cliente, :telefone_preferencial, :telefone2_preferencial,
              :telefone_enviado_whats, :telefone2_enviado_whats, :propostas, :sistema_terceiros,
              :status, :cnae_clientes, :contatos, :escritorio, :cidade, :telefone_respondeu_whats,
              :telefone2_respondeu_whats, :msg_whats, :fechamento, :implantacao, :empresa_id, :porte, :tempo_inerte, :job, 
              :hist_impl_id, :hist_acomp_id, :data_implantacao, :assinou_contrato, :socio_admin, :proposta, :sistema, :dias_cliente, :email_backup, :senha_backup,
              :reconsultado

  belongs_to :cnae
  belongs_to :cidade
  belongs_to :escritorio
  has_many :propostas
  has_many :contatos
  has_many :cnae_clientes
  has_one :sistema_terceiros, class_name: 'SistemaTerceiro'
  has_one :fechamento
  has_one :negociacao
  has_one :implantacao

  def job
    return ApplicationHelper.get_job(object.numero_fila, object.empresa_id)
  end

  def data_importacao
    object.data_importacao.strftime("%d/%m/%Y") if object.data_importacao.present?
  end

  def data_licenca
    object.data_licenca.strftime("%d/%m/%Y") if object.data_licenca.present?
  end

  def triagem
    object.triagem? ? 'Sim' : 'Não'
  end

  def cliente
    object.fechamento.present? ? true : false
  end

  def msg_whats
    parametro = Parametro.find_by_empresa_id object.empresa_id
    parametro.nil? || parametro.msg_whats.nil? ? '' : parametro.msg_whats
  end

  def data_implantacao
    if object.id.present? && object.fechamento.present?
      implantacao = Implantacao.find_by_cliente_id object.id
      return implantacao.data_inicio.present? ? implantacao.data_inicio.strftime("%d/%m/%Y %H:%M") : '' if implantacao.present?
    end
    return ''
  end

  def proposta
    object.propostas.last if object.propostas.present?
  end

  def sistema
    object.propostas.last.pacote.sistema.nome if object.propostas.present?
  end

  def dias_cliente
    if object.id.present? && object.fechamento.present?
      implantacao = Implantacao.find_by_cliente_id object.id
      if implantacao.present? && implantacao.data_fim.present? 
        return TimeDifference.between(Time.now, implantacao.data_fim).in_days.to_i
      end
    end
    return 0
  end
end

