# Preview all emails at http://localhost:3000/rails/mailers/solicitacao_desistencia_mailer
class SolicitacaoDesistenciaMailerPreview < ActionMailer::Preview

  def new_solitacao_desistencia_preview
    SolicitacaoDesistenciaMailer.new_solitacao_desistencia('Rebecca', 'thaismayara.tmsb@gmail.com', 'RIO E MAR', '123456/0001-12')
  end
end
