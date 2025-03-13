class Lembrete < ActiveRecord::Base
  belongs_to :empresa
  belongs_to :user_registro, class_name: 'User'
  belongs_to :user_lembrete, class_name: 'User'
end
