class Sistema < ActiveRecord::Base
  validates_uniqueness_of :nome
end
