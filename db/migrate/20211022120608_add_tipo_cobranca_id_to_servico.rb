class AddTipoCobrancaIdToServico < ActiveRecord::Migration
  def change
    add_column :servicos, :tipocobranca_id, :integer
  end
end
