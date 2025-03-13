require 'test_helper'

class SolicitacaoDesistenciasControllerTest < ActionController::TestCase
  setup do
    @solicitacao_desistencia = solicitacao_desistencias(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:solicitacao_desistencias)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create solicitacao_desistencia" do
    assert_difference('SolicitacaoDesistencia.count') do
      post :create, solicitacao_desistencia: { cliente_id: @solicitacao_desistencia.cliente_id, data_solicitacao: @solicitacao_desistencia.data_solicitacao, empresa_id: @solicitacao_desistencia.empresa_id, motivo: @solicitacao_desistencia.motivo, solicitante: @solicitacao_desistencia.solicitante, status: @solicitacao_desistencia.status, telefone: @solicitacao_desistencia.telefone, user_id: @solicitacao_desistencia.user_id }
    end

    assert_redirected_to solicitacao_desistencia_path(assigns(:solicitacao_desistencia))
  end

  test "should show solicitacao_desistencia" do
    get :show, id: @solicitacao_desistencia
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @solicitacao_desistencia
    assert_response :success
  end

  test "should update solicitacao_desistencia" do
    patch :update, id: @solicitacao_desistencia, solicitacao_desistencia: { cliente_id: @solicitacao_desistencia.cliente_id, data_solicitacao: @solicitacao_desistencia.data_solicitacao, empresa_id: @solicitacao_desistencia.empresa_id, motivo: @solicitacao_desistencia.motivo, solicitante: @solicitacao_desistencia.solicitante, status: @solicitacao_desistencia.status, telefone: @solicitacao_desistencia.telefone, user_id: @solicitacao_desistencia.user_id }
    assert_redirected_to solicitacao_desistencia_path(assigns(:solicitacao_desistencia))
  end

  test "should destroy solicitacao_desistencia" do
    assert_difference('SolicitacaoDesistencia.count', -1) do
      delete :destroy, id: @solicitacao_desistencia
    end

    assert_redirected_to solicitacao_desistencias_path
  end
end
