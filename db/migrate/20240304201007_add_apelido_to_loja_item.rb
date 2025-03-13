class AddApelidoToLojaItem < ActiveRecord::Migration
  def change
    add_column :loja_itens, :apelido, :string
  end
end
