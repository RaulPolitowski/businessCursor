class AddDataAvaliacaoToPeriodoInerte < ActiveRecord::Migration
  def change
    add_column :periodo_inertes, :data_avaliacao, :timestamp
    add_column :periodo_inertes, :user_avaliacao_id, :integer
  end
end
