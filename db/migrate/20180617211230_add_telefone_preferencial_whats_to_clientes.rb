class AddTelefonePreferencialWhatsToClientes < ActiveRecord::Migration
  def change
    add_column :clientes, :telefone_preferencial, :boolean, default: false
    add_column :clientes, :telefone2_preferencial, :boolean, default: false
    add_column :clientes, :telefone_enviado_whats, :boolean, default: false
    add_column :clientes, :telefone2_enviado_whats, :boolean, default: false
  end
end
