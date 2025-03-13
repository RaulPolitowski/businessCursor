class TipoAgendamentosController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_filter :authorize_admin, only: [:create, :new, :edit, :update, :index]
  before_action :set_tipo_agendamento, only: [:edit, :update, :destroy, :desativar]

  def index
    @tipo_agendamentos = TipoAgendamento.where(ativo: true)
    @tipo_agendamentos_inativos = TipoAgendamento.where(ativo: false)
  end

  def new
    @tipo_agendamento = TipoAgendamento.new
  end

  def edit
  end

  def create
    @tipo_agendamento = TipoAgendamento.new(tipo_agendamento_params)
    #@tipo_agendamento.empresa = current_empresa
    respond_to do |format|
      if @tipo_agendamento.save
        flash[:success] = 'Tipo Agendamento criado com sucesso'
        format.html { redirect_to tipo_agendamentos_path }
      else
        flash[:error] =  @tipo_agendamento.errors.full_messages.to_sentence
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @tipo_agendamento.update(tipo_agendamento_params)
        flash[:success] = 'Tipo Agendamento alterado com sucesso'
        format.html { redirect_to tipo_agendamentos_path }
      else
        flash[:error] =  @tipo_agendamento.errors.full_messages.to_sentence
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @tipo_agendamento.destroy
    respond_to do |format|
      format.html { redirect_to tipo_agendamentos_url }
    end
  end

  def desativar
    @tipo_agendamento.ativo = !@tipo_agendamento.ativo
    @tipo_agendamento.save

    redirect_to :back
  end

  private
    def set_tipo_agendamento
      @tipo_agendamento = TipoAgendamento.find(params[:id])
    end

    def tipo_agendamento_params
      params.require(:tipo_agendamento).permit(:descricao, :cor)
    end
end
