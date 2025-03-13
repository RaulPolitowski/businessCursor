class AddUserRetornoFila < ActiveRecord::Migration
  def change
    add_column :fila_empresas, :user_retorno_id, :integer
  end
end
