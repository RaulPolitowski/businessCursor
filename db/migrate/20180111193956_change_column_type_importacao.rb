class ChangeColumnTypeImportacao < ActiveRecord::Migration
  def change
    change_column(:importacoes, :data_importacao, :timestamp)
  end
end
