class AddAnteriorToCliente < ActiveRecord::Migration
  def change
    add_column :clientes, :implantacao_old, :integer
    add_column :clientes, :acompanhamento_old, :integer
  end
end
