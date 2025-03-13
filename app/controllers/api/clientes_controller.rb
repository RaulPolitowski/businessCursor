module Api
  class Api::ClientesController < ApplicationController
    before_action :validate_cnpj, only: [:dados_cliente]

    def dados_cliente_fechamento
      cliente = Cliente.find_by_cnpj params[:cpfcnpj]
      return render json: { errors: [ "Cliente não localizado"]}, status: 404 if cliente.nil?

      fechamento = cliente.fechamento
      return render json: { errors: [ "Cliente não tem fechamento"]}, status: 404 if fechamento.nil?


     render json: ActiveModelSerializers::SerializableResource.new(fechamento).as_json

      # render json: cliente, status: 200, each_serializer: ClienteShortSerializer
    end

    private

    def forma_params
      params.permit(:descricao, :avista, :referencia, :cartao)
    end

    def validate_cnpj
      return render json: { errors: [ "CPF/CNPJ deve ser informado"]}, status: 400 if params[:cpfcnpj].nil?
    end
  end
end
