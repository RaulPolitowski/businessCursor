class Permissao < ActiveRecord::Base
  validates_uniqueness_of :descricao
end
