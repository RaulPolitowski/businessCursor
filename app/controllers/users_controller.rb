class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_filter :authorize_admin, only: [:create, :new, :edit, :index]
  before_action :set_usuario, only: [:edit, :update, :destroy, :editar_usuario, :alterar_senha, :desativar]

  def index
    unless current_user.admin?
      return redirect_to root_path, alert: 'Você não tem acesso a esse cadastro'
    end

    @users = User.where(active: true)
    @users_inativos = User.where(active: false)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        flash[:success] = 'Usuário criado com sucesso'
        format.html { redirect_to users_path }
      else
        flash[:error] = @user.errors.full_messages.to_sentence
        format.html { render action: 'new' }
      end
    end
  end

  def edit
  end

  def avatar
    if current_user.avatar.file.exists?
      begin
        send_file "#{current_user.avatar.url(:size50)}", disposition: 'inline', type: "application/jpg", x_sendfile: true
      rescue
        send_file "#{Rails.root.join('tmp').to_s}/avatar.png", disposition: 'inline', type: "application/jpg", x_sendfile: true
      end
    else
      send_file "#{Rails.root.join('tmp').to_s}/avatar.png", disposition: 'inline', type: "application/jpg", x_sendfile: true
    end
  end

  def avatar_user
    @user = User.find params[:id]
    if @user.avatar.present?
      begin
        send_file "#{@user.avatar.url(:size50)}",:disposition => 'inline', :type=>"application/jpg", :x_sendfile=>true
      rescue
        send_file "#{Rails.root.join('tmp').to_s}/avatar.png", :disposition => 'inline', :type=>"application/jpg", :x_sendfile=>true
      end
    else
      send_file "#{Rails.root.join('tmp').to_s}/avatar.png", :disposition => 'inline', :type=>"application/jpg", :x_sendfile=>true
    end
  end

  def editar_usuario
  end

  def alterar_senha
      @user = current_user
      @user.password = params[:password]
      @user.password_confirmation =  params[:password_confirmation]

      if @user.save
        render json: @user
      else
        render :json => { :success => false }, :status => 422
      end
  end

  def alterar_empresa
    session[:empresa_id] = params[:empresa_id]

    flash[:success] = 'Empresa alterada com sucesso.'
    render json: session[:empresa_id], :status => 200
  end

  def update
    respond_to do |format|
      if @user.update(user_update_params)
        @user.password = params['user']['password'] if params['user']['password'].present?
        @user.password_confirmation = params['user']['password_confirmation'] if params['user']['password_confirmation'].present?
        @user.save
        flash[:success] = 'Usuário alterado com sucesso'
        format.html { redirect_to root_path } if !current_user.admin?
        format.html { redirect_to users_path } if current_user.admin?
      else
        flash[:error] =  @user.errors.full_messages.to_sentence
        format.html { render action: 'editar_usuario' } if !current_user.admin?
        format.html { render action: 'edit' } if current_user.admin?
      end
    end
  end

  def find_usuarios
    @users = User.includes(:empresas).where("empresas_users.empresa_id" => current_empresa.id).where("upper(unaccent(name)) LIKE upper(unaccent('%#{params[:term]}%')) ").where(active: true).order(:name).limit(5)

    render json: @users
  end

  def find_usuarios_agenda
    @users = User.joins(:empresas, :permissao).where("empresas_users.empresa_id" => current_empresa.id, "permissoes.agenda" => true).where("upper(unaccent(name)) LIKE upper(unaccent('%#{params[:term]}%')) ").where(active: true).order(:name).limit(5)

    render json: @users
  end

  def get_current_empresa_id
    render json: current_empresa.id
  end

  def get_current_empresa
    render json: current_empresa
  end

  def set_preference
    session[:menu_hide] = params[:hide]
    render :json => { :success => true }, :status => 200
  end

  def find_usuario_by_name
    @user = User.find_by_name params[:name]

    render json: @user
  end

  def find_usuario_by_id
    @user = User.find params[:id]

    render json: @user
  end

  def implantacao_em_andamento
    render json: current_user.implantacao_id
  end

  def inverter_status_ocupado
    if current_user.ocupado == false
      data_fim = Time.now + params[:tempo].to_i * 60 
      NaoPerturbeRetorno.create(user_id: current_user.id, data_fim: data_fim)
      current_user.update(ocupado: true)
    else
      current_user.update(ocupado: false)
    end
    render json: current_user
  end

  def desativar
    @user.active = false

    @user.save

    redirect_to :back
  end

  def qtd_numeros_autenticados
    qtd_total = WhatsappNumero.joins("left join loja_itens li on li.numero = whatsapp_numeros.numero")
      .where(banido: false, status: 'CONECTADO', is_ocultado: false, user_id: [params[:ids].split(',')])
      .where("li.status = 'COMPRADO' or (li.id IS NUll AND li.status IS NULL)")
      .count
    render json: qtd_total
  end

  private

  def set_usuario
    @user = current_user.admin? ? User.find(params[:id].present? ? params[:id] : current_user.id) : current_user
  end

  def user_params
    params[:user].permit(:name, :email, :password, :password_confirmation, :avatar, :admin, :active, :color, {:empresa_ids => []}, :permissao_id, :job_id, :tipo_comissao)
  end

  def user_update_params
    params[:user].permit(:name, :email, :avatar, :admin, :active, :color, {:empresa_ids => []}, :permissao_id, :job_id, :notificacao_agenda_cancelada,
    :notificacao_implantacao, :notificacao_implantacao_atraso, :tipo_comissao, :telefone)
  end

end