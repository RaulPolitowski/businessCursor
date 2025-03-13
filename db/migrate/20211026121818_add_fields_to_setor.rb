class AddFieldsToSetor < ActiveRecord::Migration
  def change
    add_column :setores, :setor_financeiro_id, :integer
    add_column :setores, :tipo_setor, :string
  end
end
