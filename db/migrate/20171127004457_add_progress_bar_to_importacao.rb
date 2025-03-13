class AddProgressBarToImportacao < ActiveRecord::Migration
  def change
    add_reference :importacoes, :progress_bar, index: true
  end
end
