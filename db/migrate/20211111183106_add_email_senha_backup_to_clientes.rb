class AddEmailSenhaBackupToClientes < ActiveRecord::Migration
  def change
    add_column :clientes, :email_backup, :string
    add_column :clientes, :senha_backup, :string
  end
end
