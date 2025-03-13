class AddTelefoneWhatsToContatos < ActiveRecord::Migration
  def change
    add_column :contatos, :telefone_preferencial, :boolean, default: false
    add_column :contatos, :telefone_whats, :boolean, default: false
  end
end
