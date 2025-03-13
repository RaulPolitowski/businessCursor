json.array!(@solicitacao_desistencias) do |solicitacao_desistencia|
  json.extract! solicitacao_desistencia, :id, :cliente_id, :empresa_id, :user_id, :status, :data_solicitacao, :motivo, :solicitante, :telefone
  json.url solicitacao_desistencia_url(solicitacao_desistencia, format: :json)
end
