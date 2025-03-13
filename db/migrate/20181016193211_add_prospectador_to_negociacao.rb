class AddProspectadorToNegociacao < ActiveRecord::Migration
  def change
    add_column :negociacoes, :prospectador_id, :integer
  end
end
