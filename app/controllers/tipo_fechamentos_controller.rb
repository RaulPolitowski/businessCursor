class TipoFechamentosController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_filter :authorize_admin, only: [:create, :new, :edit, :update, :index]
  before_action :set_tipo_fechamento, only: [:edit, :update, :destroy]

  def index
    @tipo_fechamentos = TipoFechamento.all
  end

  def new
    @tipo_fechamento = TipoFechamento.new
  end

  def edit
  end

  def create
    @tipo_fechamento = TipoFechamento.new(tipo_fechamento_params)

    respond_to do |format|
      if @tipo_fechamento.save
        flash[:success] = 'Tipo Fechamento criado com sucesso'
        format.html { redirect_to tipo_fechamentos_path }
      else
        flash[:error] =  @tipo_fechamento.errors.full_messages.to_sentence
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @tipo_fechamento.update(tipo_fechamento_params)
        flash[:success] = 'Tipo Fechamento alterado com sucesso'
        format.html { redirect_to tipo_fechamentos_path }
      else
        flash[:error] =  @tipo_fechamento.errors.full_messages.to_sentence
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @tipo_fechamento.destroy
    respond_to do |format|
      format.html { redirect_to tipo_fechamentos_url }
      format.json { head :no_content }
    end
  end

  private
    def set_tipo_fechamento
      @tipo_fechamento = TipoFechamento.find(params[:id])
    end

    def tipo_fechamento_params
      params.require(:tipo_fechamento).permit(:descricao)
    end
end
