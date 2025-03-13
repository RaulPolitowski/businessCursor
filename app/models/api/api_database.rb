class Api::ApiDatabase < ActiveRecord::Base
  self.abstract_class = true
  establish_connection Rails.configuration.database_configuration["api_#{Rails.env}"]
end