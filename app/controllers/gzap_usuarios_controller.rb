class GzapUsuariosController < ApplicationController
  before_action :set_gzap_usuario, only: [:show, :edit, :update, :destroy, :ativar_desativar]
  before_action :cast_destinatarios_to_array, only: [:update, :create]
  before_action :format_string, only: [:edit]

  def index
    gzap_usuarios = GzapUsuario.all
    @gzap_usuarios_ativos = gzap_usuarios.where ativo: true
    @gzap_usuarios_desativados = gzap_usuarios.where ativo: false
  end

  def show
  end

  def new
    @gzap_usuario = GzapUsuario.new
  end

  def edit
  end

  def create
    @gzap_usuario = GzapUsuario.new(gzap_usuario_params)

    respond_to do |format|
      if @gzap_usuario.save
        format.html { redirect_to gzap_usuarios_url, notice: 'Novo usuário foi criado com sucesso!' }
        format.json { render action: 'show', status: :created, location: @gzap_usuario }
      else
        format.html { render action: 'new' }
        format.json { render json: @gzap_usuario.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    
    respond_to do |format|
      
      if @gzap_usuario.update!(gzap_usuario_params)
        format.html { redirect_to gzap_usuarios_url, notice: 'Usuário editado com sucesso!' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @gzap_usuario.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @gzap_usuario.destroy
    respond_to do |format|
      format.html { redirect_to gzap_usuarios_url }
      format.json { head :no_content }
    end
  end

  def ativar_desativar
    respond_to do |format|
      if @gzap_usuario.update!(ativo: !@gzap_usuario.ativo)
        message = @gzap_usuario.ativo? ? "Usuário Gzap foi ativado com sucesso!" : "Usuário Gzap desativado com sucesso!"
        format.html { redirect_to gzap_usuarios_path, notice: message }
        format.json { head :no_content }
      else
        format.html { render action: 'index' }
        format.json { render json: @gzap_usuario.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def format_string
    @gzap_usuario.destinatarios = @gzap_usuario.destinatarios.join(', ')
  end

  def set_gzap_usuario
    @gzap_usuario = GzapUsuario.find(params[:id])
  end

  def gzap_usuario_params
    params.require(:gzap_usuario).permit(:user_id, :name, destinatarios: [])
  end

  def cast_destinatarios_to_array
    params[:gzap_usuario][:destinatarios] = params[:gzap_usuario][:destinatarios].split(',').map(&:strip)
  end
end
