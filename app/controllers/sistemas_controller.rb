class SistemasController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_filter :authorize_admin, only: [:create, :new, :edit, :update, :index]
  before_action :set_sistema, only: [:edit, :update, :destroy]

  def index
    @sistemas = Sistema.all
  end

  def new
    @sistema = Sistema.new
  end

  def edit
  end

  def create
    @sistema = Sistema.new(sistema_params)
    respond_to do |format|
      if @sistema.save
        flash[:success] = 'Sistema criado com sucesso'
        format.html { redirect_to sistemas_path }
      else
        flash[:error] =  @sistema.errors.full_messages.to_sentence
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @sistema.update(sistema_params)
        flash[:success] = 'Sistema alterado com sucesso'
        format.html { redirect_to sistemas_path }
      else
        flash[:error] =  @sistema.errors.full_messages.to_sentence
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @sistema.destroy
    respond_to do |format|
      format.html { redirect_to sistemas_url }
    end
  end

  def find_sistemas
    @sistemas = Sistema.where("upper(unaccent(nome)) LIKE upper(unaccent('%#{params[:term]}%'))").order(:nome).limit(5)
    respond_to do |format|
      format.html {render nothing: true}
      format.json
    end
  end

  private

    def set_sistema
      @sistema = Sistema.find(params[:id])
    end

    def sistema_params
      params.require(:sistema).permit(:nome, :tempo_inerte)
    end
end
