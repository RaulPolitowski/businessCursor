require 'test_helper'

class AbordagemIniciaisControllerTest < ActionController::TestCase
  setup do
    @abordagem_inicial = abordagem_iniciais(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:abordagem_iniciais)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create abordagem_inicial" do
    assert_difference('AbordagemInicial.count') do
      post :create, abordagem_inicial: { texto: @abordagem_inicial.texto }
    end

    assert_redirected_to abordagem_inicial_path(assigns(:abordagem_inicial))
  end

  test "should show abordagem_inicial" do
    get :show, id: @abordagem_inicial
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @abordagem_inicial
    assert_response :success
  end

  test "should update abordagem_inicial" do
    patch :update, id: @abordagem_inicial, abordagem_inicial: { texto: @abordagem_inicial.texto }
    assert_redirected_to abordagem_inicial_path(assigns(:abordagem_inicial))
  end

  test "should destroy abordagem_inicial" do
    assert_difference('AbordagemInicial.count', -1) do
      delete :destroy, id: @abordagem_inicial
    end

    assert_redirected_to abordagem_iniciais_path
  end
end
