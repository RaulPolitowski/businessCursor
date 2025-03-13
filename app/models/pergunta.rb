class Pergunta < ActiveRecord::Base
  belongs_to :pergunta_gatilho, class_name: 'Pergunta'
end
