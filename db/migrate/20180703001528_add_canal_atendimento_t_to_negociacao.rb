class AddCanalAtendimentoTToNegociacao < ActiveRecord::Migration
  def change
    add_column :negociacoes, :atendimento_whatsapp, :boolean, default: false
    add_column :negociacoes, :atendimento_telefone, :boolean, default: false
  end
end
