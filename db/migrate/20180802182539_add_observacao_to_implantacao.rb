class AddObservacaoToImplantacao < ActiveRecord::Migration
  def change
    add_column :implantacoes, :observacao, :text
  end
end
