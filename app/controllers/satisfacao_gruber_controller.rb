class SatisfacaoGruberController < ApplicationController
    skip_before_action :authenticate_user!

    def index
        @q = GruberPesquisa.search params[:q]

        if not params[:q]
            @q.created_at_gteq ||= Date.today.beginning_of_week().strftime("%d/%m/%Y")
            @q.created_at_lteq ||= Date.today.end_of_week().strftime("%d/%m/%Y")
        end

        @pesquisas = @q.result(distinct: true).order(created_at: :desc)
    end

    def dashboard
        ultima_pesquisa_setor = GruberPesquisa.get_ultima_pesquisa_setor
        @ultima_nota_contabil  = ultima_pesquisa_setor.gruber_pesquisa_respostas.joins(:setor).where("setores.tipo_setor = 'CONTABIL'").first
        @ultima_nota_rh  = ultima_pesquisa_setor.gruber_pesquisa_respostas.joins(:setor).where("setores.tipo_setor = 'RH'").first
        @ultima_nota_externo  = ultima_pesquisa_setor.gruber_pesquisa_respostas.joins(:setor).where("setores.tipo_setor = 'EXTERNO'").first
        @ultima_nota_financeiro  = ultima_pesquisa_setor.gruber_pesquisa_respostas.joins(:setor).where("setores.tipo_setor = 'FINANCEIRO'").first
        @ultima_nota_atendimento  = ultima_pesquisa_setor.gruber_pesquisa_respostas.joins(:setor).where("setores.tipo_setor = 'ATENDIMENTO'").first

        penultima_pesquisa_setor = GruberPesquisa.get_penultima_pesquisa_setor
        @penultima_nota_contabil  = penultima_pesquisa_setor.gruber_pesquisa_respostas.joins(:setor).where("setores.tipo_setor = 'CONTABIL'").first
        @penultima_nota_rh  = penultima_pesquisa_setor.gruber_pesquisa_respostas.joins(:setor).where("setores.tipo_setor = 'RH'").first
        @penultima_nota_externo  = penultima_pesquisa_setor.gruber_pesquisa_respostas.joins(:setor).where("setores.tipo_setor = 'EXTERNO'").first
        @penultima_nota_financeiro  = penultima_pesquisa_setor.gruber_pesquisa_respostas.joins(:setor).where("setores.tipo_setor = 'FINANCEIRO'").first
        @penultima_nota_atendimento  = penultima_pesquisa_setor.gruber_pesquisa_respostas.joins(:setor).where("setores.tipo_setor = 'ATENDIMENTO'").first
    end

    def media_setores_rh
        media_setores_rh = GruberPesquisa.get_media_setores_rh params[:data_inicial], params[:data_final]
        render json: media_setores_rh, status: 200
    end

    def media_setores_externo
        media_setores_externo = GruberPesquisa.get_media_setores_externo params[:data_inicial], params[:data_final]
        render json: media_setores_externo, status: 200
    end

    def media_setores_contabil
        media_setores_contabil = GruberPesquisa.get_media_setores_contabil params[:data_inicial], params[:data_final]
        render json: media_setores_contabil, status: 200
    end

    def media_setores
        media_setores = GruberPesquisa.get_media_setores params[:data_inicial], params[:data_final]
        render json: media_setores, status: 200
    end

    def media_servicos
        media_servicos = GruberPesquisa.get_media_servicos params[:data_inicial], params[:data_final]
        render json: media_servicos, status: 200
    end

    def media_setores_financeiro
        media_setores_financeiro = GruberPesquisa.get_media_setor_financeiro params[:data_inicial], params[:data_final]
        render json: media_setores_financeiro, status: 200
    end

    def media_setores_atendimento
        media_setores_atendimento = GruberPesquisa.get_media_setor_atendimento params[:data_inicial], params[:data_final]
        render json: media_setores_atendimento, status: 200
    end

    def show
        @pesquisa = GruberPesquisa.find params[:id]

        render json: @pesquisa
    end

end
