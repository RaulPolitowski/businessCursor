class AddBaixadoToImplantacao < ActiveRecord::Migration
  def change
    add_column :implantacoes, :baixado, :boolean, default: false
    add_column :implantacoes, :conferido, :boolean, default: false
  end
end
