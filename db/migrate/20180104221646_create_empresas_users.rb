class CreateEmpresasUsers < ActiveRecord::Migration
  def change
    create_table :empresas_users do |t|
      t.belongs_to :user
      t.belongs_to :empresa
    end
  end
end
