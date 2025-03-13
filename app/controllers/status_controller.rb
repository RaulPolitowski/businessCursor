class StatusController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_filter :authorize_admin, only: [:create, :new, :edit, :update, :index]
    before_action :set_status, only: [:edit, :update, :destroy, :show]
    authorize_resource

    def index
      @status = Status.all
    end

    def new
      @status = Status.new
    end

    def show
      render json: @status
    end

    def edit
    end

    def create
      @status = Status.new(status_params)
      respond_to do |format|
        if @status.save
          flash[:success] = 'Status criado com sucesso'
          format.html { redirect_to status_index_path }
        else
          flash[:error] =  @status.errors.full_messages.to_sentence
          format.html { render action: 'new' }
        end
      end
    end

    def update
      respond_to do |format|
        if @status.update(status_params)
          flash[:success] = 'Status alterado com sucesso'
          format.html { redirect_to status_index_path }
        else
          flash[:error] =  @status.errors.full_messages.to_sentence
          format.html { render action: 'edit' }
        end
      end
    end

    def destroy
      @status.destroy
      respond_to do |format|
        format.html { redirect_to status_index_path }
      end
    end

    def get_status_cliente
      cliente = Cliente.find params[:cliente_id]

      status = Status.buscar_status_by_status cliente.status_id

      render json: status
    end

    private
    def set_status
      @status = Status.find(params[:id])
    end

    def status_params
      params.require(:status).permit(:descricao, :tipo_status, :fechamento, :status_empresa)
    end
  end
