class AddTemInteresseParceriaToEscritorio < ActiveRecord::Migration
  def change
    add_column :escritorios, :tem_interesse_parceria, :boolean, default: true
  end
end
