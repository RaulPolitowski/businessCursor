class AddRespondeuWhatsToCliente < ActiveRecord::Migration
  def change
    add_column :clientes, :telefone_respondeu_whats, :boolean
    add_column :clientes, :telefone2_respondeu_whats, :boolean
  end
end
