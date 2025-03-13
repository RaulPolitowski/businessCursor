class Dashboard < ActiveRecord::Base
  #SOMENTE PARA VALIDAR CANCANCAN

  def self.cnpjs_com_tags_troca_cnpj
    ultimos_meses = (Time.now - 14.months).strftime('%Y-%m-%d')
    cnpjs_com_tags_troca_cnpj = SolicitacaoDesistencia.joins(:cliente).apenas_tags_troca_cnpj.where("data_solicitacao::DATE >= '#{ultimos_meses}'::DATE").pluck(:cnpj)
    cnpjs_com_tags_troca_cnpj.join(', ')
  end
end
