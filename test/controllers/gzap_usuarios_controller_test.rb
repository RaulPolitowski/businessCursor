require 'test_helper'

class GzapUsuariosControllerTest < ActionController::TestCase
  setup do
    @gzap_usuario = gzap_usuarios(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:gzap_usuarios)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create gzap_usuario" do
    assert_difference('GzapUsuario.count') do
      post :create, gzap_usuario: { destinatarios: @gzap_usuario.destinatarios, name: @gzap_usuario.name, user_id: @gzap_usuario.user_id }
    end

    assert_redirected_to gzap_usuario_path(assigns(:gzap_usuario))
  end

  test "should show gzap_usuario" do
    get :show, id: @gzap_usuario
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @gzap_usuario
    assert_response :success
  end

  test "should update gzap_usuario" do
    patch :update, id: @gzap_usuario, gzap_usuario: { destinatarios: @gzap_usuario.destinatarios, name: @gzap_usuario.name, user_id: @gzap_usuario.user_id }
    assert_redirected_to gzap_usuario_path(assigns(:gzap_usuario))
  end

  test "should destroy gzap_usuario" do
    assert_difference('GzapUsuario.count', -1) do
      delete :destroy, id: @gzap_usuario
    end

    assert_redirected_to gzap_usuarios_path
  end
end
