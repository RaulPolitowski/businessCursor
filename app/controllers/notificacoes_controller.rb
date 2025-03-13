class NotificacoesController < ApplicationController

  def contador
    if params[:tipo].present?
      qtd = Notificacao.where.not(tipo: ['IMPLANTACAO', 'IMPLANTACAO_ATRASADA_20', 'IMPLANTACAO_ATRASADA_30', 'IMPLANTACAO_ALTERACAO', 'DESATIVACAO', 'IMPLANTACAO', 'ARQUIVO_RETORNO', 'CENTRO_DISTRIBUICAO']).where(tipo: params[:tipo]).notificacoes_user(current_user).empresa(current_empresa).nao_lidas.count

      if (params[:tipo].eql? 'FECHAMENTO')
        qtd += Notificacao.notificacoes_user(current_user).where("tipo = 'FECHAMENTO' and empresa_id != ?", current_empresa.id).nao_lidas.count
      end
    else      
      qtd = Notificacao.where.not(tipo: ['IMPLANTACAO', 'IMPLANTACAO_ATRASADA_20', 'IMPLANTACAO_ATRASADA_30', 'IMPLANTACAO_ALTERACAO', 'FECHAMENTO', 'EFETIVACAO', 'DESATIVACAO', 'IMPLANTACAO', 'ARQUIVO_RETORNO']).notificacoes_user(current_user).empresa(current_empresa).nao_lidas.count
    end

    if params[:tipo] == 'DESATIVACAO'
      qtd = Notificacao.where(tipo: 'DESATIVACAO').notificacoes_user(current_user).nao_lidas.count     
    end

    if params[:tipo] == 'IMPLANTACAO'
      qtd = Notificacao.where(tipo: 'IMPLANTACAO').notificacoes_user(current_user).nao_lidas.count     
    end

    if params[:tipo] == 'ARQUIVO_RETORNO'
      qtd = Notificacao.where(tipo: 'ARQUIVO_RETORNO').notificacoes_user(current_user).nao_lidas.count
    end

    if params[:tipo] == 'SOLICITACAO_DESATIVACAO'
      qtd = Notificacao.where(tipo: 'SOLICITACAO_DESATIVACAO').notificacoes_user(current_user).nao_lidas.count
    end

    if params[:tipo] == 'CENTRO_DISTRIBUICAO'
      qtd = Notificacao.where(tipo: 'CENTRO_DISTRIBUICAO').notificacoes_user(current_user).nao_lidas.count
    end

    if params[:tipo] == 'NUMERO_DESCONECTADO'
      qtd = Notificacao.where(tipo: 'NUMERO_DESCONECTADO').notificacoes_user(current_user).nao_lidas.count
    end


    render json: qtd.to_json
  end

  def novas_notificacoes
    aux =Notificacao.where.not(tipo: ['IMPLANTACAO', 'IMPLANTACAO_ATRASADA_20', 'IMPLANTACAO_ATRASADA_30', 'IMPLANTACAO_ALTERACAO']).notificacoes_user(current_user).empresa(current_empresa).nao_lidas.nao_visualizadas

    notificacoes = Array.new

    aux.each do |noti|
      notificacoes << noti
    end

    aux = Notificacao.notificacoes_user(current_user).where("tipo = 'FECHAMENTO' and empresa_id != ?", current_empresa.id).nao_lidas.nao_visualizadas

    aux.each do |noti|
      notificacoes << noti
    end

    notificacoes.each do |noti|
      noti.visualizada = true
      noti.save
    end

    render json: notificacoes
  end

  def get_notificacoes
    if params[:tipo].present?
      aux = Notificacao.where.not(tipo: ['IMPLANTACAO', 'IMPLANTACAO_ATRASADA_20', 'IMPLANTACAO_ATRASADA_30', 'IMPLANTACAO_ALTERACAO', 'DESATIVACAO', 'IMPLANTACAO']).where(tipo: params[:tipo]).notificacoes_user(current_user).empresa(current_empresa).nao_lidas
      if (params[:tipo].eql? 'FECHAMENTO')
        fech = Notificacao.notificacoes_user(current_user).where("tipo = 'FECHAMENTO' and empresa_id != ?", current_empresa.id).nao_lidas
      end
    else
      aux = Notificacao.where.not(tipo: ['IMPLANTACAO', 'IMPLANTACAO_ATRASADA_20', 'IMPLANTACAO_ATRASADA_30', 'IMPLANTACAO_ALTERACAO', 'FECHAMENTO', 'EFETIVACAO', 'DESATIVACAO', 'IMPLANTACAO']).notificacoes_user(current_user).empresa(current_empresa).nao_lidas
    end

    if params[:tipo] == 'DESATIVACAO'
      aux = Notificacao.where(tipo: 'DESATIVACAO').notificacoes_user(current_user).nao_lidas     
    end

    if params[:tipo] == 'SOLICITACAO_DESATIVACAO'
      aux = Notificacao.where(tipo: 'SOLICITACAO_DESATIVACAO').notificacoes_user(current_user).nao_lidas
    end

    if params[:tipo] == 'IMPLANTACAO'
      aux = Notificacao.where(tipo: 'IMPLANTACAO').notificacoes_user(current_user).nao_lidas     
    end

    if params[:tipo] == 'ARQUIVO_RETORNO'
        aux = Notificacao.where(tipo: 'ARQUIVO_RETORNO').notificacoes_user(current_user).nao_lidas
    end

    if params[:tipo] == 'CENTRO_DISTRIBUICAO'
        aux = Notificacao.where(tipo: 'CENTRO_DISTRIBUICAO').notificacoes_user(current_user).nao_lidas
    end

    if params[:tipo] == 'NUMERO_DESCONECTADO'
        aux = Notificacao.where(tipo: 'NUMERO_DESCONECTADO').notificacoes_user(current_user).nao_lidas
    end

    notificacoes = Array.new
    aux.each do |noti|
      notificacoes << noti
    end

    if fech.present?
      fech.each do |noti|
        notificacoes << noti
      end
    end

    notificacoes = notificacoes.sort_by(&:data_hora).reverse

    render json: notificacoes[0..4]
  end

  def notificacoes_nao_lidas
    Notificacao.processar_notificacoes

    notificacoes = Notificacao.chrome.notificacoes_user(current_user).empresa(current_empresa).nao_lidas.order(data_hora: :asc).limit(3)

    render json: notificacoes
  end

  def marcar_lido
    @notificacao = Notificacao.find params[:notificacao_id]
    @notificacao.update(lido: true)

    render json: @notificacao
  end

  def criar_notificacao_arquivo_retorno
    Notificacao.criar_notificacao_arquivo_retorno(params[:empresa_desc], params[:empresa_id])

    render nothing: true, status: 200
  end
end
