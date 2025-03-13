class Status < ActiveRecord::Base
  validates_uniqueness_of :descricao

  scope :all_tipo_ligacao, -> { where(tipo_status: 1).order(:descricao) }
  scope :all_tipo_implantacao, -> { where(tipo_status: 2).order(:descricao) }
  scope :all_desativados_ligacao, -> { where('tipo_status = 2 or id in (9)') }

  def self.buscar_status_by_status(status_id)
      if status_id.nil?
        return Status.where('id in (7, 8, 10, 4, 19, 6, 5, 2)').order(:status_empresa)
      else
        status = Status.find status_id
        if status.status_empresa < 5
          return Status.where('id in (7, 8, 10, 4, 19, 21, 6, 5, 2, 31)').order(:status_empresa)
        else
          return Status.where('id = ?', status.id)
        end
      end
  end
end
