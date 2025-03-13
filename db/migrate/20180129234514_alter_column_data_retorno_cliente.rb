class AlterColumnDataRetornoCliente < ActiveRecord::Migration
  def change
    change_column :clientes, :data_retorno, :datetime
  end
end
