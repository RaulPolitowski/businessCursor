class AddHistToComentarios < ActiveRecord::Migration
  def change
    add_column :comentarios, :historico_id, :integer
    add_column :clientes, :hist_impl_id, :integer
    add_column :clientes, :hist_acomp_id, :integer
    add_column :agendamentos, :historico_id, :integer

    remove_column :clientes, :implantacao_old, :integer
    remove_column :clientes, :acompanhamento_old, :integer
  end
end
