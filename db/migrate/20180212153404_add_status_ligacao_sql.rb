class AddStatusLigacaoSql < ActiveRecord::Migration
  def change
    execute <<-SQL
          INSERT INTO STATUS_LIGACOES(ID, DESCRICAO, CREATED_AT, UPDATED_AT) VALUES (6, 'Escritório Contábil', '2018-01-01', '2018-01-01');
    SQL
  end
end
