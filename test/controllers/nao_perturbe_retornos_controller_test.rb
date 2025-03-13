require 'test_helper'

class NaoPerturbeRetornosControllerTest < ActionController::TestCase
  setup do
    @nao_perturbe_retorno = nao_perturbe_retornos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:nao_perturbe_retornos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create nao_perturbe_retorno" do
    assert_difference('NaoPerturbeRetorno.count') do
      post :create, nao_perturbe_retorno: { data_fim: @nao_perturbe_retorno.data_fim, user_id: @nao_perturbe_retorno.user_id }
    end

    assert_redirected_to nao_perturbe_retorno_path(assigns(:nao_perturbe_retorno))
  end

  test "should show nao_perturbe_retorno" do
    get :show, id: @nao_perturbe_retorno
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @nao_perturbe_retorno
    assert_response :success
  end

  test "should update nao_perturbe_retorno" do
    patch :update, id: @nao_perturbe_retorno, nao_perturbe_retorno: { data_fim: @nao_perturbe_retorno.data_fim, user_id: @nao_perturbe_retorno.user_id }
    assert_redirected_to nao_perturbe_retorno_path(assigns(:nao_perturbe_retorno))
  end

  test "should destroy nao_perturbe_retorno" do
    assert_difference('NaoPerturbeRetorno.count', -1) do
      delete :destroy, id: @nao_perturbe_retorno
    end

    assert_redirected_to nao_perturbe_retornos_path
  end
end
