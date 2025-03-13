class Parametro < ActiveRecord::Base
  belongs_to :empresa
  belongs_to :user_job1, class_name: 'User'
  belongs_to :user_job2, class_name: 'User'
end
