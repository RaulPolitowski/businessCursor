class SolicitacaoDesistenciaMailer < ApplicationMailer

  def new_solitacao_desistencia(user, email, empresa, cnpj)
    @user = user
    @empresa = empresa
    @cnpj = cnpj

    mail(to: email, subject: "Solicitação de cancelamento - #{empresa}")
  end
end
