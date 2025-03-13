class PeriodoInerte < ActiveRecord::Base
  belongs_to :cliente
  belongs_to :empresa
  belongs_to :user_feedback, class_name: 'User'
  belongs_to :user_avaliacao, class_name: 'User'

  def self.verificar_empresas_inertes
    response = RestClient::Request.execute(method: :get,  url: "http://api.gtech.site/companies?q[count_days_access_gt]=3&q[active_eq]=true",
                                           headers: { Accept: 'application/vnd.germantech.v2',
                                                      Authorization: Digest::MD5.hexdigest(Time.new.strftime('%Y11586637000128%m%-d')) },
                                           timeout: 300, open_timeout: 300, read_timeout: 300)
    resposta = JSON.parse(response)

    ids = Array.new
    resposta.each do |company|
      if company['system'].present? && ((company['system'].upcase.include? 'ATHUS') || (company['system'].upcase.include? 'VENDAS'))
        next
      end

      #se VErsao for entre 4.95.1 e 4.101.0 ignora, pois atividades nao eram registradas
      if company['version'].present?
        vers = company['version'].split('.')
        versaoInt = (vers[0] + vers[1] + vers[2]).to_i
        next if versaoInt > 4951 && versaoInt < 41010
      end

      cliente = Cliente.find_by_cnpj company['cnpj']
      if cliente.nil?
        cliente = Cliente.create(cnpj: company['cnpj'], empresa_id: 1)
      end

      if cliente.razao_social.nil?
        Importacao.importar_dados_receita cliente
        cliente.reload

        if cliente.cidade.present? && (cliente.cidade.estado.sigla.eql? 'SP')
          cliente.update(empresa_id: 2)
        end

        #se continua sem razao é pq é CNPJ invalido
        next if cliente.razao_social.nil?
      end

      sistema  = Sistema.find 4 if company['system_client'].present? && (company['system_client'].upcase.include? "GOURMET")
      sistema  = Sistema.find 1 if company['system_client'].present? && (company['system_client'].upcase.include? "MANAGER")
      sistema  = Sistema.find 3 if company['system_client'].present? && (company['system_client'].upcase.include? "EMISSOR")
      sistema  = Sistema.find 2 if company['system_client'].present? && (company['system_client'].upcase.include? "LIGHT")
      parametro = Parametro.find_by_empresa_id cliente.empresa_id

      #Se cliente tem implantacao e nao acompanhamento nao continua
      next if cliente.implantacao.present? && cliente.acompanhamento.nil?
      #Se cliente em acompanhamento não concluido nao continua
      next if cliente.acompanhamento.present? && !([3,4,5].include? cliente.acompanhamento.status)
      #Se data sem inerte estiver informada e for maior q data atual..nao continua.
      next if cliente.sem_inerte_ate.present? && cliente.sem_inerte_ate > Time.now

      #Busca cliente no financeiro, se nao encontrar..nao continua.
      clienteFi = Financeiro::ClienteFornecedor.where(cpfcnpj: company['cnpj']).first
      next if clienteFi.nil?

      #Busca o honorario, se nao encontrar..nao continua.
      honorario = Financeiro::HonorarioMensal.where(clifor_id: clienteFi.id, tipo_id: 16, ativo: true).first
      #contrato = Financeiro::Contrato.where(cliente_id: clienteFi.id, ativo: true)
      next if honorario.nil?

      nova = honorario.datavencimento > (Time.now - 90.days)

      dias_sem_acesso = company['count_days_dont_access']

      if company['last_login'].present?
        last_login = Time.parse company['last_login']
      else
        last_login = Time.parse(company['created_at'])
      end

      next if cliente.present? && cliente.tempo_inerte.present? && dias_sem_acesso < cliente.tempo_inerte
      next if sistema.present? && sistema.tempo_inerte.present? && dias_sem_acesso < sistema.tempo_inerte
      next if parametro.present? && parametro.tempo_inerte.present? && dias_sem_acesso < parametro.tempo_inerte
      next if dias_sem_acesso < 3

      connection = Financeiro::HonorarioMensal.connection
      lista = connection.select_all FinanceiroHelper.get_debitos_pendentes clienteFi.id

      debitoVencido =  lista[0]['count'].to_i > 0
      statusHonorario = honorario.situacao
      bloqueado = !(honorario.situacao.eql? 'NORMAL')

      #Se não ter débitos vencidos e estar mais de 90 dias sem uso, ignora
      if !debitoVencido && dias_sem_acesso > 90
        next
      end

      periodo = PeriodoInerte.where(cliente: cliente, empresa: cliente.empresa).where('data_feedback is null').order(data: :desc).first
      if periodo.present?
        periodo.update(tempo_inerte: dias_sem_acesso, last_login: last_login, sistema: Cliente.human_system(company['system_client']),
                       versao: company['version'], nova: nova, situacao_financeira: statusHonorario, com_pendencia_financeira: debitoVencido,
                        bloqueado: bloqueado)
      else
        periodo = PeriodoInerte.new(cliente: cliente, empresa: cliente.empresa, data: Time.now,
                             tempo_inerte: dias_sem_acesso, last_login: last_login,
                              sistema: Cliente.human_system(company['system_client']), versao: company['version'],
                                    nova: nova, situacao_financeira: statusHonorario, com_pendencia_financeira: debitoVencido, bloqueado: bloqueado)
        periodo.save
      end
      ids << periodo.id
    end
    #Deleta todos os periodos q nao passaram pelas validacoes
    PeriodoInerte.where('data_feedback is null').where.not(id: ids).delete_all
  end

end
