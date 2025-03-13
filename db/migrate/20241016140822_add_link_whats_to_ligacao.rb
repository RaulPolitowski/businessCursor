class AddLinkWhatsToLigacao < ActiveRecord::Migration
  def change
    add_column :ligacoes, :link_whats, :string
  end
end
