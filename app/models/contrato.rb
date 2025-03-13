class Contrato < ActiveRecord::Base
    validates_presence_of :nome, :descricao, :texto
end
