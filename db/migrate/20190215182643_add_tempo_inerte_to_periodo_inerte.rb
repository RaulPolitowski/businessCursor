class AddTempoInerteToPeriodoInerte < ActiveRecord::Migration
  def change
    add_column :periodo_inertes, :tempo_inerte, :integer
    add_column :periodo_inertes, :last_login, :timestamp
  end
end
