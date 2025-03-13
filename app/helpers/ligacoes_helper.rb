module LigacoesHelper

  TURNO_1_INICIO = DateTime.now.change(hour: 8, minute: 0, second:0 )
  TURNO_2_INICIO = DateTime.now.change(hour: 12, minute: 0, second:0 )
  TURNO_3_INICIO = DateTime.now.change(hour: 13, minute: 30, second:0 )
  TURNO_4_INICIO = DateTime.now.change(hour: 18, minute: 30, second:0 )
  TURNO_4_FIM = DateTime.now.change(hour: 21, minute: 0, second:0 )
  TURNO_5_INICIO = DateTime.now.change(hour: 8, minute: 0, second:0 )
  TURNO_5_FIM = DateTime.now.change(hour: 16, minute: 15, second:0 )

  TURNO_INICIO_GERAL = DateTime.now.change(hour: 8, minute: 30, second:0 )
  TURNO_FIM_GERAL = DateTime.now.change(hour: 23, minute: 59, second:0 )

  def self.find_next_cliente(empresa_id, user_id)
    cont = 0
    begin

      if empresa_id == 5
        fila = buscar_fila_escritorios empresa_id
      else
        fila = buscar_fila empresa_id
      end

      if fila.present?
        cliente = Cliente.find fila.cliente_id

        verificar_escritorio cliente if empresa_id != 5

        cliente.reload

        if cliente.telefone.present? || cliente.telefone2.present? || (cliente.contatos.first.present? && cliente.contatos.first.cpf.present?) || (cliente.contatos.second.present? && cliente.contatos.second.cpf.present?)
          cliente.em_atendimento = true
          cliente.user_atendimento_id = user_id
          cliente.numero_fila = fila.numero_fila
          cliente.save
          FilaEmpresa.where(cliente_id: cliente.id).destroy_all
        else
          FilaEmpresa.where(cliente_id: cliente.id).destroy_all
          cliente = nil
        end
      else
        cliente = nil
      end

      cont += 1
    end until cliente.present? || cont == 6

    return cliente
  end

  def self.get_clientes_em_massa(empresa_id, user_id)
    begin
      fila = buscar_fila empresa_id

      if fila.present?
        cliente = Cliente.find fila.cliente_id
        cliente.reload

        if (
          (cliente.telefone.present? || cliente.telefone2.present? ) ||
          (cliente.contatos.first.present? && cliente.contatos.first.cpf.present?) ||
          (cliente.contatos.second.present? && cliente.contatos.second.cpf.present?)
        )
          cliente.em_atendimento = true
          cliente.user_atendimento_id = user_id
          cliente.numero_fila = fila.numero_fila
          cliente.save
          FilaEmpresa.where(cliente_id: cliente.id).destroy_all
        else
          FilaEmpresa.where(cliente_id: cliente.id).destroy_all
          cliente = nil
        end

      else
        cliente = nil
      end

      cont += 1
    end until cliente.present? || cont == 6

    return cliente
  end

  def self.buscar_fila(empresa_id)
    dataatual = Time.now

    #SABADO
    if dataatual.wday == 6
      return buscar_fila_sabado empresa_id
    end

    if dataatual.wday == 0
      return nil
    end

    #DIA DE SEMANA DAS 8:30 as 00:00
    if dataatual.between? TURNO_INICIO_GERAL, TURNO_FIM_GERAL
      return buscar_fila_principal empresa_id
    end

    return nil
  end

    def self.buscar_fila_principal(empresa_id, qtd = 1)
      fila = FilaEmpresa.ordem_cliente.where(empresa_id: empresa_id, numero_fila: 0..4).order(:numero_fila)
      fila = fila.first if qtd == 1

      fila
    end

  def self.buscar_fila_sabado(empresa_id)
    fila = FilaEmpresa.ordem_cliente.where(empresa_id: empresa_id, numero_fila: 0).first
    fila = FilaEmpresa.ordem_cliente.where(empresa_id: empresa_id, numero_fila: 1).first unless fila.present?
    fila = FilaEmpresa.ordem_cliente.where(empresa_id: empresa_id, numero_fila: 2).first unless fila.present?
    fila = FilaEmpresa.ordem_cliente.where(empresa_id: empresa_id, numero_fila: 3).first unless fila.present?
    fila = FilaEmpresa.ordem_cliente.where(empresa_id: empresa_id, numero_fila: 4).first unless fila.present?

    return fila
  end

  def self.buscar_fila_escritorios(empresa_id)
    fila = FilaEmpresa.ordem_cliente.where(empresa_id: empresa_id, numero_fila: 0).first
    fila = FilaEmpresa.ordem_cliente.where(empresa_id: empresa_id, numero_fila: 1).first unless fila.present?
    fila = FilaEmpresa.ordem_cliente.where(empresa_id: empresa_id, numero_fila: 2).first unless fila.present?
    fila = FilaEmpresa.ordem_cliente.where(empresa_id: empresa_id, numero_fila: 3).first unless fila.present?
    return fila
  end

  def self.verificar_escritorio(cliente)
    if cliente.escritorio.nil?
      escritorio = Escritorio.telefone(cliente.telefone).first

      cliente.telefone = nil if escritorio.present?
      cliente.escritorio = escritorio if escritorio.present?

      escritorio = Escritorio.telefone(cliente.telefone2).first
      cliente.telefone2 = nil if escritorio.present?
      cliente.escritorio = escritorio if escritorio.present?
      cliente.save
    end
  end

  def self.buscar_numero_fila(empresa_id, numero_fila_atual, cliente)
    if empresa_id == 5
      return 2 if numero_fila_atual == 1
      return 3 if numero_fila_atual == 2
      return 100 if numero_fila_atual == 3
    else
      return 11 if numero_fila_atual == 1
      return 12 if numero_fila_atual == 2
      return 13 if numero_fila_atual == 3
      return 99 if numero_fila_atual == 4
      return 15 if numero_fila_atual == 5

      return numero_fila_atual+100
    end
  end
end
