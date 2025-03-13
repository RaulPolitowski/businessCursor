class CnaesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_cnae, only: [:blacklist, :preferencial, :update, :destroy]

  def index
    @q = Cnae.search params[:q]

    @cnaes = @q.result(distinct: true)
    respond_to do |format|
      format.html
      format.json { render json: @cnaes, status: 200 }
    end
  end

  def new
    @cnae = Cnae.new
  end

  def create
    @cnae = Cnae.new(cnae_params)

    respond_to do |format|
      if @cnae.save
        flash[:success] = 'Cnae criado com sucesso'
        format.html { redirect_to cnaes_path }
      else
        flash[:error] =  @cnae.errors.full_messages.to_sentence
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @cnae.update(cnae_params)
        format.html { redirect_to :back }
        format.json { render json: @cnae, status: 200 }
      else
        format.json { render json: { errors: @cnae.errors }, status: 422 }
      end
    end
  end

  def blacklist
    @cnae.blacklist = !@cnae.blacklist

    @cnae.save!

    flash[:success] = 'Cnae alterado com sucesso'
    redirect_to :back
  end

  def preferencial
    @cnae.preferencial = !@cnae.preferencial

    @cnae.save!

    flash[:success] = 'Cnae alterado com sucesso'
    redirect_to :back
  end

  def find_cnaes
    @cnaes = Cnae.where("upper(unaccent(descricao)) LIKE upper(unaccent(?)) OR codigo LIKE  ?",  "%#{params[:term]}%",  "%#{params[:term]}%").order(:descricao).limit(5)
    respond_to do |format|
      format.html { render nothing: true }
      format.json
    end
  end

  def top_vendidos
    connection = ActiveRecord::Base.connection
    cnaes = connection.select_all FilaEmpresasHelper.get_top_cnaes(params[:empresa_id], 10)

    render json: cnaes, status: 200
  end

  private

  def set_cnae
    @cnae = Cnae.find(params[:id])
  end

  def cnae_params
    params.require(:cnae).permit(:codigo, :descricao, :preferencial, :blacklist)
  end

end
