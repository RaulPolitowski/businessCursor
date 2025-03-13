class Pesquisa < ActiveRecord::Base
  belongs_to :cliente
  belongs_to :empresa
  belongs_to :user
  has_many :pergunta_pesquisa_respostas

  def self.registrar_pesquisas
    verificar_pesquisas_pendentes()
    verificar_novas_pesquisas();
    #quando for alterado a regra de periodo pra proxima pesquisa executar função abaixo pra refazer todas as datas
    #recalcular_data_prox_pesquisa();
  end

  def self.recalcular_data_prox_pesquisa
    pesquisas = Pesquisa.where('data_pesquisa is not null').order('cliente_id desc')
    ultimo_cliente = 0
    #atualizar aproxima pesquisa do cliente
    pesquisas.each do |item|
      if item.cliente_id == ultimo_cliente
        next        
      else
        cliente = item.cliente
        cliente.proxima_pesquisa = item.data + 1.year
        ultimo_cliente = cliente.id
        cliente.save
      end
    end
    
    #deletar as pesquisas ainda não realizadas
    Pesquisa.where(data_pesquisa: nil).delete_all
    #recriar as pesquisas novamente
    recriar_pesquisas()
  end

  def self.verificar_pesquisas_pendentes
    pesquisas = Pesquisa.where(data_pesquisa: nil)

    ids = Array.new
    pesquisas.each do |pesquisa|
      cliente = pesquisa.cliente
      apiCliente = Api::Company.find_by_cnpj cliente.cnpj

      if apiCliente.nil? || (apiCliente.system.present? &&  (apiCliente.system.upcase.include? 'FISCAL'))
        ids << pesquisa.id
        next
      end

      #Busca cliente no financeiro, se nao encontrar..nao continua.
      clienteFi = Financeiro::ClienteFornecedor.where(cpfcnpj: cliente.cnpj).first
      if clienteFi.nil?
        ids << pesquisa.id
        next 
      end

      #Busca o honorario, se nao encontrar..nao continua.
      honorario = Financeiro::HonorarioMensal.where(clifor_id: clienteFi.id, tipo_id: 16, ativo: true).first
      if honorario.nil?
        ids << pesquisa.id
        next 
      end

      nova = honorario.datavencimento > (Time.now - 90.days)
      dias_sem_acesso = apiCliente.count_days_dont_access
      last_login = apiCliente.last_login ||  apiCliente.created_at

      connection = Financeiro::HonorarioMensal.connection
      lista = connection.select_all FinanceiroHelper.get_debitos_pendentes clienteFi.id

      debitoVencido =  lista[0]['count'].to_i > 0
      statusHonorario = honorario.situacao
      bloqueado = honorario.situacao.eql? 'BLOQUEADO'

      pesquisa.update(ultimo_login: last_login, sistema: Cliente.human_system(apiCliente.system_client), versao: apiCliente.version, nova: nova, tempo: dias_sem_acesso,
                      situacao_financeira: statusHonorario, com_pendencia_financeira: debitoVencido, bloqueado: bloqueado)
    end
    Pesquisa.where(id: ids).delete_all
  end

  def self.verificar_novas_pesquisas
    clientes = Cliente.where(proxima_pesquisa: Time.now.to_date)

    clientes.each do |cliente|
      apiCliente = Api::Company.find_by_cnpj cliente.cnpj
      
      if apiCliente.nil? || (apiCliente.system.present? && ((apiCliente.system.upcase.include? 'ATHUS') || (apiCliente.system.upcase.include? 'FISCAL')))
        next
      end

      #Se cliente tem implantacao e nao acompanhamento nao continua
      next if cliente.implantacao.present? && cliente.acompanhamento.nil?
      #Se cliente em acompanhamento não concluido nao continua
      next if cliente.acompanhamento.present? && !([3,4,5].include? cliente.acompanhamento.status)

      #Busca cliente no financeiro, se nao encontrar..nao continua.
      clienteFi = Financeiro::ClienteFornecedor.where(cpfcnpj: cliente.cnpj).first
      next if clienteFi.nil?

      #Busca o honorario, se nao encontrar..nao continua.
      honorario = Financeiro::HonorarioMensal.where(clifor_id: clienteFi.id, tipo_id: 16, ativo: true).first
      next if honorario.nil?

      nova = honorario.datavencimento > (Time.now - 90.days)
      dias_sem_acesso = apiCliente.count_days_dont_access
      last_login = apiCliente.last_login ||  apiCliente.created_at

      connection = Financeiro::HonorarioMensal.connection
      lista = connection.select_all FinanceiroHelper.get_debitos_pendentes clienteFi.id

      debitoVencido =  lista[0]['count'].to_i > 0
      statusHonorario = honorario.situacao
      bloqueado = honorario.situacao.eql? 'BLOQUEADO'

      pesquisa = Pesquisa.where(data: cliente.proxima_pesquisa, cliente: cliente, empresa: cliente.empresa, data_pesquisa: nil).first
      if pesquisa.present?
        pesquisa.update(ultimo_login: last_login, sistema: Cliente.human_system(apiCliente.system_client), versao: apiCliente.version, nova: nova, tempo: dias_sem_acesso,
                        situacao_financeira: statusHonorario, com_pendencia_financeira: debitoVencido, bloqueado: bloqueado)
      else
        Pesquisa.create(data: cliente.proxima_pesquisa, cliente: cliente, empresa: cliente.empresa, ultimo_login: last_login,
                        sistema: Cliente.human_system(apiCliente.system_client), versao: apiCliente.version, nova: nova,  tempo: dias_sem_acesso,
                        situacao_financeira: statusHonorario, com_pendencia_financeira: debitoVencido, bloqueado: bloqueado)
      end
    end
  end

  def self.recriar_pesquisas
    clientes = Cliente.where('proxima_pesquisa <= current_date')
    clientes.each do |cliente|
      apiCliente = Api::Company.find_by_cnpj cliente.cnpj
      
      if apiCliente.nil? || (apiCliente.system.present? && ((apiCliente.system.upcase.include? 'ATHUS') || (apiCliente.system.upcase.include? 'FISCAL')))
        next
      end

      #Se cliente tem implantacao e nao acompanhamento nao continua
      next if cliente.implantacao.present? && cliente.acompanhamento.nil?
      #Se cliente em acompanhamento não concluido nao continua
      next if cliente.acompanhamento.present? && !([3,4,5].include? cliente.acompanhamento.status)

      #Busca cliente no financeiro, se nao encontrar..nao continua.
      clienteFi = Financeiro::ClienteFornecedor.where(cpfcnpj: cliente.cnpj).first
      next if clienteFi.nil?

      #Busca o honorario, se nao encontrar..nao continua.
      honorario = Financeiro::HonorarioMensal.where(clifor_id: clienteFi.id, tipo_id: 16, ativo: true).first
      next if honorario.nil?

      nova = honorario.datavencimento > (Time.now - 90.days)
      dias_sem_acesso = apiCliente.count_days_dont_access
      last_login = apiCliente.last_login ||  apiCliente.created_at

      connection = Financeiro::HonorarioMensal.connection
      lista = connection.select_all FinanceiroHelper.get_debitos_pendentes clienteFi.id

      debitoVencido =  lista[0]['count'].to_i > 0
      statusHonorario = honorario.situacao
      bloqueado = honorario.situacao.eql? 'BLOQUEADO'

      pesquisa = Pesquisa.where(data: cliente.proxima_pesquisa, cliente: cliente, empresa: cliente.empresa, data_pesquisa: nil).first
      if pesquisa.present?
        pesquisa.update(ultimo_login: last_login, sistema: Cliente.human_system(apiCliente.system_client), versao: apiCliente.version, nova: nova, tempo: dias_sem_acesso,
                        situacao_financeira: statusHonorario, com_pendencia_financeira: debitoVencido, bloqueado: bloqueado)
      else
        Pesquisa.create(data: cliente.proxima_pesquisa, cliente: cliente, empresa: cliente.empresa, ultimo_login: last_login,
                        sistema: Cliente.human_system(apiCliente.system_client), versao: apiCliente.version, nova: nova,  tempo: dias_sem_acesso,
                        situacao_financeira: statusHonorario, com_pendencia_financeira: debitoVencido, bloqueado: bloqueado)
      end
    end
  end
end