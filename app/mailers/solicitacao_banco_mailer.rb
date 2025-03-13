class SolicitacaoBancoMailer < ApplicationMailer

    def new_solitacao_banco(user, email, empresa, cnpj)
      @user = user
      @empresa = empresa
      @cnpj = cnpj
  
      mail(to: email, subject: "Solicitação de banco de dados da empresa - #{empresa}")
    end
  end