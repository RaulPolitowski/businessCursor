require 'test_helper'

class ReceitawsContasControllerTest < ActionController::TestCase
  setup do
    @receitaws_conta = receitaws_contas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:receitaws_contas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create receitaws_conta" do
    assert_difference('ReceitawsConta.count') do
      post :create, receitaws_conta: { chave: @receitaws_conta.chave, dia_renovacao: @receitaws_conta.dia_renovacao, nome: @receitaws_conta.nome, qtd_disponivel: @receitaws_conta.qtd_disponivel, qtd_usada: @receitaws_conta.qtd_usada }
    end

    assert_redirected_to receitaws_conta_path(assigns(:receitaws_conta))
  end

  test "should show receitaws_conta" do
    get :show, id: @receitaws_conta
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @receitaws_conta
    assert_response :success
  end

  test "should update receitaws_conta" do
    patch :update, id: @receitaws_conta, receitaws_conta: { chave: @receitaws_conta.chave, dia_renovacao: @receitaws_conta.dia_renovacao, nome: @receitaws_conta.nome, qtd_disponivel: @receitaws_conta.qtd_disponivel, qtd_usada: @receitaws_conta.qtd_usada }
    assert_redirected_to receitaws_conta_path(assigns(:receitaws_conta))
  end

  test "should destroy receitaws_conta" do
    assert_difference('ReceitawsConta.count', -1) do
      delete :destroy, id: @receitaws_conta
    end

    assert_redirected_to receitaws_contas_path
  end
end
