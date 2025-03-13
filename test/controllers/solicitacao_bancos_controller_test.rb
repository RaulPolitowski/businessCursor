require 'test_helper'

class SolicitacaoBancosControllerTest < ActionController::TestCase
  setup do
    @solicitacao_banco = solicitacao_bancos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:solicitacao_bancos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create solicitacao_banco" do
    assert_difference('SolicitacaoBanco.count') do
      post :create, solicitacao_banco: { ativo: @solicitacao_banco.ativo, cliente: @solicitacao_banco.cliente, finalizado: @solicitacao_banco.finalizado, motivo_desativacao: @solicitacao_banco.motivo_desativacao, motivo_solicitacao: @solicitacao_banco.motivo_solicitacao, observacao: @solicitacao_banco.observacao, status: @solicitacao_banco.status, tipo: @solicitacao_banco.tipo, user: @solicitacao_banco.user }
    end

    assert_redirected_to solicitacao_banco_path(assigns(:solicitacao_banco))
  end

  test "should show solicitacao_banco" do
    get :show, id: @solicitacao_banco
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @solicitacao_banco
    assert_response :success
  end

  test "should update solicitacao_banco" do
    patch :update, id: @solicitacao_banco, solicitacao_banco: { ativo: @solicitacao_banco.ativo, cliente: @solicitacao_banco.cliente, finalizado: @solicitacao_banco.finalizado, motivo_desativacao: @solicitacao_banco.motivo_desativacao, motivo_solicitacao: @solicitacao_banco.motivo_solicitacao, observacao: @solicitacao_banco.observacao, status: @solicitacao_banco.status, tipo: @solicitacao_banco.tipo, user: @solicitacao_banco.user }
    assert_redirected_to solicitacao_banco_path(assigns(:solicitacao_banco))
  end

  test "should destroy solicitacao_banco" do
    assert_difference('SolicitacaoBanco.count', -1) do
      delete :destroy, id: @solicitacao_banco
    end

    assert_redirected_to solicitacao_bancos_path
  end
end
