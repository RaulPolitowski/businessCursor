class LigacaoEmMassa::DistribuicaoUsuarios
  attr_reader :queues, :usuarios, :links

  def initialize(queues, usuarios)
    @queues = queues
    @usuarios = usuarios
    @links = []
  end

  def call
    distribuir_ligacoes
  end

  private

  def distribuir_ligacoes
    qtd_user = usuarios.size
    queues_size = queues.size
    clientes_id = []

    queues.each_slice((queues_size / qtd_user.to_f).ceil).with_index do |queue, index|
      user = usuarios[index % qtd_user]
      queues_size -= queue.size
      telefone_usuario = pegar_telefone(user)
      raise "Não foi encontrado o telefone do usuario #{user}" if telefone_usuario.nil?

      links[index] = {} if links[index].nil?
      links[index] = { "#{telefone_usuario}": [] }
      queue.each do |cliente_id|
        ligacao = criar_ligacao(cliente_id, user)
        clientes_id << cliente_id

        link_wa = criar_link_wa(ligacao)
        links[index][:"#{telefone_usuario}"] << link_wa
        ligacao.link_whats = link_wa
        remover_fila_empresa(cliente_id) if ligacao.save
      end
      atualizar_ligacoes(clientes_id, user)
    end
    links
  end

  def pegar_telefone(user_id)
    User.find(user_id).telefone
  end

  def criar_ligacao(cliente_id, user)
    LigacaoEmMassa::CriarLigacao.new(cliente_id, user).call
  end

  def criar_link_wa(ligacao)
    user = ligacao.user.name
    empresa = ligacao.cliente.razao_social
    telefone_cliente = ligacao.cliente.formato_correto_telefone
    msg = MensagemNotificacao.captacao.mensagem
    msg_completa = AbordagemInicial.ajuste_para_captacao(msg, { user: user, empresa: empresa })
    "https://wa.me/#{telefone_cliente}?text=#{URI.encode(msg_completa += ' ')}"
  end

  def remover_fila_empresa(cliente_id)
    LigacaoEmMassa::RemoverFilaEmpresa.new(cliente_id).call
  end

  def atualizar_ligacoes(clientes_id, user_id)
    LigacaoEmMassa::AtualizarLigacoes.new('ENVIADO WHATSAPP', user_id, clientes_id).call
  end
end