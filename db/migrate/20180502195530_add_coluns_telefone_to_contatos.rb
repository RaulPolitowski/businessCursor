class AddColunsTelefoneToContatos < ActiveRecord::Migration
  def change
    add_column :contatos, :telefone3, :string
    add_column :contatos, :telefone4, :string
    add_column :contatos, :celular, :string
    add_column :contatos, :celular2, :string
    add_column :contatos, :celular3, :string
    add_column :contatos, :celular4, :string
  end
end
