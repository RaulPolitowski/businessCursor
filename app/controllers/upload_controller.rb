class UploadController < ApplicationController
  
  def create
    if params[:cliente].present?      
      cliente = Cliente.find params[:cliente]
      anexo = Anexo.new(cliente: cliente)
    elsif params[:desistencia].present?  
      anexo = Anexo.new(solicitacao_desistencia_id: params[:desistencia])
    end

    anexo.file = params[:file]

    if anexo.save!
      render json: anexo, status: 201
    else
      render json:{message: anexo.errors}, status: 500
    end
  end

  def download_file
    upload = Anexo.find params[:id]
    puts upload.file.path
    puts upload.file
    send_file upload.file.path, disposition: 'inline'
  end

  def remove_file
    upload = Anexo.find params[:id]
    cliente = Cliente.find upload.cliente_id if upload.cliente_id.present?
        
    upload.remove_file!
    
    if upload.destroy!
      if upload.cliente_id.present?
        render json: cliente
      else
        desistencia = SolicitacaoDesistencia.find upload.solicitacao_desistencia_id
        render json: desistencia
      end
    end
    
  end
    
end