class SolicitacaoBanco < ActiveRecord::Base
    include PublicActivity::Model

    mount_uploader :file, DatabaseUploader

    belongs_to :user
    belongs_to :responsavel, class_name: "User"
    belongs_to :desativado_por, class_name: "User"
    belongs_to :cliente
    belongs_to :empresa
end
