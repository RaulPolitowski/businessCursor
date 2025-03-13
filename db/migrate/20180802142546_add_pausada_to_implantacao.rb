class AddPausadaToImplantacao < ActiveRecord::Migration
  def change
    add_column :implantacoes, :pausada, :boolean, default: false
  end
end
