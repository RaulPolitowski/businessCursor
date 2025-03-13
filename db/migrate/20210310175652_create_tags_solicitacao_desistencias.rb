class CreateTagsSolicitacaoDesistencias < ActiveRecord::Migration
  def change
    drop_table :tags_solicitacao_desistencias

    create_table :tags_solicitacao_desistencias do |t|
      t.string :descricao

    end

    execute <<-SQL
      INSERT INTO tags_solicitacao_desistencias (descricao) VALUES ('FECHOU EMPRESA');
      INSERT INTO tags_solicitacao_desistencias (descricao) VALUES ('PREÇO');
      INSERT INTO tags_solicitacao_desistencias (descricao) VALUES ('INSATISFAÇÃO COM DESEMPENHO SISTEMA');
      INSERT INTO tags_solicitacao_desistencias (descricao) VALUES ('INSATISFAÇÃO COM ATENDIMENTO');
      INSERT INTO tags_solicitacao_desistencias (descricao) VALUES ('FALTOU ALGUMA FERRAMENTA IMPRESCINDÍVEL');
      INSERT INTO tags_solicitacao_desistencias (descricao) VALUES ('CONTADOR INDICOU OUTRO');
      INSERT INTO tags_solicitacao_desistencias (descricao) VALUES ('PARALISOU ATIVIDADES');
      INSERT INTO tags_solicitacao_desistencias (descricao) VALUES ('COBRANÇA INDEVIDA');
    SQL
  end
end
