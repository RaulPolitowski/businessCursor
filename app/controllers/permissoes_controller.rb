class PermissoesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_filter :authorize_admin, only: [:create, :new, :edit, :update, :index]
  before_action :set_permissao, only: [:edit, :update, :destroy]

  def index
    @permissoes = Permissao.all
  end

  def new
    @permissao = Permissao.new
  end

  def edit
  end

  def create
    @permissao = Permissao.new(permissao_params)

    respond_to do |format|
      if @permissao.save
        flash[:success] = 'Permissão criado com sucesso'
        format.html { redirect_to permissoes_path }
      else
        flash[:error] =  @permissao.errors.full_messages.to_sentence
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @permissao.update(permissao_params)
        flash[:success] = 'Permissão alterado com sucesso'
        format.html { redirect_to permissoes_path }
      else
        flash[:error] =  @pacote.errors.full_messages.to_sentence
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @permissao.destroy
    respond_to do |format|
      format.html { redirect_to permissoes_url }
      format.json { head :no_content }
    end
  end

  private
    def set_permissao
      @permissao = Permissao.find(params[:id])
    end

    def permissao_params
      params.require(:permissao).permit(:descricao, :agenda)
    end
end
