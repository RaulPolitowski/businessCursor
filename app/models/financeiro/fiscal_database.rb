class Financeiro::FiscalDatabase < ActiveRecord::Base
  self.abstract_class = true
  establish_connection Rails.configuration.database_configuration["fiscal_#{Rails.env}"]
end