class AddStatusLigacaoRefToLigacao < ActiveRecord::Migration
  def change
    add_reference :ligacoes, :status_ligacao, index: true, foreign_key: true
  end
end
