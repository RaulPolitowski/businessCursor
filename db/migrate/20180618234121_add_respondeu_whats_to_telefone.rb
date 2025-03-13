class AddRespondeuWhatsToTelefone < ActiveRecord::Migration
  def change
    add_column :telefones, :respondeu_whats, :boolean, default: false
  end
end
