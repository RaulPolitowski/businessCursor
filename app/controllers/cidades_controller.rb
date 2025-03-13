class CidadesController < ApplicationController
  # skip_before_action :verify_authenticity_token
  before_action :set_cidade, only: [:blacklist, :preferencial]

  def index
    @cidades = Cidade.where(estado: current_empresa.cidade.estado).order(:nome)
  end

  def find_by_estado
    @q = Cidade.search params[:q]
    @cidades = @q.result(distinct: true).order(:nome)

    render json: @cidades, status: 200
  end

  def blacklist
    @cidade.blacklist = !@cidade.blacklist

    @cidade.save!

    flash[:success] = "Cidade #{ @cidade.blacklist ? "inserida na" : "retirada da" } blacklist com sucesso"
    redirect_to :back
  end

  def preferencial
    @cidade.preferencial = !@cidade.preferencial

    @cidade.save!

    flash[:success] = "Cidade #{ @cidade.preferencial ? "inserida na" : "retirada da" } lista preferencial com sucesso"
    redirect_to :back
  end

  def find_cidades
    @cidades = Cidade.select("cidades.*, estados.sigla").joins(:estado).where("upper(unaccent(cidades.nome)) LIKE upper((?)) OR cidades.id::varchar = ?", "%#{params[:term]}%", params[:term]).order(:nome).limit(5)
    render json: @cidades
  end

  def find_cidades_estado_financeiro
    @cidades = Financeiro::Cidade.where(estado_id: params[:estado])
    render json: @cidades, each_serializer: Financeiro::CidadeFinanceiroShortSerializer
  end


  def cidades_buscar
    cep = Importacao.getResponseCep params[:cep]
        unless cep['uf'].present?
          estado = Estado.find_by_sigla cep['estado']
          municipio = Cidade.where(" upper(unaccent(nome)) = upper(unaccent(?)) and estado_id = ?", cep['cidade'].upcase, estado.id ).limit(1).first

          if municipio.nil?
            municipio = Cidade.create(nome: I18n.transliterate(cep['cidade'].upcase), estado_id: estado.id, codigo: cep['cidade_info']['codigo_ibge'])
          end
        else
          estado = Estado.find_by_sigla cep['uf']
          municipio = Cidade.where(" upper(unaccent(nome)) = upper(unaccent(?)) and estado_id = ?", cep['localidade'].upcase, estado.id ).limit(1).first

          if municipio.nil?
            municipio = Cidade.create(nome: I18n.transliterate(cep['municipio'].upcase), estado_id: estado.id, codigo: nil)
          end
        end
      respond_to do |format|
        format.html
        format.json { render json: municipio, status: 200 }
      end
   end

  private

  def set_cidade
    @cidade = Cidade.find(params[:id])
  end


end
