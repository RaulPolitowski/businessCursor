class SatisfacaoController < ApplicationController
    layout "layout_pesquisa_gruber"
    skip_before_action :authenticate_user!, only: [:index, :criar_pesquisa, :buscar_cliente]

    def index
        @cpfcnpj = params[:cpfcnpj] if params[:cpfcnpj].present?
        @set_servicos = Servico.where(ativo: true).order("ordem")
        @set_setores = Setor.where(ativo: true).order("ordem")
    end

    def teste
        GenerateDatabaseEcf.perform_async('ecf')
        render json: {'sucesso':'OK'}.to_json, status: 200
    end

    def criar_pesquisa
        pesquisa = GruberPesquisa.new
        pesquisa.cliente_id = satisfacao_params[:satisfacao_cliente_id]
        pesquisa.cliente_nome = satisfacao_params[:satisfacao_nome]
        pesquisa.cliente_telefone = satisfacao_params[:satisfacao_telefone]
        pesquisa.cliente_email = satisfacao_params[:satisfacao_email]
        pesquisa.instituicao_beneficiente = satisfacao_params[:satisfacao_instituicao_beneficiente]
        pesquisa.tem_avaliacao_negativa = false
        cliente = Financeiro::ClienteFornecedor.where(id: pesquisa.cliente_id).first

        if cliente.present?
            pesquisa.cliente_razao_social = cliente.razaosocial
            pesquisa.cliente_cpf_cnpj = cliente.cpfcnpj

            empresa = Financeiro::Empresa.where(cnpj: cliente.cpfcnpj).first
        end

        pesquisaAnterior = GruberPesquisa.where('cliente_id = ? and created_at > ?', pesquisa.cliente_id, 3.month.ago)

        if pesquisaAnterior.present?
            return render json: "Já existe uma pesquisa lançada nos últimos 3 meses.".to_json, status:422
        end

        connection = Financeiro::ClienteFornecedor.connection

        if params[:satisfacao_servicos].present?
            params[:satisfacao_servicos].each do |serv|
                pesquisa.tem_avaliacao_negativa = true if serv[1]["nota"].to_i < 5
                pesquisa.gruber_pesquisa_respostas.build(servico_id: serv[1]["servico_id"], nota: serv[1]["nota"], motivo: serv[1]["motivo"])
            end
        elsif params[:satisfacao_setores].present?
            params[:satisfacao_setores].each do |setor|
                pesquisa.tem_avaliacao_negativa = true if setor[1]["nota"].to_i < 5
                setor_business = Setor.find setor[1]["setor_id"]
                setor_financeiro = connection.select_all FinanceiroHelper.get_equipe(empresa, setor_business.tipo_setor, pesquisa.cliente_id)
                setor_financeiro = setor_financeiro.first

                pesquisa.gruber_pesquisa_respostas.build(setor_id: setor[1]["setor_id"], nota: setor[1]["nota"], motivo: setor[1]["motivo"],
                                                         setor_financeiro_id: setor_business.setor_financeiro_id.present? ? setor_business.setor_financeiro_id : (setor_financeiro.present? ? setor_financeiro["id"] : nil),
                                                         setor_financeiro_nome: (setor_financeiro.present? ? setor_financeiro["nome"] : nil))
            end
        end

        if pesquisa.save
            render json: "Pesquisa realizada".to_json, status:200
        else
            render json: pesquisa.errors, status: :unprocessable_entity
        end
    end

    def buscar_cliente
        cliente = Financeiro::ClienteFornecedor.where(cpfcnpj: params[:cpfCnpj]).first

        if cliente.nil?
            empresa = Financeiro::Empresa.where("regexp_replace(telefone, '[^0-9]*', '', 'g') = ? or regexp_replace(celular, '[^0-9]*', '', 'g') = ?", params[:cpfCnpj], params[:cpfCnpj]).first
            if empresa.present?
                cliente = Financeiro::ClienteFornecedor.where(cpfcnpj: empresa.cnpj).first
            end
            if cliente.nil?
                cliente= Financeiro::ClienteFornecedor.where("regexp_replace(telefone, '[^0-9]*', '', 'g') = ? or regexp_replace(celular, '[^0-9]*', '', 'g') = ?", params[:cpfCnpj], params[:cpfCnpj]).first
            end
        end

        return render json: "Seu CNPJ não está cadastrado em nossa base de dados. Por favor, digite seu telefone para que possamos entrar em contato assim que possível".to_json, status: 404 if cliente.nil?

        connection = Financeiro::ClienteFornecedor.connection
        honorario = connection.select_all FinanceiroHelper.get_honorario_gruber(cliente.id)

        honorario = honorario.first
        if honorario.present?
            all_setores = connection.select_all FinanceiroHelper.get_all_setores(params[:cpfCnpj], cliente.id)
            render json: {cliente: cliente, temHonorario: true, setores: all_setores.first}.to_json, status:200
        else
            servicos = connection.select_all FinanceiroHelper.get_servicos_feitos(cliente.id)
            if servicos.empty?
                return render json: "Seu CNPJ não está cadastrado em nossa base de dados. Por favor, digite seu telefone para que possamos entrar em contato assim que possível".to_json, status: 404 if cliente.nil?
            end
            render json: {cliente: cliente, temHonorario: false, servicos_feitos: servicos}.to_json, status:200
        end
    end

    def satisfacao_params
        params.permit(:satisfacao_cliente_id, :satisfacao_nome, :satisfacao_telefone, :satisfacao_email, :satisfacao_instituicao_beneficiente)
    end
end
