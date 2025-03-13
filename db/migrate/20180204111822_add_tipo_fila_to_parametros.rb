class AddTipoFilaToParametros < ActiveRecord::Migration
  def change
    add_column :parametros, :tipo_fila, :integer
  end
end
