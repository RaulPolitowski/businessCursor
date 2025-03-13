class StatusLigacao < ActiveRecord::Base

  def is_nao_atende?
    [3, 4].include? id
  end

  def is_numero_errado?
    [1, 2].include? id
  end

end
