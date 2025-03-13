class SolicitacaoBancoSerializer < ActiveModel::Serializer
  attributes :id, :user, :cliente, :tipo, :status, :finalizado, :motivo_solicitacao, :observacao, :motivo_desativacao, 
      :ativo, :data_solicitacao, :cidade, :data_implantacao, :responsavel, :sistema, :local_banco,
      :sistema_p, :nome_solicitante, :regime, :socio_admin, :telefone1, :telefone2, :valor_mensalidade, 
      :valor_implantacao, :data_vencimento, :data_implantacao_p, :email_cliente, :telefone_parceiro, :email_solicitante,
             :username, :nome_usuario, :password, :contribuinte_icms, :inscricao_estadual, :nota_fiscal_modulo,
             :nota_fiscal_consumidor_modulo, :conhecimento_transporte_modulo, :manifesto_eletronico_modulo,
             :nota_fiscal_servico_modulo, :cupom_fiscal_modulo, :file, :motivo_erro, :cliente_id

  def cidade
    object.cliente.cidade.nome + '/' + object.cliente.cidade.estado.sigla unless object.cliente.nil? || object.cliente.cidade.nil?
  end

  def data_solicitacao
    object.created_at.strftime("%d/%m/%Y %H:%M")
  end

  def data_vencimento
    object.data_vencimento.strftime("%d/%m/%Y") if object.data_vencimento.present?
  end

  def data_implantacao_p
    object.data_implantacao.strftime("%d/%m/%Y") if object.data_implantacao.present?
  end

  def sistema
    object.cliente.fechamento.proposta.pacote.sistema.nome if object.cliente.fechamento.present?
  end

  def sistema_p
    object.sistema if object.sistema.present?
  end

  def data_implantacao
    if object.cliente.implantacao
      agendamento = object.cliente.implantacao.agendamentos.where('tipo_agendamento_id in (50,1,2) and ativo is true')
      agendamento[0].data_inicio.strftime("%d/%m/%Y %H:%M") if agendamento.present?
    else 
      'Sem implantação definida'     
    end
  end
end
