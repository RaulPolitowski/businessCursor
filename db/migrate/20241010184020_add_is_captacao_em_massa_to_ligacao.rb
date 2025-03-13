class AddIsCaptacaoEmMassaToLigacao < ActiveRecord::Migration
  def change
    add_column :ligacoes, :is_captacao_coletiva, :boolean, default: false
  end
end