class Chamado::ChamadoDatabase < ActiveRecord::Base
  self.abstract_class = true
  establish_connection Rails.configuration.database_configuration["chamado_#{Rails.env}"]
end