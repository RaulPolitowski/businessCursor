class AddColumnsToContato < ActiveRecord::Migration
  def change
    add_column :contatos, :cpf, :string
    add_column :contatos, :telefone2, :string
  end
end
