class Financeiro::Contrato < Financeiro::FiscalDatabase
  self.table_name = 'contrato'

  def self.cancelar_contrato(acompanhamento, user)
    begin
      cliente = Financeiro::ClienteFornecedor.where(cpfcnpj: acompanhamento.cliente.cnpj).first
      return "Cliente #{acompanhamento.cliente.razao_social} não localizado no financeiro" if cliente.nil?

      connection = Financeiro::ClienteFornecedor.connection
      contrato = connection.select_all FinanceiroHelper.get_contrato_ativo(cliente.cpfcnpj, true)

      contrato = contrato.first
      return "Contrato do cliente #{acompanhamento.cliente.razao_social} não localizado no financeiro" if contrato.nil?

      contrato = Financeiro::Contrato.find contrato['id'].to_i

      if contrato.experiencia? && !contrato.gerado?
        activity = acompanhamento.activities.where("key in ('acompanhamento.desistente_acompanhamento', 'acompanhamento.desistente_stand_by')").first
        if activity.present?
          contrato.update(ativo: false, datainativacao: Time.now, usuarioinativacao_id: ((user.id.eql? 2) ? 96 : 97), motivoinativacao:  activity.parameters[:motivo])
        else
          contrato.update(ativo: false, datainativacao: Time.now, usuarioinativacao_id: ((user.id.eql? 2) ? 96 : 97), motivoinativacao:  "Desativado pela conferência de acompanhamentos do business.")
        end
      end
      ''
    rescue
      "Ocorreu um erro ao tentar cancelar contrato do cliente #{acompanhamento.cliente.razao_social}"
    end
  end

  def self.cancelar_contrato_impl(implantacao, user)
    begin
      cliente = Financeiro::ClienteFornecedor.where(cpfcnpj: implantacao.cliente.cnpj).first
      return 'Cliente não localizado no financeiro' if cliente.nil?

      connection = Financeiro::ClienteFornecedor.connection
      contrato = connection.select_all FinanceiroHelper.get_contrato_ativo(cliente.cpfcnpj, true)

      contrato = contrato.first
      return 'Contrato não localizado no financeiro' if contrato.nil?

      contrato = Financeiro::Contrato.find contrato['id'].to_i

      if contrato.experiencia? && !contrato.gerado?
        activity = implantacao.activities.where("key in ('implantacao.desistente_implantacao', 'implantacao.desistente_pre')").first
        if activity.present?
          contrato.update(ativo: false, datainativacao: Time.now, usuarioinativacao_id: ((user.id.eql? 2) ? 96 : 97), motivoinativacao:  activity.parameters[:motivo])
        else
          contrato.update(ativo: false, datainativacao: Time.now, usuarioinativacao_id: ((user.id.eql? 2) ? 96 : 97), motivoinativacao:  "Desativado pela conferência de implantações do business.")
        end
      end
      ''
    rescue
      'Ocorreu um erro ao tentar cancelar contrato'
    end
  end

end


