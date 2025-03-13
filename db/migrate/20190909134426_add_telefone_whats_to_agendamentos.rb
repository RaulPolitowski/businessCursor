class AddTelefoneWhatsToAgendamentos < ActiveRecord::Migration
  def change
    add_column :agendamentos, :telefone_preferencial, :boolean, default: false
    add_column :agendamentos, :telefone_preferencial2, :boolean, default: false
    add_column :agendamentos, :telefone_whats, :boolean, default: false
    add_column :agendamentos, :telefone_whats2, :boolean, default: false
  end
end
