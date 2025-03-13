class Anexo < ActiveRecord::Base
  belongs_to :cliente
  
  mount_uploader :file, AnexosUploader
end
