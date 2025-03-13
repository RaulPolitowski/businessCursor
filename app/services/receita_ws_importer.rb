# class ReceitaWsImporter

#   attr_reader :cnpj, :tempo

#   def initialize(cnpj, tempo)
#     @cnpj = cnpj
#     @tempo = tempo
#   end

#   def import
#     receitaws = ReceitawsConta.where('qtd_disponivel <> qtd_usada').where.not(id: 4).order(:id).first
#     puts "Conta ReceitaWS: #{receitaws}"
#     return nil if receitaws.nil?
#     begin
#       response = call(receitaws.chave)

#       if response['status'].eql?('ERROR') && response['message'].present? && response['message'].eql?('Quota Exceeded')
#         receitaws.update(qtd_usada: receitaws.qtd_disponivel)
#         return import
#       end

#       response
#     rescue Exception => ex
#       puts ex
#       if ex.present? && ex.http_code.present? && ex.http_code == 402
#         receitaws.update(qtd_usada: receitaws.qtd_disponivel)
#         return import
#       end
#       nil
#     end
#   end

#   def call(chave)
#     Api::GetConsumer.call ENV["receitaws"] % [cnpj, tempo], { x_api_token: "Bearer #{chave}" }, timeout: 120
#   end

# end

