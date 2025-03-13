class Api::Company < Api::ApiDatabase
  self.table_name = 'companies'

  def count_days_dont_access
    if last_login.present?
      TimeDifference.between(Time.now, last_login).in_days
    else
      TimeDifference.between(Time.now, created_at.to_date).in_days
    end
  end

  def self.all_cnpj_system
    companies = Api::Company.all
    hash = Array.new
    companies.each do |company|
      hash << {cnpj: company.cnpj, system: Cliente.human_system(company.system)}
    end
    return hash
  end

end
