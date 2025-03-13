class ApplicationController < ActionController::Base
  # include ExceptionLogger::ExceptionLoggable # loades the module
  # rescue_from Exception, :with => :log_exception_handler # tells rails to forward the 'Exception' (you can change the type) to the handler of the module
  before_action :authenticate_user!, unless: -> { request_report? || request_api? }
  before_action :valid_token, if: -> { request_api? }

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery  with: :exception
  protect_from_forgery unless: -> { request.format.json? }

  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:username, :email, :password,
                                                               :password_confirmation, :remember_me, :avatar, :avatar_cache, :remove_avatar, :name) }
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:username, :email, :password,
                                                                      :password_confirmation, :current_password, :avatar, :avatar_cache, :remove_avatar, :name) }
  end

  def current_empresa
    reset_session if session[:empresa_id].nil?
    @current_empresa ||= Empresa.where(id: session[:empresa_id]).first
  end

  def parametros_vigente
    @parametro_vigente ||= Parametro.find_by_empresa_id session[:empresa_id]
  end

  def get_preference_menu
    session[:menu_hide] ||= "true"
  end

  def authorize_admin
    return unless !current_user.admin?
    redirect_to root_path, alert: 'Acesso não autorizado!'
  end

  def request_report?
    ['recebimento_primeira_mensalidade_json', 'projecao_clientes_novos_json', 'pesquisa_satisfacao_json', 'analise_vendedor_json',
     'analise_pci_json', 'find_cidades', 'analise_cliente_json', 'periodo_inertes_json', 'comissionamento_mensalidades_json',
    'criar_notificacao_arquivo_retorno', 'relatorio_atividades_ecf_json', 'analise_desistencias_json', 'analise_bloqueados_paralisados_json',
     'cobranca_primeira_mensalidade_json', 'contratos_assinados_json', 'lancar_desistencia', 'reimportar_empresas'
    ].include? request.filtered_parameters['action']
  end

  def request_api?
    ['dados_cliente_fechamento'].include? request.filtered_parameters['action']
  end

  def valid_token
    # byebug
    #11586637000128 Germantech CNPJ
    time = Time.new
    #Solucao temporaria até virar o ano
    if Time.now.year.eql? 2019
      code = time.strftime("202011586637000128%m%-d")
    else
      code = time.strftime("%Y11586637000128%m%-d")
    end

    return render json: { errors: [ "Token inválido."]}, status: 401 unless request.headers['Authorization'] == Digest::MD5.hexdigest(code)
  end

  def string_is_number? string
    true if Float(string) rescue false
  end

    rescue_from CanCan::AccessDenied do |exception|
      redirect_to root_url, :alert => exception.message
    end

  helper_method :current_empresa, :parametros_vigente, :get_preference_menu
end
