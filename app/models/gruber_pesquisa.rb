class GruberPesquisa < ActiveRecord::Base

  belongs_to :cliente, :class_name => 'Financeiro::ClienteFornecedor'
  has_many :gruber_pesquisa_respostas


  ransacker :created_at do
    Arel::Nodes::SqlLiteral.new("date(created_at)")
  end

  def self.get_media_setores(data_inicio, data_fim)
    connc = GruberPesquisa.connection
    connc.select_all "select setor.id, setor.nome_setor, round(avg(resposta.nota),2) as nota
                                            from gruber_pesquisas pesquisa
                                            inner join gruber_pesquisa_respostas resposta on resposta.gruber_pesquisa_id = pesquisa.id
                                            inner join setores setor on setor.id = resposta.setor_id
                                            where pesquisa.created_at::date between '#{data_inicio}'::date and '#{data_fim}'::date
                                            group by setor.id, setor.nome_setor"
  end

  def self.get_media_servicos(data_inicio, data_fim)
    connc = GruberPesquisa.connection
    connc.select_all "select servico.id, servico.nome_servico, round(avg(resposta.nota),2) as nota
                      from gruber_pesquisas pesquisa
                      inner join gruber_pesquisa_respostas resposta on resposta.gruber_pesquisa_id = pesquisa.id
                      inner join servicos servico on servico.id = resposta.servico_id
                      where pesquisa.created_at::date between '#{data_inicio}'::date and '#{data_fim}'::date
                      group by servico.id, servico.nome_servico"
  end

  def self.get_media_setores_rh(data_inicio, data_fim)
    connc = GruberPesquisa.connection
    connc.select_all "select
                      coalesce(setor_financeiro_nome, 'Sem informação') as setor_financeiro_nome,
                      round(avg(resposta.nota),2) as nota,
                      count(resposta.nota) as qtd_pesquisas
                      from gruber_pesquisas pesquisa
                      inner join gruber_pesquisa_respostas resposta on resposta.gruber_pesquisa_id = pesquisa.id
                      inner join setores setor on setor.id = resposta.setor_id and setor.tipo_setor = 'RH'
                      where pesquisa.created_at::date between '#{data_inicio}'::date and '#{data_fim}'::date
                      group by  coalesce(setor_financeiro_nome, 'Sem informação')"
  end

  def self.get_media_setores_externo(data_inicio, data_fim)
    connc = GruberPesquisa.connection
    connc.select_all "select
                      coalesce(setor_financeiro_nome, 'Sem informação') as setor_financeiro_nome,
                      round(avg(resposta.nota),2) as nota,
                      count(resposta.nota) as qtd_pesquisas
                      from gruber_pesquisas pesquisa
                      inner join gruber_pesquisa_respostas resposta on resposta.gruber_pesquisa_id = pesquisa.id
                      inner join setores setor on setor.id = resposta.setor_id and setor.tipo_setor = 'EXTERNO'
                      where pesquisa.created_at::date between '#{data_inicio}'::date and '#{data_fim}'::date
                      group by  coalesce(setor_financeiro_nome, 'Sem informação')"
  end

  def self.get_media_setores_contabil(data_inicio, data_fim)
    connc = GruberPesquisa.connection
    connc.select_all "select
                      coalesce(setor_financeiro_nome, 'Sem informação') as setor_financeiro_nome,
                      round(avg(resposta.nota),2) as nota,
                      count(resposta.nota) as qtd_pesquisas
                      from gruber_pesquisas pesquisa
                      inner join gruber_pesquisa_respostas resposta on resposta.gruber_pesquisa_id = pesquisa.id
                      inner join setores setor on setor.id = resposta.setor_id and setor.tipo_setor = 'CONTABIL'
                      where pesquisa.created_at::date between '#{data_inicio}'::date and '#{data_fim}'::date
                      group by  coalesce(setor_financeiro_nome, 'Sem informação')"
  end

  def self.get_media_setor_financeiro(data_inicio, data_fim)
    connc = GruberPesquisa.connection
    connc.select_all "select
                      coalesce(setor_financeiro_nome, 'Sem informação') as setor_financeiro_nome,
                      round(avg(resposta.nota),2) as nota,
                      count(resposta.nota) as qtd_pesquisas
                      from gruber_pesquisas pesquisa
                      inner join gruber_pesquisa_respostas resposta on resposta.gruber_pesquisa_id = pesquisa.id
                      inner join setores setor on setor.id = resposta.setor_id and setor.tipo_setor = 'FINANCEIRO'
                      where pesquisa.created_at::date between '#{data_inicio}'::date and '#{data_fim}'::date
                      group by  coalesce(setor_financeiro_nome, 'Sem informação')"
  end

  def self.get_media_setor_atendimento(data_inicio, data_fim)
    connc = GruberPesquisa.connection
    connc.select_all "select
                      coalesce(setor_financeiro_nome, 'Sem informação') as setor_financeiro_nome,
                      round(avg(resposta.nota),2) as nota,
                      count(resposta.nota) as qtd_pesquisas
                      from gruber_pesquisas pesquisa
                      inner join gruber_pesquisa_respostas resposta on resposta.gruber_pesquisa_id = pesquisa.id
                      inner join setores setor on setor.id = resposta.setor_id and setor.tipo_setor = 'ATENDIMENTO'
                      where pesquisa.created_at::date between '#{data_inicio}'::date and '#{data_fim}'::date
                      group by  coalesce(setor_financeiro_nome, 'Sem informação')"
  end

  def self.get_ultima_pesquisa_setor
    GruberPesquisa.select("gruber_pesquisas.*").joins(:gruber_pesquisa_respostas).where("gruber_pesquisa_respostas.setor_id is not null").distinct.order(created_at: :desc).first
  end

  def self.get_penultima_pesquisa_setor
    GruberPesquisa.select("gruber_pesquisas.*").joins(:gruber_pesquisa_respostas).where("gruber_pesquisa_respostas.setor_id is not null").distinct.order(created_at: :desc).second
  end
end
