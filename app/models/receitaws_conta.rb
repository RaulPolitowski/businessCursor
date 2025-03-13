class ReceitawsConta < ActiveRecord::Base

  def self.verificar_contas
    contas = ReceitawsConta.all
    url = "https://receitaws.com.br/v1/account/quota"
    contas.each do |conta|
      begin
        response = Api::GetConsumer.call url, { Authorization: "Bearer #{conta.chave}" }
        if response['quota']['from_external'] > 0
          conta.update(qtd_usada: (30000 - response['quota']['from_external'].to_i))
          next
        end
        conta.update(qtd_usada: 30000)
      rescue Exception => ex
        puts ex
        conta.update(qtd_usada: 30000)
        next
      end
    end
  end
end
